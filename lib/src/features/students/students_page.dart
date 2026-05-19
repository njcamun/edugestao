import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/layout/adaptive.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/entities/utilizador.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
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
          TextField(
            onChanged: (val) => ref.read(studentSearchProvider.notifier).state = val,
            decoration: const InputDecoration(
              hintText: 'Pesquisar aluno por nome ou número...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: studentsAsync.when(
              data: (alunos) {
                final filtered = alunos.where((a) {
                  final query = search.toLowerCase();
                  return a.nomeCompleto.toLowerCase().contains(query) ||
                      a.numeroAluno.toLowerCase().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return EduEmptyState(
                    icon: isSearching(search) ? Icons.person_off_outlined : Icons.people_outline_rounded,
                    title: isSearching(search) ? 'Nenhum resultado' : 'Nenhum aluno registado',
                    message: isSearching(search)
                        ? 'Tente outro termo de pesquisa.'
                        : 'Comece por registar o primeiro aluno.',
                    actionLabel: !isSearching(search) && isAdmin ? null : null,
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _StudentCard(aluno: filtered[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erro: $err')),
            ),
          ),
          if (canEdit) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (isAdmin) const StudentSeeder(),
                  FilledButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const StudentFormDialog(),
                    ),
                    icon: const Icon(Icons.person_add_rounded, size: 18),
                    label: const Text('Novo aluno'),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: isCompact ? 20 : 28, vertical: 14),
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

  bool isSearching(String search) => search.isNotEmpty;
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
      opacity: isDeleted ? 0.55 : 1,
      child: EduCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: isDeleted ? AppTokens.textMuted : AppTokens.primary,
            child: Text(
              aluno.nomeCompleto.isNotEmpty ? aluno.nomeCompleto[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  aluno.nomeCompleto,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isDeleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTokens.textMuted.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Inactivo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text('Nº ${aluno.numeroAluno} · ${aluno.anoEscolaridade}'),
              Text('Inscrição: ${DateFormat('dd/MM/yyyy').format(aluno.dataInscricao)}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          trailing: isCompact
              ? PopupMenuButton<String>(
                  onSelected: (value) => _handleAction(context, ref, value, isAdmin),
                  itemBuilder: (context) => _menuItems(session.perfil, isDeleted, isAdmin),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _desktopActions(context, ref, session.perfil, isDeleted, isAdmin),
                ),
          onTap: !isDeleted ? () => context.go('/alunos/${aluno.id}') : null,
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _menuItems(Utilizador? session, bool isDeleted, bool isAdmin) {
    if (!isDeleted) {
      return [
        const PopupMenuItem(value: 'details', child: Text('Ver perfil')),
        if (session?.canEditData ?? false) const PopupMenuItem(value: 'edit', child: Text('Editar')),
        if (session?.canEditData ?? false) const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
      ];
    }
    if (isAdmin) {
      return const [
        PopupMenuItem(value: 'restore', child: Text('Restaurar')),
        PopupMenuItem(value: 'hard-delete', child: Text('Eliminar definitivo')),
      ];
    }
    return const [];
  }

  List<Widget> _desktopActions(
    BuildContext context,
    WidgetRef ref,
    Utilizador? perfil,
    bool isDeleted,
    bool isAdmin,
  ) {
    if (!isDeleted) {
      return [
        IconButton(
          tooltip: 'Ver perfil',
          icon: const Icon(Icons.visibility_outlined),
          onPressed: () => context.go('/alunos/${aluno.id}'),
        ),
        if (perfil?.canEditData ?? false)
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showDialog(context: context, builder: (c) => StudentFormDialog(aluno: aluno)),
          ),
        if (perfil?.canEditData ?? false)
          IconButton(
            tooltip: 'Eliminar',
            icon: Icon(Icons.delete_outline_rounded, color: AppTokens.error.withValues(alpha: 0.85)),
            onPressed: () => _confirmDelete(context, ref, false),
          ),
      ];
    }
    if (isAdmin) {
      return [
        IconButton(
          icon: const Icon(Icons.restore_rounded),
          onPressed: () => ref.read(studentRepositoryProvider).restoreAluno(aluno.id),
        ),
        IconButton(
          icon: Icon(Icons.delete_forever_outlined, color: AppTokens.error.withValues(alpha: 0.85)),
          onPressed: () => _confirmDelete(context, ref, true),
        ),
      ];
    }
    return const [];
  }

  void _handleAction(BuildContext context, WidgetRef ref, String value, bool isAdmin) {
    switch (value) {
      case 'details':
        context.go('/alunos/${aluno.id}');
      case 'edit':
        showDialog(context: context, builder: (c) => StudentFormDialog(aluno: aluno));
      case 'delete':
        _confirmDelete(context, ref, false);
      case 'restore':
        ref.read(studentRepositoryProvider).restoreAluno(aluno.id);
      case 'hard-delete':
        _confirmDelete(context, ref, true);
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, bool permanent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(permanent ? 'Eliminar definitivamente' : 'Eliminar aluno'),
        content: Text(
          permanent
              ? 'Esta acção é irreversível. Deseja apagar ${aluno.nomeCompleto} permanentemente?'
              : 'Tem a certeza que deseja eliminar ${aluno.nomeCompleto}?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
            child: Text('Confirmar', style: TextStyle(color: AppTokens.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
