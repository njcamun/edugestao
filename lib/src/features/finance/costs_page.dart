import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_form_styles.dart';
import '../../domain/entities/custo.dart';
import '../../domain/entities/utilizador.dart';
import '../../state/session.dart';
import 'costs_controller.dart';
import 'widgets/cost_form_dialog.dart';

class CostsPage extends ConsumerWidget {
  const CostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costsAsync = ref.watch(costsStreamProvider);
    final typeFilter = ref.watch(costsTypeFilterProvider);
    final monthFilter = ref.watch(costsMonthFilterProvider);
    final yearFilter = ref.watch(costsYearFilterProvider);
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildFilterBar(context, ref),
          const SizedBox(height: 24),
          Expanded(
            child: costsAsync.when(
              data: (list) {
                final filteredCosts = list.where((c) {
                  if (!isAdmin && c.isDeleted) return false;
                  if (monthFilter != null && c.mesReferencia != monthFilter) {
                    return false;
                  }
                  if (yearFilter != null && c.anoReferencia != yearFilter) {
                    return false;
                  }
                  if (typeFilter == 'FIXOS' && c.tipo != 'FIXO') return false;
                  if (typeFilter == 'VARIAVEIS' && c.tipo != 'VARIAVEL') {
                    return false;
                  }
                  return true;
                }).toList();

                if (filteredCosts.isEmpty) return _buildEmptyState();

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredCosts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final cost = filteredCosts[index];
                    return Opacity(
                      opacity: cost.isDeleted ? 0.55 : 1.0,
                      child: _CostListItem(
                          cost: cost,
                          currencyFmt: currencyFmt,
                          isAdmin: isAdmin),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('ERRO AO CARREGAR: $err')),
            ),
          ),
          
          if (session.perfil?.canEditData ?? false) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAdmin)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: TextButton.icon(
                        onPressed: () => _confirmClearAll(context, ref),
                        icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                        label: const Text('LIMPAR TUDO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  FilledButton.icon(
                    onPressed: () => showDialog(context: context, builder: (c) => const CostFormDialog()),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: const Text('Adicionar custo'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: const Text('LIMPAR INVENTÁRIO', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('ESTA ACÇÃO IRÁ REMOVER TODOS OS CUSTOS ACTIVOS DO SEU INVENTÁRIO LOCAL E CLOUD. DESEJA CONTINUAR?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () async {
              final repo = ref.read(costsRepositoryProvider);
              final costsAsync = ref.read(costsStreamProvider);
              
              costsAsync.whenData((list) async {
                final typeFilter = ref.read(costsTypeFilterProvider);
                final monthFilter = ref.read(costsMonthFilterProvider);
                final yearFilter = ref.read(costsYearFilterProvider);
                
                final toDelete = list.where((c) {
                  if (c.isDeleted) return false;
                  if (monthFilter != null && c.mesReferencia != monthFilter) return false;
                  if (yearFilter != null && c.anoReferencia != yearFilter) return false;
                  if (typeFilter == 'FIXOS' && c.tipo != 'FIXO') return false;
                  if (typeFilter == 'VARIAVEIS' && c.tipo != 'VARIAVEL') return false;
                  return true;
                }).toList();

                for (var c in toDelete) {
                  await repo.deleteCusto(c.id);
                }
              });

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('LIMPAR TUDO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref) {
    final typeFilter = ref.watch(costsTypeFilterProvider);
    final month = ref.watch(costsMonthFilterProvider);
    final year = ref.watch(costsYearFilterProvider);
    final now = DateTime.now();

    final List<String> meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];

    return EduCard(
      elevated: false,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: 'Todos', isSelected: typeFilter == 'TODOS', onTap: () => ref.read(costsTypeFilterProvider.notifier).state = 'TODOS'),
                _FilterChip(label: 'Fixos', isSelected: typeFilter == 'FIXOS', onTap: () => ref.read(costsTypeFilterProvider.notifier).state = 'FIXOS'),
                _FilterChip(label: 'Variáveis', isSelected: typeFilter == 'VARIAVEIS', onTap: () => ref.read(costsTypeFilterProvider.notifier).state = 'VARIAVEIS'),
                const SizedBox(width: 8, child: VerticalDivider()),
                DropdownButton<int?>(
                  value: month,
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos os meses')),
                    ...List.generate(12, (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text(meses[i]),
                        )),
                  ],
                  onChanged: (val) => ref.read(costsMonthFilterProvider.notifier).state = val,
                ),
                const SizedBox(width: 8),
                DropdownButton<int?>(
                  value: year,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(value: now.year - 1, child: Text('${now.year - 1}')),
                    DropdownMenuItem(value: now.year, child: Text('${now.year}')),
                    DropdownMenuItem(value: now.year + 1, child: Text('${now.year + 1}')),
                  ],
                  onChanged: (val) => ref.read(costsYearFilterProvider.notifier).state = val,
                ),
              ],
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
          Icon(Icons.inventory_2_outlined, size: 64, color: AppTokens.border),
          SizedBox(height: 16),
          Text('Nenhum custo para este período.', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}

class _CostListItem extends ConsumerWidget {
  final CustoMensal cost;
  final NumberFormat currencyFmt;
  final bool isAdmin;
  const _CostListItem({required this.cost, required this.currencyFmt, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaid = cost.estado == 'PAGO';
    final List<String> meses = ['JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO', 'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'];

    final String mesNome = (cost.mesReferencia >= 1 && cost.mesReferencia <= 12) 
        ? meses[cost.mesReferencia - 1] 
        : 'MÊS N/A';

    final statusColor = isPaid ? AppTokens.success : AppTokens.warning;

    return EduCard(
      onTap: () => showDialog(context: context, builder: (c) => CostFormDialog(custo: cost)),
      child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: statusColor.withValues(alpha: 0.12),
              child: Icon(
                isPaid ? Icons.check_rounded : Icons.pending_actions_rounded,
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cost.descricao, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(
                    '${cost.tipo} · $mesNome ${cost.anoReferencia}',
                    style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currencyFmt.format(cost.valor), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: isPaid ? AppTokens.textPrimary : AppTokens.error)),
                Text(isPaid ? 'Liquidado' : 'Pendente', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isPaid ? AppTokens.success : AppTokens.error)),
              ],
            ),
            if (!isPaid || isAdmin)
              IconButton(
                icon: Icon(
                  cost.isDeleted ? Icons.restore_from_trash_rounded : Icons.delete_outline_rounded,
                  color: cost.isDeleted ? Colors.green : Colors.red,
                  size: 20,
                ),
                onPressed: () async {
                  if (cost.isDeleted) {
                    await ref.read(costsRepositoryProvider).restoreCusto(cost.id);
                  } else {
                    await _confirmDelete(context, ref);
                  }
                },
              ),
            if (isAdmin && cost.isDeleted)
              IconButton(
                icon: Icon(Icons.delete_forever_rounded, color: AppTokens.error.withValues(alpha: 0.85), size: 20),
                onPressed: () => _confirmPermanentDelete(context, ref),
              ),
          ],
        ),
    );
  }

  Future<void> _confirmPermanentDelete(BuildContext context, WidgetRef ref) async {
    final ok = await EduFormStyles.showConfirmDialog(
      context,
      title: 'Eliminar definitivamente',
      message: 'O custo «${cost.descricao}» será removido localmente e na nuvem. Não pode ser desfeito.',
      confirmLabel: 'Eliminar',
      destructive: true,
    );
    if (ok == true) {
      await ref.read(costsRepositoryProvider).permanentDeleteCusto(cost.id);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await EduFormStyles.showConfirmDialog(
      context,
      title: 'Eliminar custo',
      message: 'Deseja eliminar «${cost.descricao}»?',
      confirmLabel: 'Eliminar',
      destructive: true,
    );
    if (ok == true) {
      await ref.read(costsRepositoryProvider).deleteCusto(cost.id);
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppTokens.primary : AppTokens.surface,
            border: Border.all(color: isSelected ? AppTokens.primary : AppTokens.border),
            borderRadius: BorderRadius.circular(AppTokens.radiusSM),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTokens.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
