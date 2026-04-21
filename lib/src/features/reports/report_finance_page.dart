import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  String _selectedPeriodicidade = 'ANUAL';
  String _selectedTipoCusto = 'TODOS'; 
  String _selectedEstado = 'TODOS'; 

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeStreamProvider).value ?? [];
    final totalPendente = finance.where((f) => f.estado != 'pago').fold(0.0, (sum, f) => sum + f.valor);
    final totalRecebido = finance.where((f) => f.estado == 'pago').fold(0.0, (sum, f) => sum + f.valor);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('INDICADORES FINANCEIROS'),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isWide ? 3.5 : 4,
                children: [
                  _ReportKpiCard(
                    title: 'TOTAL RECEBIDO',
                    value: '${totalRecebido.toStringAsFixed(2)} KZ',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  _ReportKpiCard(
                    title: 'DÍVIDA EM ABERTO',
                    value: '${totalPendente.toStringAsFixed(2)} KZ',
                    icon: Icons.warning_amber_rounded,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 40),
          _buildSectionHeader('GERAÇÃO DE DOCUMENTOS'),
          const SizedBox(height: 16),
          
          _ExportActionTile(
            label: 'RELATÓRIO DE RECEITAS (PROPINAS)',
            subtitle: 'Lista de pagamentos de propinas recebidos.',
            icon: Icons.trending_up_rounded,
            onTap: () => _showFilterDialog(context, true),
          ),
          _ExportActionTile(
            label: 'RELATÓRIO DE CUSTOS (INVENTÁRIO)',
            subtitle: 'Lista de despesas e pagamentos do inventário.',
            icon: Icons.trending_down_rounded,
            onTap: () => _showFilterDialog(context, false),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.5),
    );
  }

  void _showFilterDialog(BuildContext context, bool isRevenue) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
          title: Text(isRevenue ? 'RELATÓRIO DE RECEITAS' : 'RELATÓRIO DE CUSTOS', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogDropdown('PERIODICIDADE', ['MENSAL', 'TRIMESTRAL', 'ANUAL'], _selectedPeriodicidade, (v) => setDialogState(() => _selectedPeriodicidade = v!)),
                const SizedBox(height: 12),
                _buildDialogDropdown('ANO LECTIVO', ['2024/2025', '2023/2024'], _selectedAnoLectivo, (v) => setDialogState(() => _selectedAnoLectivo = v!)),
                if (!isRevenue) ...[
                  const SizedBox(height: 12),
                  _buildDialogDropdown('TIPO DE CUSTO', ['TODOS', 'FIXO', 'VARIAVEL'], _selectedTipoCusto, (v) => setDialogState(() => _selectedTipoCusto = v!)),
                ],
                const SizedBox(height: 12),
                _buildDialogDropdown('ESTADO', ['TODOS', 'PAGOS', 'NÃO PAGOS'], _selectedEstado, (v) => setDialogState(() => _selectedEstado = v!)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                final finance = ref.read(financeStreamProvider).value ?? [];
                final costs = ref.read(costsStreamProvider).value ?? [];
                final students = ref.read(studentsStreamProvider).value ?? [];
                final config = ref.read(settingsProvider).value;

                if (isRevenue) {
                  await ReportPdfGenerator.generateFinanceReport(
                    mensalidades: finance,
                    custos: [], // Envia vazio para focar em receitas
                    alunos: students,
                    periodicidade: _selectedPeriodicidade,
                    anoLectivo: _selectedAnoLectivo,
                    tipoCusto: 'TODOS',
                    estado: _selectedEstado,
                    config: config,
                  );
                } else {
                  await ReportPdfGenerator.generateFinanceReport(
                    mensalidades: [], // Envia vazio para focar em custos
                    custos: costs,
                    alunos: [],
                    periodicidade: _selectedPeriodicidade,
                    anoLectivo: _selectedAnoLectivo,
                    tipoCusto: _selectedTipoCusto,
                    estado: _selectedEstado,
                    config: config,
                  );
                }
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('GERAR PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
      onChanged: onChanged,
    );
  }
}

class _ReportKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _ReportKpiCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.black54)),
                FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportActionTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _ExportActionTile({required this.label, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black, size: 24),
        title: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
