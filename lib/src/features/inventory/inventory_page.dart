import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/ativo_inventario.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../../state/session.dart';
import '../../features/settings/settings_controller.dart';
import 'inventory_controller.dart';
import 'widgets/asset_form_dialog.dart';
import 'widgets/inventory_pdf_generator.dart';
import 'widgets/maintenance_form_dialog.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredInventoryProvider);
    final canEdit = ref.watch(sessionProvider).perfil?.canEditData ?? false;
    final currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          TextField(
            onChanged: (v) => ref.read(inventorySearchProvider.notifier).state = v,
            decoration: const InputDecoration(
              hintText: 'Pesquisar por código, nome ou local...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Todos'),
                  selected: ref.watch(inventoryFilterEstadoProvider) == null,
                  onSelected: (_) => ref.read(inventoryFilterEstadoProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                ...AtivoEstado.values.map((e) {
                  final selected = ref.watch(inventoryFilterEstadoProvider) == e;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_estadoLabel(e)),
                      selected: selected,
                      onSelected: (_) =>
                          ref.read(inventoryFilterEstadoProvider.notifier).state = selected ? null : e,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: items.isEmpty
                ? EduEmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'Sem activos registados',
                    message: 'Adicione equipamentos, mobiliário e material escolar.',
                    actionLabel: canEdit ? 'Novo activo' : null,
                    onAction: canEdit ? () => _openAssetForm(context) : null,
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _AssetCard(
                      ativo: items[i],
                      currency: currency,
                      canEdit: canEdit,
                      onEdit: () => _openAssetForm(context, items[i]),
                      onMaintenance: () => showDialog(
                        context: context,
                        builder: (_) => MaintenanceFormDialog(ativo: items[i]),
                      ),
                      onHistory: () => _showHistory(context, ref, items[i]),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: items.isEmpty
                    ? null
                    : () async {
                        final inst =
                            ref.read(settingsProvider).value?.nomeInstituicao ?? 'EDUCLASS';
                        await InventoryPdfGenerator.exportList(
                          ativos: items,
                          institutionName: inst,
                        );
                      },
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Exportar PDF'),
              ),
              if (canEdit)
                FilledButton.icon(
                  onPressed: () => _openAssetForm(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Novo activo'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _openAssetForm(BuildContext context, [AtivoInventario? ativo]) {
    showDialog(context: context, builder: (_) => AssetFormDialog(ativo: ativo));
  }

  void _showHistory(BuildContext context, WidgetRef ref, AtivoInventario ativo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        builder: (_, controller) => Consumer(
          builder: (context, ref, _) {
            final hist = ref.watch(manutencoesProvider(ativo.id));
            final currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Histórico — ${ativo.nome}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Expanded(
                    child: hist.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return const Center(child: Text('Sem manutenções registadas.'));
                        }
                        return ListView.builder(
                          controller: controller,
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final m = list[i];
                            return ListTile(
                              leading: const Icon(Icons.build_outlined),
                              title: Text(m.descricao),
                              subtitle: Text(DateFormat('dd/MM/yyyy').format(m.data)),
                              trailing: Text(currency.format(m.custo)),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Erro: $e'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _estadoLabel(AtivoEstado e) => switch (e) {
        AtivoEstado.bom => 'Bom',
        AtivoEstado.regular => 'Regular',
        AtivoEstado.avariado => 'Avariado',
        AtivoEstado.emManutencao => 'Manutenção',
        AtivoEstado.abatido => 'Abatido',
      };
}

class _AssetCard extends StatelessWidget {
  final AtivoInventario ativo;
  final NumberFormat currency;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onMaintenance;
  final VoidCallback onHistory;

  const _AssetCard({
    required this.ativo,
    required this.currency,
    required this.canEdit,
    required this.onEdit,
    required this.onMaintenance,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ativo.nome, style: Theme.of(context).textTheme.titleMedium),
                    Text('${ativo.codigo} · ${ativo.categoria}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              _EstadoBadge(estado: ativo.estado),
            ],
          ),
          const SizedBox(height: 8),
          Text('Local: ${ativo.localizacao}', style: Theme.of(context).textTheme.bodySmall),
          Text('Valor: ${currency.format(ativo.valorAquisicao)}',
              style: Theme.of(context).textTheme.bodySmall),
          if (ativo.ultimaManutencao != null)
            Text(
              'Última manutenção: ${DateFormat('dd/MM/yyyy').format(ativo.ultimaManutencao!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTokens.success),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onHistory,
                icon: const Icon(Icons.history_rounded, size: 18),
                label: const Text('Histórico'),
              ),
              if (canEdit) ...[
                TextButton.icon(
                  onPressed: onMaintenance,
                  icon: const Icon(Icons.build_outlined, size: 18),
                  label: const Text('Manutenção'),
                ),
                IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final AtivoEstado estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (estado) {
      AtivoEstado.bom => ('Bom', AppTokens.success),
      AtivoEstado.regular => ('Regular', AppTokens.info),
      AtivoEstado.avariado => ('Avariado', AppTokens.error),
      AtivoEstado.emManutencao => ('Manutenção', AppTokens.warning),
      AtivoEstado.abatido => ('Abatido', AppTokens.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
