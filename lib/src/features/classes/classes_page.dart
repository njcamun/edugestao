import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_form_styles.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../../domain/entities/turma.dart';
import '../../domain/entities/utilizador.dart';
import '../../state/session.dart';
import 'classes_controller.dart';
import 'widgets/class_form_dialog.dart';

class ClassesPage extends ConsumerWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(classesStreamProvider);
    final session = ref.watch(sessionProvider);
    final canEdit = session.perfil?.canEditData ?? false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: classesAsync.when(
              data: (turmas) {
                if (turmas.isEmpty) {
                  return _buildEmptyState();
                }
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisExtent: 150,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: turmas.length,
                  itemBuilder: (context, index) {
                    return _ClassCard(turma: turmas[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTokens.primary)),
              error: (err, _) => Center(child: Text('Erro ao carregar turmas: $err')),
            ),
          ),
          if (canEdit) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _showClassForm(context),
                icon: const Icon(Icons.add_home_work_outlined, size: 18),
                label: const Text('Nova turma'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const EduEmptyState(
      icon: Icons.class_outlined,
      title: 'Nenhuma turma',
      message: 'Crie a primeira turma para organizar alunos e matrículas.',
    );
  }

  void _showClassForm(BuildContext context, [Turma? turma]) {
    showDialog(
      context: context,
      builder: (context) => ClassFormDialog(turma: turma),
    );
  }
}

class _ClassCard extends ConsumerWidget {
  final Turma turma;
  const _ClassCard({required this.turma});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final isDeleted = turma.isDeleted;

    return Opacity(
      opacity: isDeleted ? 0.5 : 1.0,
      child: EduCard(
        padding: const EdgeInsets.all(20),
        color: isDeleted ? AppTokens.background : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDeleted ? AppTokens.textMuted : AppTokens.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTokens.radiusSM),
                  ),
                  child: Text(
                    isDeleted ? 'Inactiva' : turma.turno,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDeleted ? Colors.white : AppTokens.primaryDark,
                    ),
                  ),
                ),
                if (!isDeleted)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppTokens.primary),
                    onPressed: () => _showEditForm(context),
                  )
                else if (isAdmin) ...[
                  IconButton(
                    icon: const Icon(Icons.settings_backup_restore_rounded, size: 18, color: Colors.blue),
                    onPressed: () => _restore(ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red),
                    onPressed: () => _confirmDelete(context, ref, permanent: true),
                  ),
                ],
                
                // Botão de deletar para utilizadores com permissão
                if (!isDeleted && (session.perfil?.canEditData ?? false))
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                    onPressed: () => _confirmDelete(context, ref),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              turma.nomeTurma,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Sala ${turma.numeroSala} · ${turma.limiteAlunos} vagas',
              style: const TextStyle(color: AppTokens.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _restore(WidgetRef ref) async {
    await ref.read(classesRepositoryProvider).restoreTurma(turma.id);
  }

  void _showEditForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ClassFormDialog(turma: turma),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, {bool permanent = false}) async {
    final ok = await EduFormStyles.showConfirmDialog(
      context,
      title: permanent ? 'Eliminar definitivamente' : 'Eliminar turma',
      message: permanent
          ? 'Remove definitivamente «${turma.nomeTurma}», matrículas e cobranças (local e nuvem).'
          : 'Tem a certeza que deseja eliminar a turma ${turma.nomeTurma}?',
      confirmLabel: permanent ? 'Eliminar' : 'Confirmar',
      destructive: true,
    );
    if (ok != true) return;
    try {
      if (permanent) {
        await ref.read(classesRepositoryProvider).permanentDeleteTurma(turma.id);
      } else {
        await ref.read(classesRepositoryProvider).deleteTurma(turma.id);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception:', '').trim())),
        );
      }
    }
  }
}
