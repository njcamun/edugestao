import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/layout/adaptive.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/mensalidade.dart';
import '../../domain/entities/utilizador.dart';
import '../../domain/entities/sync_entity.dart';
import '../../state/session.dart';
import 'finance_controller.dart';
import '../students/students_controller.dart';
import 'widgets/receipt_pdf_generator.dart';
import 'widgets/payment_confirmation_dialog.dart';
import 'widgets/payment_details_dialog.dart';

class FinancePage extends ConsumerWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredFinance = ref.watch(filteredFinanceProvider);
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterBar(context, ref, isAdmin, filteredFinance),
          SizedBox(height: context.isMediumOrSmaller ? 14 : 24),
          
          Expanded(
            child: filteredFinance.isEmpty 
              ? _buildEmptyState(ref.watch(financeSearchProvider).isNotEmpty || ref.watch(financeStatusFilterProvider) != null)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredFinance.length,
                  itemBuilder: (context, index) {
                    final item = filteredFinance[index];
                    return _FinanceListItem(item: item, currencyFmt: currencyFmt);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref, bool isAdmin, List<Mensalidade> filteredList) {
    final status = ref.watch(financeStatusFilterProvider);
    final month = ref.watch(financeMonthFilterProvider);

    // Lista de nomes de meses em português
    final List<String> meses = [
      'JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO',
      'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => ref.read(financeSearchProvider.notifier).state = val,
                  decoration: const InputDecoration(
                    hintText: 'PESQUISAR POR NOME DO ALUNO...',
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (isAdmin && filteredList.isNotEmpty)
                IconButton(
                  onPressed: () => _confirmBulkDelete(context, ref, filteredList),
                  icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                  tooltip: 'Excluir Todos os Filtrados',
                ),
            ],
          ),
          const Divider(color: Colors.black12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'TODOS', 
                  isSelected: status == null, 
                  onTap: () => ref.read(financeStatusFilterProvider.notifier).state = null
                ),
                _FilterChip(
                  label: 'PENDENTES', 
                  isSelected: status == 'pendente', 
                  onTap: () => ref.read(financeStatusFilterProvider.notifier).state = 'pendente'
                ),
                _FilterChip(
                  label: 'PAGOS', 
                  isSelected: status == 'pago', 
                  onTap: () => ref.read(financeStatusFilterProvider.notifier).state = 'pago'
                ),
                _FilterChip(
                  label: 'ATRASADOS', 
                  isSelected: status == 'atrasado', 
                  onTap: () => ref.read(financeStatusFilterProvider.notifier).state = 'atrasado'
                ),
                const SizedBox(width: 8, child: VerticalDivider()),
                DropdownButton<int?>(
                  value: month,
                  hint: const Text('MÊS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('TODOS MESES')),
                    ...List.generate(12, (i) => DropdownMenuItem(
                      value: i + 1, 
                      child: Text(meses[i], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
                    )),
                  ],
                  onChanged: (val) => ref.read(financeMonthFilterProvider.notifier).state = val,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBulkDelete(BuildContext context, WidgetRef ref, List<Mensalidade> list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('EXCLUIR EM MASSA', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text('TEM A CERTEZA QUE DESEJA ELIMINAR AS ${list.length} COBRANÇAS FILTRADAS DEFINITIVAMENTE?\n\n'
            '⚠️ ISTO REMOVERÁ TODOS OS DADOS E PAGAMENTOS ASSOCIADOS DO SISTEMA E DA CLOUD.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A EXCLUIR REGISTOS...')));
              final repo = ref.read(financeRepositoryProvider);
              try {
                for (var item in list) {
                  await repo.deleteMensalidadePermanent(item.id);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('REGISTOS ELIMINADOS COM SUCESSO!'), backgroundColor: Colors.green));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ERRO AO EXCLUIR: $e'), backgroundColor: Colors.red));
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('EXCLUIR TUDO', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isFiltering) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: AppTokens.border),
          const SizedBox(height: 16),
          Text(
            isFiltering ? 'NENHUM RESULTADO PARA OS FILTROS.' : 'NENHUMA COBRANÇA ENCONTRADA.',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            border: Border.all(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _FinanceListItem extends ConsumerWidget {
  final Mensalidade item;
  final NumberFormat currencyFmt;
  
  const _FinanceListItem({required this.item, required this.currencyFmt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsStreamProvider);
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final isPaid = item.estado == 'pago';
    final isOverdue = item.estado == 'atrasado' || (!isPaid && item.dataVencimento.isBefore(DateTime.now()));
    final isCompact = context.isMediumOrSmaller;

    // Nomes dos meses para o card
    final List<String> meses = [
      'JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO',
      'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: studentsAsync.when(
        data: (alunos) {
          final aluno = alunos.where((a) => a.id == item.alunoId).firstOrNull;
          final alunoNome = aluno?.nomeCompleto ?? 'DESCONHECIDO';

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isPaid ? Colors.black : Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isPaid ? Icons.check : (isOverdue ? Icons.priority_high : Icons.access_time),
                        color: isPaid ? Colors.white : Colors.black,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(alunoNome.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${meses[item.mesReferencia - 1]} • VENCE EM ${DateFormat('dd/MM/yyyy').format(item.dataVencimento)}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(currencyFmt.format(item.valor), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                    Text(
                      isPaid ? 'LIQUIDADO' : (isOverdue ? 'EM ATRASO' : 'AGUARDANDO'),
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: isPaid 
                          ? () => showDialog(context: context, builder: (c) => PaymentDetailsDialog(mensalidade: item))
                          : null,
                      icon: Icon(Icons.visibility_outlined, color: isPaid ? Colors.black : Colors.black26),
                    ),
                    IconButton(
                      onPressed: !isPaid
                          ? () => showDialog(context: context, builder: (c) => PaymentConfirmationDialog(mensalidade: item))
                          : () => ReceiptPdfGenerator.generateAndPrint(mensalidade: item, aluno: aluno!),
                      icon: Icon(!isPaid ? Icons.payments_outlined : Icons.print_outlined, color: Colors.black),
                    ),
                    if (isAdmin) ...[
                      IconButton(
                        onPressed: () => _showCorrectionDialog(context, ref, item),
                        icon: const Icon(Icons.edit_note_rounded, color: Colors.blue, size: 20),
                        tooltip: 'Corrigir Dados',
                      ),
                      IconButton(
                        onPressed: () => _confirmDeleteIndividual(context, ref, item),
                        icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 20),
                        tooltip: 'Excluir Definitivamente',
                      ),
                    ],
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: isPaid ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isPaid ? Icons.check : (isOverdue ? Icons.priority_high : Icons.access_time),
                  color: isPaid ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alunoNome.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    Text(
                      '${meses[item.mesReferencia - 1]} • VENCE EM ${DateFormat('dd/MM/yyyy').format(item.dataVencimento)}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(currencyFmt.format(item.valor), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  Text(
                    isPaid ? 'LIQUIDADO' : (isOverdue ? 'EM ATRASO' : 'AGUARDANDO'),
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              if (isPaid)
                IconButton(
                  onPressed: () => showDialog(context: context, builder: (c) => PaymentDetailsDialog(mensalidade: item)),
                  icon: const Icon(Icons.visibility_outlined, color: Colors.black),
                  tooltip: 'Ver Detalhes e Evidência',
                ),
              if (!isPaid)
                IconButton(
                  onPressed: () => showDialog(context: context, builder: (c) => PaymentConfirmationDialog(mensalidade: item)),
                  icon: const Icon(Icons.payments_outlined, color: Colors.black),
                )
              else
                IconButton(
                  onPressed: () => ReceiptPdfGenerator.generateAndPrint(mensalidade: item, aluno: aluno!),
                  icon: const Icon(Icons.print_outlined, color: Colors.black),
                ),
              if (isAdmin) ...[
                IconButton(
                  onPressed: () => _showCorrectionDialog(context, ref, item),
                  icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
                  tooltip: 'Corrigir Dados',
                ),
                IconButton(
                  onPressed: () => _confirmDeleteIndividual(context, ref, item),
                  icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                  tooltip: 'Excluir Definitivamente',
                ),
              ],
            ],
          );
        },
        loading: () => const SizedBox(),
        error: (_, __) => const Text('ERRO'),
      ),
    );
  }

  void _showCorrectionDialog(BuildContext context, WidgetRef ref, Mensalidade item) {
    showDialog(
      context: context,
      builder: (context) => _FinanceCorrectionDialog(mensalidade: item),
    );
  }

  void _confirmDeleteIndividual(BuildContext context, WidgetRef ref, Mensalidade item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('EXCLUIR FACTURA', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('TEM A CERTEZA QUE DESEJA ELIMINAR ESTA COBRANÇA DEFINITIVAMENTE? ISTO APAGARÁ TAMBÉM QUALQUER PAGAMENTO ASSOCIADO.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(financeRepositoryProvider).deleteMensalidadePermanent(item.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('EXCLUIR', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}


class _FinanceCorrectionDialog extends ConsumerStatefulWidget {
  final Mensalidade mensalidade;
  const _FinanceCorrectionDialog({required this.mensalidade});

  @override
  ConsumerState<_FinanceCorrectionDialog> createState() => _FinanceCorrectionDialogState();
}

class _FinanceCorrectionDialogState extends ConsumerState<_FinanceCorrectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valorController;
  late TextEditingController _obsController;
  late String _estado;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _valorController = TextEditingController(text: widget.mensalidade.valor.toString());
    _obsController = TextEditingController(text: widget.mensalidade.observacao ?? '');
    _estado = widget.mensalidade.estado;
  }

  @override
  void dispose() {
    _valorController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
      title: const Text('CORRIGIR DADOS FINANCEIROS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'VALOR DA MENSALIDADE', 
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
              validator: (v) => v!.isEmpty ? 'OBRIGATÓRIO' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _estado,
              decoration: const InputDecoration(
                labelText: 'ESTADO', 
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              items: const [
                DropdownMenuItem(value: 'pendente', child: Text('PENDENTE')),
                DropdownMenuItem(value: 'pago', child: Text('PAGO')),
                DropdownMenuItem(value: 'atrasado', child: Text('ATRASADO')),
                DropdownMenuItem(value: 'anulada', child: Text('ANULADA')),
              ],
              onChanged: (val) => setState(() => _estado = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _obsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'OBSERVAÇÕES', 
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: _isSaving 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Text('SALVAR ALTERAÇÕES', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(financeRepositoryProvider);
      final item = widget.mensalidade;
      item.valor = double.parse(_valorController.text);
      item.estado = _estado;
      item.observacao = _obsController.text;
      item.updatedAt = DateTime.now();
      item.syncStatus = SyncStatus.pendingSync;
      
      await repo.saveMensalidade(item);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ERRO: $e'), backgroundColor: Colors.black));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
