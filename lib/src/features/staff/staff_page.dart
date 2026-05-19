import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/funcionario.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../../state/session.dart';
import 'staff_controller.dart';
import 'widgets/staff_form_dialog.dart';

class StaffPage extends ConsumerWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffStreamProvider);
    final filtered = ref.watch(filteredStaffProvider);
    final canEdit = ref.watch(sessionProvider).perfil?.canEditData ?? false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          TextField(
            onChanged: (v) => ref.read(staffSearchProvider.notifier).state = v,
            decoration: const InputDecoration(
              hintText: 'Pesquisar por nome, número ou cargo...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: staffAsync.when(
              data: (_) {
                if (filtered.isEmpty) {
                  return EduEmptyState(
                    icon: Icons.badge_outlined,
                    title: 'Sem funcionários',
                    message: 'Registe o primeiro membro da equipa.',
                    actionLabel: canEdit ? 'Novo funcionário' : null,
                    onAction: canEdit ? () => _openForm(context) : null,
                  );
                }
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _StaffCard(
                    funcionario: filtered[i],
                    canEdit: canEdit,
                    onEdit: () => _openForm(context, filtered[i]),
                    onPresenca: () => ref.read(staffActionsProvider).registrarPresenca(filtered[i].id, true),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro: $e')),
            ),
          ),
          if (canEdit) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _openForm(context),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Novo funcionário'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _openForm(BuildContext context, [Funcionario? f]) {
    showDialog(context: context, builder: (_) => StaffFormDialog(funcionario: f));
  }
}

class _StaffCard extends StatelessWidget {
  final Funcionario funcionario;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onPresenca;

  const _StaffCard({
    required this.funcionario,
    required this.canEdit,
    required this.onEdit,
    required this.onPresenca,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy');
    final presenca = funcionario.ultimaPresenca;

    return EduCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppTokens.primary.withValues(alpha: 0.12),
            child: Text(
              funcionario.nomeCompleto.isNotEmpty ? funcionario.nomeCompleto[0].toUpperCase() : '?',
              style: const TextStyle(color: AppTokens.primary, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(funcionario.nomeCompleto, style: Theme.of(context).textTheme.titleMedium),
                Text('${funcionario.cargo} · Nº ${funcionario.numeroFuncionario}',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  'Salário base: ${NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ').format(funcionario.salarioBase)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (presenca != null)
                  Text(
                    'Última presença: ${dateFmt.format(presenca)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTokens.success),
                  ),
              ],
            ),
          ),
          _StatusChip(status: funcionario.status),
          if (canEdit) ...[
            IconButton(
              tooltip: 'Registar presença',
              icon: const Icon(Icons.how_to_reg_rounded),
              color: AppTokens.primary,
              onPressed: onPresenca,
            ),
            IconButton(
              tooltip: 'Editar',
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final FuncionarioStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case FuncionarioStatus.ativo:
        color = AppTokens.success;
      case FuncionarioStatus.inativo:
        color = AppTokens.error;
      case FuncionarioStatus.licenca:
        color = AppTokens.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
