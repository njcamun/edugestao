import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_section_title.dart';
import '../../shared/widgets/report_export_tile.dart';
import '../../shared/widgets/report_kpi_card.dart';
import '../finance/finance_controller.dart';
import '../finance/costs_controller.dart';
import '../students/students_controller.dart';
import '../settings/settings_controller.dart';
import 'widgets/report_pdf_generator.dart';

class ReportFinancePage extends ConsumerStatefulWidget {
  const ReportFinancePage({super.key});

  @override
  ConsumerState<ReportFinancePage> createState() => _ReportFinancePageState();
}

class _ReportFinancePageState extends ConsumerState<ReportFinancePage> {
  String _selectedAnoLectivo = '2024/2025';
  String _selectedPeriodicidade = 'Anual';
  String _selectedTipoCusto = 'Todos';
  String _selectedEstado = 'Todos';

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeStreamProvider).value ?? [];
    final currency = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final totalPendente = finance.where((f) => f.estado != 'pago').fold(0.0, (sum, f) => sum + f.valor);
    final totalRecebido = finance.where((f) => f.estado == 'pago').fold(0.0, (sum, f) => sum + f.valor);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EduSectionTitle('Indicadores financeiros'),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 2 : 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isWide ? 3.2 : 3.8,
                children: [
                  ReportKpiCard(
                    title: 'Total recebido',
                    value: currency.format(totalRecebido),
                    icon: Icons.account_balance_wallet_rounded,
                    accentColor: AppTokens.success,
                  ),
                  ReportKpiCard(
                    title: 'Dívida em aberto',
                    value: currency.format(totalPendente),
                    icon: Icons.warning_amber_rounded,
                    accentColor: AppTokens.warning,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          const EduSectionTitle('Geração de documentos'),
          ReportExportTile(
            label: 'Relatório de receitas (propinas)',
            subtitle: 'Lista de pagamentos de propinas recebidos.',
            icon: Icons.trending_up_rounded,
            onTap: () => _showFilterDialog(context, true),
          ),
          ReportExportTile(
            label: 'Relatório de custos',
            subtitle: 'Despesas e pagamentos registados.',
            icon: Icons.trending_down_rounded,
            onTap: () => _showFilterDialog(context, false),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, bool isRevenue) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isRevenue ? 'Relatório de receitas' : 'Relatório de custos'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dropdown('Periodicidade', ['Mensal', 'Trimestral', 'Anual'], _selectedPeriodicidade,
                    (v) => setDialogState(() => _selectedPeriodicidade = v!)),
                const SizedBox(height: 12),
                _dropdown('Ano lectivo', ['2024/2025', '2025/2026'], _selectedAnoLectivo,
                    (v) => setDialogState(() => _selectedAnoLectivo = v!)),
                if (!isRevenue) ...[
                  const SizedBox(height: 12),
                  _dropdown('Tipo de custo', ['Todos', 'Fixo', 'Variável'], _selectedTipoCusto,
                      (v) => setDialogState(() => _selectedTipoCusto = v!)),
                ],
                const SizedBox(height: 12),
                _dropdown('Estado', ['Todos', 'Pagos', 'Não pagos'], _selectedEstado,
                    (v) => setDialogState(() => _selectedEstado = v!)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                final finance = ref.read(financeStreamProvider).value ?? [];
                final costs = ref.read(costsStreamProvider).value ?? [];
                final students = ref.read(studentsStreamProvider).value ?? [];
                final config = ref.read(settingsProvider).value;

                await ReportPdfGenerator.generateFinanceReport(
                  mensalidades: isRevenue ? finance : [],
                  custos: isRevenue ? [] : costs,
                  alunos: isRevenue ? students : [],
                  periodicidade: _selectedPeriodicidade.toUpperCase(),
                  anoLectivo: _selectedAnoLectivo,
                  tipoCusto: _selectedTipoCusto.toUpperCase(),
                  estado: _selectedEstado.toUpperCase(),
                  config: config,
                );
              },
              child: const Text('Gerar PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
