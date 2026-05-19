import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';

class DashboardChart extends StatelessWidget {
  final List<double> receitas;
  final List<double> despesas;
  final List<String> labels;

  const DashboardChart({
    super.key,
    required this.receitas,
    required this.despesas,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    if (receitas.isEmpty && despesas.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('Sem dados para o gráfico')),
      );
    }

    final maxVal = [
      ...receitas,
      ...despesas,
    ].fold<double>(0, (a, b) => b > a ? b : a);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _legend('Receitas', AppTokens.primary),
            const SizedBox(width: 16),
            _legend('Despesas', AppTokens.accentPurple),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(labels.length, (i) {
              final r = receitas.length > i ? receitas[i] : 0.0;
              final d = despesas.length > i ? despesas[i] : 0.0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _bar(r, maxVal, AppTokens.primary),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: _bar(d, maxVal, AppTokens.accentPurple),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        labels[i],
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _bar(double value, double max, Color color) {
    final h = max > 0 ? (value / max) * 120 : 4.0;
    return Container(
      height: h.clamp(4, 120),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary)),
      ],
    );
  }
}
