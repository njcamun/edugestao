import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/custo.dart';
import '../../domain/entities/utilizador.dart';
import '../../state/session.dart';
import 'costs_controller.dart';
import 'widgets/cost_form_dialog.dart';

class CostsPage extends ConsumerWidget {
  const CostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costsAsync = ref.watch(costsStreamProvider);
    final typeFilter = ref.watch(costsTypeFilterProvider);
    final monthFilter = ref.watch(costsMonthFilterProvider);
    final yearFilter = ref.watch(costsYearFilterProvider);
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildFilterBar(context, ref),
          const SizedBox(height: 24),
          Expanded(
            child: costsAsync.when(
              data: (list) {
                final filteredCosts = list.where((c) {
                  if (!isAdmin && c.isDeleted) return false;
                  if (monthFilter != null && c.mesReferencia != monthFilter) {
                    return false;
                  }
                  if (yearFilter != null && c.anoReferencia != yearFilter) {
                    return false;
                  }
                  if (typeFilter == 'FIXOS' && c.tipo != 'FIXO') return false;
                  if (typeFilter == 'VARIAVEIS' && c.tipo != 'VARIAVEL') {
                    return false;
                  }
                  return true;
                }).toList();

                if (filteredCosts.isEmpty) return _buildEmptyState();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredCosts.length,
                  itemBuilder: (context, index) {
                    final cost = filteredCosts[index];
                    return Opacity(
                      opacity: cost.isDeleted ? 0.5 : 1.0,
                      child: _CostListItem(
                          cost: cost,
                          currencyFmt: currencyFmt,
                          isAdmin: isAdmin),
                    );
                  },
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.black)),
              error: (err, stack) => Center(child: Text('ERRO AO CARREGAR: $err')),
            ),
          ),
          
          if (session.perfil?.canEditData ?? false) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAdmin)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: TextButton.icon(
                        onPressed: () => _confirmClearAll(context, ref),
                        icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                        label: const Text('LIMPAR TUDO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: () => showDialog(context: context, builder: (c) => const CostFormDialog()),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: const Text('ADICIONAR EXTRA'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: const Text('LIMPAR INVENTÁRIO', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('ESTA ACÇÃO IRÁ REMOVER TODOS OS CUSTOS ACTIVOS DO SEU INVENTÁRIO LOCAL E CLOUD. DESEJA CONTINUAR?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () async {
              final repo = ref.read(costsRepositoryProvider);
              final costsAsync = ref.read(costsStreamProvider);
              
              costsAsync.whenData((list) async {
                final typeFilter = ref.read(costsTypeFilterProvider);
                final monthFilter = ref.read(costsMonthFilterProvider);
                final yearFilter = ref.read(costsYearFilterProvider);
                
                final toDelete = list.where((c) {
                  if (c.isDeleted) return false;
                  if (monthFilter != null && c.mesReferencia != monthFilter) return false;
                  if (yearFilter != null && c.anoReferencia != yearFilter) return false;
                  if (typeFilter == 'FIXOS' && c.tipo != 'FIXO') return false;
                  if (typeFilter == 'VARIAVEIS' && c.tipo != 'VARIAVEL') return false;
                  return true;
                }).toList();

                for (var c in toDelete) {
                  await repo.deleteCusto(c.id);
                }
              });

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('LIMPAR TUDO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
    final typeFilter = ref.watch(costsTypeFilterProvider);
    final month = ref.watch(costsMonthFilterProvider);

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: 'TODOS', isSelected: typeFilter == 'TODOS', onTap: () => ref.read(costsTypeFilterProvider.notifier).state = 'TODOS'),
                _FilterChip(label: 'FIXOS', isSelected: typeFilter == 'FIXOS', onTap: () => ref.read(costsTypeFilterProvider.notifier).state = 'FIXOS'),
                _FilterChip(label: 'VARIÁVEIS', isSelected: typeFilter == 'VARIAVEIS', onTap: () => ref.read(costsTypeFilterProvider.notifier).state = 'VARIAVEIS'),
                const SizedBox(width: 8, child: VerticalDivider()),
                DropdownButton<int?>(
                  value: month,
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('TODOS MESES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                    ...List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(meses[i], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)))),
                  ],
                  onChanged: (val) => ref.read(costsMonthFilterProvider.notifier).state = val,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppTokens.border),
          SizedBox(height: 16),
          Text('NENHUM REGISTO PARA ESTE FILTRO.', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        ],
      ),
    );
  }
}

class _CostListItem extends ConsumerWidget {
  final CustoMensal cost;
  final NumberFormat currencyFmt;
  final bool isAdmin;
  const _CostListItem({required this.cost, required this.currencyFmt, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = cost.estado == 'PAGO';
    final List<String> meses = ['JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO', 'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'];

    final String mesNome = (cost.mesReferencia >= 1 && cost.mesReferencia <= 12) 
        ? meses[cost.mesReferencia - 1] 
        : 'MÊS N/A';

    return InkWell(
      onTap: () => showDialog(context: context, builder: (c) => CostFormDialog(custo: cost)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: isPaid ? Colors.black : Colors.white, border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(8)),
              child: Icon(isPaid ? Icons.check : Icons.pending_actions_rounded, color: isPaid ? Colors.white : Colors.black, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cost.descricao.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                  Text(
                    '${cost.tipo} • $mesNome ${cost.anoReferencia}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currencyFmt.format(cost.valor), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: isPaid ? Colors.black : Colors.red.shade900)),
                Text(isPaid ? 'LIQUIDADO' : 'AGUARDANDO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: isPaid ? Colors.black : Colors.red.shade900, letterSpacing: 0.5)),
              ],
            ),
            if (!isPaid || isAdmin)
              IconButton(
                icon: Icon(
                  cost.isDeleted ? Icons.restore_from_trash_rounded : Icons.delete_outline_rounded,
                  color: cost.isDeleted ? Colors.green : Colors.red,
                  size: 20,
                ),
                onPressed: () {
                  if (cost.isDeleted) {
                    ref.read(costsRepositoryProvider).restoreCusto(cost.id);
                  } else {
                    _confirmDelete(context, ref);
                  }
                },
              ),
            if (isAdmin && cost.isDeleted)
              IconButton(
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.black, size: 20),
                onPressed: () => _confirmPermanentDelete(context, ref),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmPermanentDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: const Text('REMOÇÃO DEFINITIVA', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text('ESTA ACÇÃO IRÁ APAGAR PERMANENTEMENTE O REGISTO DE ${cost.descricao.toUpperCase()} NA CLOUD E LOCALMENTE. NÃO PODE SER DESFEITO.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () async {
              await ref.read(costsRepositoryProvider).permanentDeleteCusto(cost.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('APAGAR TUDO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: const Text('ELIMINAR CUSTO', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text('DESEJA ELIMINAR O REGISTO DE ${cost.descricao.toUpperCase()}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () async {
              await ref.read(costsRepositoryProvider).deleteCusto(cost.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('CONFIRMAR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
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
          decoration: BoxDecoration(color: isSelected ? Colors.black : Colors.white, border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(6)),
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 10, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
