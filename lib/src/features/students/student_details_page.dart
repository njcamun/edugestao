import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/layout/adaptive.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/mensalidade.dart';
import '../finance/finance_controller.dart';
import '../finance/widgets/payment_confirmation_dialog.dart';
import '../finance/widgets/receipt_pdf_generator.dart';
import 'students_controller.dart';

class StudentDetailsPage extends ConsumerWidget {
  final String alunoId;
  const StudentDetailsPage({super.key, required this.alunoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsStreamProvider);
    final financeAsync = ref.watch(studentFinanceStreamProvider(alunoId));
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('PERFIL DO ALUNO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1)),
      ),
      body: studentsAsync.when(
        data: (alunos) {
          final aluno = alunos.where((a) => a.id == alunoId).firstOrNull;
          if (aluno == null) return const Center(child: Text('ALUNO NÃO ENCONTRADO'));

          return SingleChildScrollView(
            padding: EdgeInsets.all(context.isMediumOrSmaller ? 14 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, aluno),
                const SizedBox(height: 32),
                
                const Text('SITUAÇÃO FINANCEIRA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                const Divider(color: Colors.black, thickness: 2, height: 24),
                
                financeAsync.when(
                  data: (mensalidades) {
                    if (mensalidades.isEmpty) return const Text('NENHUMA MENSALIDADE GERADA PARA ESTE ALUNO.');
                    
                    // Ordenar por data de vencimento
                    final sorted = [...mensalidades];
                    sorted.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sorted.length,
                      itemBuilder: (context, index) {
                        final m = sorted[index];
                        return _FinanceStatusItem(item: m, aluno: aluno, currencyFmt: currencyFmt);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
                  error: (_, __) => const Text('ERRO AO CARREGAR DADOS FINANCEIROS'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
        error: (_, __) => const Center(child: Text('ERRO AO CARREGAR PERFIL')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Aluno aluno) {
    final isCompact = context.isMediumOrSmaller;

    return Container(
      padding: EdgeInsets.all(isCompact ? 14 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    aluno.nomeCompleto[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(aluno.nomeCompleto.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black)),
                const SizedBox(height: 4),
                Text('Nº INSCRIÇÃO: ${aluno.numeroAluno}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('ENCARREGADO: ${aluno.nomeEncarregado.toUpperCase()}', style: const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    aluno.nomeCompleto[0].toUpperCase(),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(aluno.nomeCompleto.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text('Nº INSCRIÇÃO: ${aluno.numeroAluno}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text('ENCARREGADO: ${aluno.nomeEncarregado.toUpperCase()}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _FinanceStatusItem extends StatelessWidget {
  final Mensalidade item;
  final Aluno aluno;
  final NumberFormat currencyFmt;

  const _FinanceStatusItem({required this.item, required this.aluno, required this.currencyFmt});

  @override
  Widget build(BuildContext context) {
    final isPaid = item.estado == 'pago';
    final isOverdue = item.estado == 'atrasado' || (!isPaid && item.dataVencimento.isBefore(DateTime.now()));
    final isCompact = context.isMediumOrSmaller;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isPaid ? Icons.check_circle : (isOverdue ? Icons.error : Icons.pending),
                      size: 18,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat('MMMM yyyy', 'pt_AO').format(DateTime(item.anoReferencia, item.mesReferencia)).toUpperCase(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      icon: Icon(isPaid ? Icons.print_outlined : Icons.payment_rounded, size: 18),
                      onPressed: () {
                        if (isPaid) {
                          ReceiptPdfGenerator.generateAndPrint(mensalidade: item, aluno: aluno);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => PaymentConfirmationDialog(mensalidade: item),
                          );
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  isPaid ? 'PAGAMENTO EFECTUADO' : (isOverdue ? 'PAGAMENTO EM ATRASO' : 'AGUARDANDO PAGAMENTO'),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(child: Text(currencyFmt.format(item.valor), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900))),
                    Text(
                      isPaid ? 'RECIBO DISPONÍVEL' : 'VENCE A ${DateFormat('dd/MM').format(item.dataVencimento)}',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )
          : Row(
        children: [
          Icon(
            isPaid ? Icons.check_circle : (isOverdue ? Icons.error : Icons.pending),
            size: 20,
            color: Colors.black,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM yyyy', 'pt_AO').format(DateTime(item.anoReferencia, item.mesReferencia)).toUpperCase(),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                ),
                Text(
                  isPaid ? 'PAGAMENTO EFECTUADO' : (isOverdue ? 'PAGAMENTO EM ATRASO' : 'AGUARDANDO PAGAMENTO'),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(currencyFmt.format(item.valor), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
              if (isPaid)
                const Text('RECIBO DISPONÍVEL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))
              else
                Text('VENCE A ${DateFormat('dd/MM').format(item.dataVencimento)}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 8),
          if (isPaid)
            IconButton(
              icon: const Icon(Icons.print_outlined, size: 18),
              onPressed: () => ReceiptPdfGenerator.generateAndPrint(mensalidade: item, aluno: aluno),
            )
          else
            IconButton(
              icon: const Icon(Icons.payment_rounded, size: 18),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PaymentConfirmationDialog(mensalidade: item),
                );
              },
            ),
        ],
      ),
    );
  }
}
