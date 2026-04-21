import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
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
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)),
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
                label: const Text('NOVA TURMA'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.class_outlined, size: 64, color: AppTokens.border),
          SizedBox(height: 16),
          Text(
            'NENHUMA TURMA REGISTADA.',
            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ],
      ),
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
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDeleted ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: isDeleted ? 1 : 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDeleted ? Colors.grey : Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isDeleted ? 'INACTIVA' : turma.turno.toUpperCase(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                if (!isDeleted)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.black),
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
              turma.nomeTurma.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 0.5),
            ),
            const SizedBox(height: 4),
            Text(
              'SALA: ${turma.numeroSala}  •  VAGAS: ${turma.limiteAlunos}',
              style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w700),
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

  void _confirmDelete(BuildContext context, WidgetRef ref, {bool permanent = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: Text(permanent ? 'ELIMINAR DEFINITIVAMENTE' : 'ELIMINAR TURMA', style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(permanent 
          ? 'ESTA ACÇÃO É IRREVERSÍVEL E APAGARÁ TODAS AS MATRÍCULAS E PAGAMENTOS DESTA TURMA. DESEJA APAGAR ${turma.nomeTurma.toUpperCase()}?' 
          : 'TEM A CERTEZA QUE DESEJA ELIMINAR A TURMA ${turma.nomeTurma.toUpperCase()}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (permanent) {
                  await ref.read(classesRepositoryProvider).permanentDeleteTurma(turma.id);
                } else {
                  await ref.read(classesRepositoryProvider).deleteTurma(turma.id);
                }
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception:', '').toUpperCase()),
                      backgroundColor: Colors.black,
                    ),
                  );
                }
              }
            },
            child: const Text('CONFIRMAR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
