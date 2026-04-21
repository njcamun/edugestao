import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/layout/adaptive.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/utilizador.dart';
import '../../state/session.dart';
import 'students_controller.dart';
import 'widgets/student_form_dialog.dart';
import 'widgets/student_seeder.dart';

class StudentsPage extends ConsumerWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsStreamProvider);
    final search = ref.watch(studentSearchProvider);
    final session = ref.watch(sessionProvider);
    final canEdit = session.perfil?.canEditData ?? false;
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final isCompact = context.isMediumOrSmaller;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: TextField(
              onChanged: (val) => ref.read(studentSearchProvider.notifier).state = val,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'PESQUISAR ALUNO POR NOME OU NÚMERO...',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w900),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.black),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          Expanded(
            child: studentsAsync.when(
              data: (alunos) {
                final filtered = alunos.where((a) {
                  final query = search.toLowerCase();
                  return a.nomeCompleto.toLowerCase().contains(query) ||
                         a.numeroAluno.toLowerCase().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return _buildEmptyState(search.isNotEmpty, isAdmin);
                }
                
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _StudentCard(aluno: filtered[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black)),
              error: (err, _) => Center(child: Text('ERRO: $err')),
            ),
          ),
          
          if (canEdit) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isAdmin) const StudentSeeder(),
                  FilledButton.icon(
                    onPressed: () => _showStudentForm(context),
                    icon: const Icon(Icons.person_add_rounded, size: 18),
                    label: const Text('NOVO ALUNO'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(horizontal: isCompact ? 20 : 32, vertical: isCompact ? 14 : 18),
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

  void _showStudentForm(BuildContext context, [Aluno? aluno]) {
    showDialog(context: context, builder: (context) => StudentFormDialog(aluno: aluno));
  }

  Widget _buildEmptyState(bool isSearching, bool isAdmin) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSearching ? Icons.person_off_rounded : Icons.fingerprint_rounded, size: 64, color: AppTokens.border),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'NENHUM RESULTADO ENCONTRADO.' : 'NENHUM ALUNO REGISTADO.',
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          if (!isSearching && isAdmin) ...[
            const SizedBox(height: 24),
            const StudentSeeder(),
          ]
        ],
      ),
    );
  }
}

class _StudentCard extends ConsumerWidget {
  final Aluno aluno;
  const _StudentCard({required this.aluno});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final isDeleted = aluno.isDeleted;
    final isCompact = context.isMediumOrSmaller;

    return Opacity(
      opacity: isDeleted ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDeleted ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black, width: isDeleted ? 1 : 1.5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 45, height: 45,
            decoration: BoxDecoration(
              color: isDeleted ? Colors.grey : Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              aluno.nomeCompleto.isNotEmpty ? aluno.nomeCompleto.substring(0, 1).toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
            ),
          ),
          title: Row(
            children: [
              Expanded(child: Text(aluno.nomeCompleto.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14))),
              if (isDeleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                  child: const Text('INACTIVO', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('INSCRIÇÃO: ${aluno.numeroAluno}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              Text('CLASSE: ${aluno.anoEscolaridade.toUpperCase()}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text('DATA CADASTRO: ${DateFormat('dd/MM/yyyy').format(aluno.dataInscricao)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
            ],
          ),
          trailing: isCompact
              ? PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) {
                    if (value == 'details') context.go('/alunos/${aluno.id}');
                    if (value == 'edit') showDialog(context: context, builder: (c) => StudentFormDialog(aluno: aluno));
                    if (value == 'delete') _confirmDelete(context, ref, false);
                    if (value == 'restore') _restore(ref);
                    if (value == 'hard-delete') _confirmDelete(context, ref, true);
                  },
                  itemBuilder: (context) {
                    if (!isDeleted) {
                      return [
                        const PopupMenuItem(value: 'details', child: Text('VER PERFIL')),
                        if (session.perfil?.canEditData ?? false) const PopupMenuItem(value: 'edit', child: Text('EDITAR')),
                        if (session.perfil?.canEditData ?? false) const PopupMenuItem(value: 'delete', child: Text('ELIMINAR')),
                      ];
                    }
                    if (isAdmin) {
                      return const [
                        PopupMenuItem(value: 'restore', child: Text('RESTAURAR')),
                        PopupMenuItem(value: 'hard-delete', child: Text('ELIMINAR DEFINITIVO')),
                      ];
                    }
                    return const [];
                  },
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isDeleted) ...[
                      _CardAction(icon: Icons.person_search_rounded, color: Colors.black, onTap: () => context.go('/alunos/${aluno.id}')),
                      if (session.perfil?.canEditData ?? false)
                        _CardAction(icon: Icons.edit_note_rounded, color: Colors.black, onTap: () => showDialog(context: context, builder: (c) => StudentFormDialog(aluno: aluno))),
                      if (session.perfil?.canEditData ?? false)
                        _CardAction(icon: Icons.delete_outline_rounded, color: Colors.red.shade900, onTap: () => _confirmDelete(context, ref, false)),
                    ] else if (isAdmin) ...[
                      _CardAction(icon: Icons.settings_backup_restore_rounded, color: Colors.blue.shade900, onTap: () => _restore(ref)),
                      _CardAction(icon: Icons.delete_forever_rounded, color: Colors.red.shade900, onTap: () => _confirmDelete(context, ref, true)),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  void _restore(WidgetRef ref) async {
    await ref.read(studentRepositoryProvider).restoreAluno(aluno.id);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, bool permanent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: Text(permanent ? 'ELIMINAR DEFINITIVAMENTE' : 'ELIMINAR ALUNO', style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(permanent 
          ? 'ESTA ACÇÃO É IRREVERSÍVEL. DESEJA APAGAR ${aluno.nomeCompleto.toUpperCase()} DOS REGISTOS PERMANENTES?' 
          : 'TEM A CERTEZA QUE DESEJA ELIMINAR O ALUNO ${aluno.nomeCompleto.toUpperCase()}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () async {
              try {
                if (permanent) {
                  await ref.read(studentRepositoryProvider).permanentDeleteAluno(aluno.id);
                } else {
                  await ref.read(studentRepositoryProvider).deleteAluno(aluno.id);
                }
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().toUpperCase())));
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

class _CardAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CardAction({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon, size: 22, color: color), onPressed: onTap, padding: EdgeInsets.zero, constraints: const BoxConstraints(), splashRadius: 20);
  }
}
