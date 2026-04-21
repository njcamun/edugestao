import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/matricula.dart';
import 'enrollments_controller.dart';
import 'widgets/enrollment_form_dialog.dart';
import '../students/students_controller.dart';
import '../classes/classes_controller.dart';
import '../../state/session.dart';
import '../../domain/entities/utilizador.dart';

class EnrollmentsPage extends ConsumerWidget {
  const EnrollmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrollmentsAsync = ref.watch(enrollmentsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: enrollmentsAsync.when(
              data: (matriculas) {
                if (matriculas.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: matriculas.length,
                  itemBuilder: (context, index) {
                    return _EnrollmentCard(matricula: matriculas[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTokens.slate900)),
              error: (err, _) => Center(child: Text('Erro ao carregar matrículas: $err')),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => _showEnrollmentForm(context),
              icon: const Icon(Icons.how_to_reg_rounded, size: 18),
              label: const Text('Nova Matrícula'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTokens.slate900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              ),
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
          Icon(Icons.assignment_ind_outlined, size: 64, color: AppTokens.border),
          SizedBox(height: 16),
          Text(
            'Nenhuma matrícula activa.',
            style: TextStyle(color: AppTokens.slate600, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showEnrollmentForm(BuildContext context, [Matricula? matricula]) {
    showDialog(
      context: context,
      builder: (context) => EnrollmentFormDialog(matricula: matricula),
    );
  }
}

class _EnrollmentCard extends ConsumerWidget {
  final Matricula matricula;
  const _EnrollmentCard({required this.matricula});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsStreamProvider);
    final classesAsync = ref.watch(classesStreamProvider);
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final isDeleted = matricula.isDeleted;

    String alunoNome = 'Carregando...';
    String turmaNome = '...';

    studentsAsync.whenData((alunos) {
      final aluno = alunos.where((a) => a.id == matricula.alunoId).firstOrNull;
      if (aluno != null) alunoNome = aluno.nomeCompleto;
    });

    classesAsync.whenData((turmas) {
      final turma = turmas.where((t) => t.id == matricula.turmaId).firstOrNull;
      if (turma != null) turmaNome = turma.nomeTurma;
    });

    return Opacity(
      opacity: isDeleted ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDeleted ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDeleted ? Colors.grey : AppTokens.border),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: isDeleted ? Colors.grey.shade300 : AppTokens.background,
            child: Icon(
              isDeleted ? Icons.cancel_outlined : Icons.check_circle_outline_rounded, 
              color: isDeleted ? Colors.grey : (matricula.estado == 'ativa' ? AppTokens.success : AppTokens.error),
              size: 20,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  alunoNome,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: isDeleted ? Colors.black54 : AppTokens.slate900),
                ),
              ),
              if (isDeleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                  child: const Text('ANULADA', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                ),
            ],
          ),
          subtitle: Text(
            'Turma: $turmaNome • Data: ${DateFormat('dd/MM/yyyy').format(matricula.dataMatricula)}',
            style: const TextStyle(color: AppTokens.slate600, fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDeleted) ...[
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppTokens.slate600),
                  onPressed: () => _showEditForm(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppTokens.error),
                  onPressed: () => _confirmDelete(context, ref, alunoNome, false),
                ),
              ] else if (isAdmin) ...[
                IconButton(
                  icon: const Icon(Icons.settings_backup_restore_rounded, size: 18, color: Colors.blue),
                  onPressed: () => ref.read(enrollmentRepositoryProvider).restoreMatricula(matricula.id),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever_rounded, size: 18, color: Colors.red),
                  onPressed: () => _confirmDelete(context, ref, alunoNome, true),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEditForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EnrollmentFormDialog(matricula: matricula),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String alunoNome, bool permanent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(permanent ? 'ELIMINAR DEFINITIVAMENTE' : 'Anular Matrícula'),
        content: Text(permanent 
          ? 'ESTA ACÇÃO APAGARÁ TODOS OS REGISTOS DE PAGAMENTO E MENSALIDADES DE $alunoNome. DESEJA CONTINUAR?' 
          : 'Tem a certeza que deseja anular a matrícula de $alunoNome?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (permanent) {
                await ref.read(enrollmentRepositoryProvider).permanentDeleteMatricula(matricula.id);
              } else {
                await ref.read(enrollmentRepositoryProvider).deleteMatricula(matricula.id);
              }
              if (context.mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppTokens.error),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
