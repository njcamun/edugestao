import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/horario_aula.dart';

/// Grade semanal compacta (dias × aulas).
class ScheduleWeekGrid extends StatelessWidget {
  const ScheduleWeekGrid({super.key, required this.horarios, this.conflictIds = const {}});

  final List<HorarioAula> horarios;
  final Set<String> conflictIds;

  @override
  Widget build(BuildContext context) {
    final dias = HorarioAula.diasSemana.keys.where((d) => d <= 6).toList();
    final porDia = <int, List<HorarioAula>>{};
    for (final h in horarios) {
      porDia.putIfAbsent(h.diaSemana, () => []).add(h);
    }
    for (final list in porDia.values) {
      list.sort((a, b) => a.horaInicio.compareTo(b.horaInicio));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width - 32),
        child: Table(
          border: TableBorder.all(color: AppTokens.border),
          columnWidths: {
            0: const FixedColumnWidth(88),
            for (var i = 0; i < dias.length; i++) i + 1: const FlexColumnWidth(),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: AppTokens.primary.withValues(alpha: 0.08)),
              children: [
                const _HeaderCell('Hora'),
                ...dias.map((d) => _HeaderCell(HorarioAula.diaLabel(d))),
              ],
            ),
            ..._buildRows(dias, porDia, conflictIds),
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildRows(List<int> dias, Map<int, List<HorarioAula>> porDia, Set<String> conflictIds) {
    final slots = <String>{};
    for (final h in horarios) {
      slots.add('${h.horaInicio}-${h.horaFim}');
    }
    final orderedSlots = slots.toList()..sort();

    if (orderedSlots.isEmpty) return [];

    return orderedSlots.map((slot) {
      final parts = slot.split('-');
      return TableRow(
        children: [
          _BodyCell(parts.join('\n'), bold: true),
          ...dias.map((dia) {
            final aulas = porDia[dia] ?? [];
            final match = aulas.where((a) => '${a.horaInicio}-${a.horaFim}' == slot).toList();
            if (match.isEmpty) return const _BodyCell('—');
            final a = match.first;
            final emConflito = match.any((h) => conflictIds.contains(h.id));
            return _BodyCell(
              '${a.disciplina}\n${a.professor ?? ''}'.trim(),
              subtitle: match.length > 1 ? '+${match.length - 1}' : null,
              highlight: emConflito,
            );
          }),
        ],
      );
    }).toList();
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTokens.primaryDark),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell(this.text, {this.bold = false, this.subtitle, this.highlight = false});

  final String text;
  final bool bold;
  final String? subtitle;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlight ? AppTokens.error.withValues(alpha: 0.12) : null,
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
              color: AppTokens.textPrimary,
            ),
          ),
          if (subtitle != null)
            Text(subtitle!, style: const TextStyle(fontSize: 9, color: AppTokens.textMuted)),
        ],
      ),
    );
  }
}

