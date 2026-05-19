import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/layout/adaptive.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/mensalidade.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_section_title.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Perfil do aluno'),
      ),
      body: studentsAsync.when(
        data: (alunos) {
          final aluno = alunos.where((a) => a.id == alunoId).firstOrNull;
          if (aluno == null) {
            return const Center(child: Text('Aluno não encontrado'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(context.isMediumOrSmaller ? 12 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileHeader(aluno: aluno),
                const SizedBox(height: 24),
                const EduSectionTitle('Situação financeira', subtitle: 'Propinas e recibos'),
                financeAsync.when(
                  data: (mensalidades) {
                    if (mensalidades.isEmpty) {
                      return Text(
                        'Nenhuma mensalidade gerada para este aluno.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }
                    final sorted = [...mensalidades]
                      ..sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
                    return Column(
                      children: sorted
                          .map((m) => _FinanceStatusItem(
                                item: m,
                                aluno: aluno,
                                currencyFmt: currencyFmt,
                              ))
                          .toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Erro ao carregar dados financeiros'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erro ao carregar perfil')),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Aluno aluno;
  const _ProfileHeader({required this.aluno});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy');

    return EduCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppTokens.primary,
            child: Text(
              aluno.nomeCompleto.isNotEmpty ? aluno.nomeCompleto[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(aluno.nomeCompleto, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                _infoRow(Icons.badge_outlined, 'Nº ${aluno.numeroAluno}'),
                _infoRow(Icons.school_outlined, aluno.anoEscolaridade),
                _infoRow(Icons.person_outline, aluno.nomeEncarregado),
                _infoRow(Icons.phone_outlined, aluno.telefonePrincipal),
                if (aluno.email != null && aluno.email!.isNotEmpty)
                  _infoRow(Icons.email_outlined, aluno.email!),
                _infoRow(Icons.calendar_today_outlined, 'Inscrição: ${dateFmt.format(aluno.dataInscricao)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppTokens.textMuted),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _FinanceStatusItem extends StatelessWidget {
  final Mensalidade item;
  final Aluno aluno;
  final NumberFormat currencyFmt;

  const _FinanceStatusItem({
    required this.item,
    required this.aluno,
    required this.currencyFmt,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = item.estado == 'pago';
    final isOverdue =
        item.estado == 'atrasado' || (!isPaid && item.dataVencimento.isBefore(DateTime.now()));
    final statusColor = isPaid ? AppTokens.success : (isOverdue ? AppTokens.error : AppTokens.warning);
    final statusLabel =
        isPaid ? 'Pago' : (isOverdue ? 'Em atraso' : 'Pendente');
    final monthLabel = DateFormat('MMMM yyyy', 'pt_AO')
        .format(DateTime(item.anoReferencia, item.mesReferencia));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: EduCard(
        child: Row(
          children: [
            Icon(
              isPaid ? Icons.check_circle_outline : Icons.schedule_rounded,
              color: statusColor,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(monthLabel, style: Theme.of(context).textTheme.titleSmall),
                  Text(statusLabel, style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w600)),
                  if (!isPaid)
                    Text(
                      'Vence a ${DateFormat('dd/MM/yyyy').format(item.dataVencimento)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFmt.format(item.valor),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                IconButton(
                  tooltip: isPaid ? 'Imprimir recibo' : 'Registar pagamento',
                  icon: Icon(isPaid ? Icons.print_outlined : Icons.payment_rounded, size: 20),
                  color: AppTokens.primary,
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
          ],
        ),
      ),
    );
  }
}
