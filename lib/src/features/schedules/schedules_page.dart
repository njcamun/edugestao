import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../classes/classes_controller.dart';
import 'schedule_turma_page.dart';
import 'schedules_controller.dart';

class SchedulesPage extends ConsumerWidget {
  const SchedulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final turmasAsync = ref.watch(classesStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Seleccione uma turma para editar a grade horária.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTokens.textSecondary),
          ),
          const SizedBox(height: AppTokens.paddingMD),
          Expanded(
            child: turmasAsync.when(
              data: (turmas) {
                final activas = turmas.where((t) => !t.isDeleted && t.ativa).toList();
                if (activas.isEmpty) {
                  return const EduEmptyState(
                    icon: Icons.schedule_outlined,
                    title: 'Sem turmas',
                    message: 'Crie turmas activas em Secretaria → Turmas para definir horários.',
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: activas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppTokens.paddingSM),
                  itemBuilder: (context, index) {
                    final t = activas[index];
                    return _TurmaScheduleTile(turmaId: t.id, turmaNome: t.nomeTurma, turno: t.turno, sala: t.numeroSala);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTokens.primary)),
              error: (e, _) => EduEmptyState(icon: Icons.error_outline, title: 'Erro', message: '$e'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TurmaScheduleTile extends ConsumerWidget {
  const _TurmaScheduleTile({
    required this.turmaId,
    required this.turmaNome,
    required this.turno,
    required this.sala,
  });

  final String turmaId;
  final String turmaNome;
  final String turno;
  final String sala;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(horariosTurmaProvider(turmaId)).valueOrNull?.length ?? 0;

    return EduCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ScheduleTurmaPage(turmaId: turmaId, turmaNome: turmaNome),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTokens.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTokens.radiusMD),
              ),
              child: const Icon(Icons.class_outlined, color: AppTokens.primary),
            ),
            const SizedBox(width: AppTokens.paddingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(turmaNome, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    '$turno · Sala $sala',
                    style: const TextStyle(fontSize: 13, color: AppTokens.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: count > 0
                    ? AppTokens.success.withValues(alpha: 0.15)
                    : AppTokens.accentYellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count > 0 ? '$count aulas' : 'Definir',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: count > 0 ? AppTokens.success : AppTokens.warning,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTokens.textMuted),
          ],
        ),
      ),
    );
  }
}
