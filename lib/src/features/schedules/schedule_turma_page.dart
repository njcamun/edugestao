import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/horario_aula.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../../shared/widgets/edu_form_styles.dart';
import 'schedules_controller.dart';
import 'widgets/schedule_form_dialog.dart';
import 'widgets/schedule_week_grid.dart';

class ScheduleTurmaPage extends ConsumerWidget {
  const ScheduleTurmaPage({super.key, required this.turmaId, required this.turmaNome});

  final String turmaId;
  final String turmaNome;

  void _addAula(BuildContext context) {
    showDialog(context: context, builder: (_) => ScheduleFormDialog(turmaId: turmaId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final horariosAsync = ref.watch(horariosTurmaProvider(turmaId));
    final viewMode = ref.watch(scheduleViewModeProvider(turmaId));
    final conflictsAsync = ref.watch(scheduleConflictsProvider(turmaId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Horário — $turmaNome'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: viewMode == ScheduleViewMode.lista ? 'Vista semanal' : 'Vista por dia',
            onPressed: () {
              ref.read(scheduleViewModeProvider(turmaId).notifier).state =
                  viewMode == ScheduleViewMode.lista ? ScheduleViewMode.semana : ScheduleViewMode.lista;
            },
            icon: Icon(viewMode == ScheduleViewMode.lista ? Icons.calendar_view_week_rounded : Icons.view_list_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addAula(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Aula'),
        backgroundColor: AppTokens.primary,
      ),
      body: horariosAsync.when(
        data: (horarios) {
          if (horarios.isEmpty) {
            return EduEmptyState(
              icon: Icons.schedule_outlined,
              title: 'Grade vazia',
              message: 'Adicione aulas para montar o horário desta turma.',
              actionLabel: 'Adicionar aula',
              onAction: () => _addAula(context),
            );
          }

          final conflictIds = conflictsAsync.valueOrNull?.ids ?? {};
          final messages = [
            ...?conflictsAsync.valueOrNull?.messages,
            ...?conflictsAsync.valueOrNull?.professorMessages,
          ];

          Widget content;
          if (viewMode == ScheduleViewMode.semana) {
            content = ScheduleWeekGrid(horarios: horarios, conflictIds: conflictIds);
          } else {
            content = _ListaPorDia(turmaId: turmaId, horarios: horarios, conflictIds: conflictIds);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (messages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppTokens.paddingMD, AppTokens.paddingMD, AppTokens.paddingMD, 0),
                  child: EduFormStyles.warningBanner(
                    '${messages.length} conflito(s) de horário (sala ou professor). Ajuste as aulas assinaladas.',
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTokens.paddingMD),
                  child: content,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTokens.primary)),
        error: (e, _) => EduEmptyState(icon: Icons.error_outline, title: 'Erro', message: '$e'),
      ),
    );
  }
}

class _ListaPorDia extends ConsumerWidget {
  const _ListaPorDia({required this.turmaId, required this.horarios, required this.conflictIds});

  final String turmaId;
  final List<HorarioAula> horarios;
  final Set<String> conflictIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final porDia = <int, List<HorarioAula>>{};
    for (final h in horarios) {
      porDia.putIfAbsent(h.diaSemana, () => []).add(h);
    }
    final dias = porDia.keys.toList()..sort();

    return ListView.separated(
      itemCount: dias.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppTokens.paddingMD),
      itemBuilder: (context, index) {
        final dia = dias[index];
        final aulas = porDia[dia]!..sort((a, b) => a.horaInicio.compareTo(b.horaInicio));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              HorarioAula.diaLabel(dia),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTokens.primaryDark,
                  ),
            ),
            const SizedBox(height: AppTokens.paddingSM),
            ...aulas.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: AppTokens.paddingSM),
                child: EduCard(
                  child: _AulaTile(
                    turmaId: turmaId,
                    horario: h,
                    emConflito: conflictIds.contains(h.id),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AulaTile extends ConsumerWidget {
  const _AulaTile({required this.turmaId, required this.horario, this.emConflito = false});

  final String turmaId;
  final HorarioAula horario;
  final bool emConflito;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = horario;
    return DecoratedBox(
      decoration: emConflito
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.radiusMD),
              border: Border.all(color: AppTokens.error, width: 2),
            )
          : const BoxDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        onTap: () => showDialog(
          context: context,
          builder: (_) => ScheduleFormDialog(turmaId: turmaId, existing: h),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: (emConflito ? AppTokens.error : AppTokens.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTokens.radiusSM),
                ),
                child: Text(
                  '${h.horaInicio} – ${h.horaFim}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: emConflito ? AppTokens.error : AppTokens.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: AppTokens.paddingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(h.disciplina, style: const TextStyle(fontWeight: FontWeight.w600))),
                        if (emConflito)
                          const Icon(Icons.warning_amber_rounded, size: 18, color: AppTokens.error),
                      ],
                    ),
                    if (h.professor != null)
                      Text(h.professor!, style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'edit') {
                    if (!context.mounted) return;
                    showDialog(context: context, builder: (_) => ScheduleFormDialog(turmaId: turmaId, existing: h));
                  } else if (v == 'delete') {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Remover aula?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remover')),
                        ],
                      ),
                    );
                    if (ok == true) await ref.read(scheduleActionsProvider).delete(h.id, turmaId: turmaId);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Remover')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
