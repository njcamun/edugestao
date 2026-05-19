import '../../../domain/entities/horario_aula.dart';

/// Valida sobreposição de horários (mesma turma ou mesma sala).
class ScheduleConflictChecker {
  static int _toMinutes(String hhmm) {
    final parts = hhmm.trim().split(':');
    if (parts.length != 2) return -1;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return -1;
    return h * 60 + m;
  }

  static bool _overlaps(String inicioA, String fimA, String inicioB, String fimB) {
    final a0 = _toMinutes(inicioA);
    final a1 = _toMinutes(fimA);
    final b0 = _toMinutes(inicioB);
    final b1 = _toMinutes(fimB);
    if (a0 < 0 || a1 < 0 || b0 < 0 || b1 < 0) return false;
    if (a1 <= a0 || b1 <= b0) return false;
    return a0 < b1 && b0 < a1;
  }

  /// Mensagem de conflito ou `null` se válido.
  static String? findConflict({
    required List<HorarioAula> existentes,
    required int diaSemana,
    required String horaInicio,
    required String horaFim,
    String? ignoreHorarioId,
    String? salaLabel,
  }) {
    final ini = _toMinutes(horaInicio);
    final fim = _toMinutes(horaFim);
    if (ini < 0 || fim < 0) return 'Horário inválido. Use o formato HH:mm.';
    if (fim <= ini) return 'A hora de fim deve ser posterior à hora de início.';

    for (final h in existentes) {
      if (h.id == ignoreHorarioId) continue;
      if (h.diaSemana != diaSemana) continue;
      if (_overlaps(horaInicio, horaFim, h.horaInicio, h.horaFim)) {
        final onde = salaLabel != null ? 'na sala $salaLabel' : 'nesta turma';
        return 'Conflito $onde: ${HorarioAula.diaLabel(diaSemana)} ${h.horaInicio}–${h.horaFim} (${h.disciplina}).';
      }
    }
    return null;
  }

  /// IDs de aulas que participam em pelo menos um conflito (mesma lista de horários).
  static Set<String> conflictingIds(List<HorarioAula> horarios) {
    final ids = <String>{};
    for (var i = 0; i < horarios.length; i++) {
      for (var j = i + 1; j < horarios.length; j++) {
        final a = horarios[i];
        final b = horarios[j];
        if (a.diaSemana != b.diaSemana) continue;
        if (_overlaps(a.horaInicio, a.horaFim, b.horaInicio, b.horaFim)) {
          ids.add(a.id);
          ids.add(b.id);
        }
      }
    }
    return ids;
  }

  static String _normProfessor(String? p) => (p ?? '').trim().toLowerCase();

  /// Conflito de professor (mesmo nome em horários sobrepostos, qualquer turma).
  static String? findProfessorConflict({
    required List<HorarioAula> existentes,
    required int diaSemana,
    required String horaInicio,
    required String horaFim,
    required String professor,
    String? ignoreHorarioId,
  }) {
    final nome = _normProfessor(professor);
    if (nome.isEmpty) return null;

    for (final h in existentes) {
      if (h.id == ignoreHorarioId) continue;
      if (h.diaSemana != diaSemana) continue;
      if (_normProfessor(h.professor) != nome) continue;
      if (_overlaps(horaInicio, horaFim, h.horaInicio, h.horaFim)) {
        return 'O professor "$professor" já tem aula ${HorarioAula.diaLabel(diaSemana)} '
            '${h.horaInicio}–${h.horaFim} (${h.disciplina}).';
      }
    }
    return null;
  }

  static Set<String> professorConflictingIds(List<HorarioAula> horarios) {
    final ids = <String>{};
    for (var i = 0; i < horarios.length; i++) {
      for (var j = i + 1; j < horarios.length; j++) {
        final a = horarios[i];
        final b = horarios[j];
        if (a.diaSemana != b.diaSemana) continue;
        if (_normProfessor(a.professor).isEmpty) continue;
        if (_normProfessor(a.professor) != _normProfessor(b.professor)) continue;
        if (_overlaps(a.horaInicio, a.horaFim, b.horaInicio, b.horaFim)) {
          ids.add(a.id);
          ids.add(b.id);
        }
      }
    }
    return ids;
  }

  static List<String> describeProfessorConflicts(List<HorarioAula> horarios) {
    final messages = <String>[];
    for (var i = 0; i < horarios.length; i++) {
      for (var j = i + 1; j < horarios.length; j++) {
        final a = horarios[i];
        final b = horarios[j];
        if (a.diaSemana != b.diaSemana) continue;
        final pa = _normProfessor(a.professor);
        final pb = _normProfessor(b.professor);
        if (pa.isEmpty || pa != pb) continue;
        if (_overlaps(a.horaInicio, a.horaFim, b.horaInicio, b.horaFim)) {
          messages.add(
            'Professor ${a.professor}: ${HorarioAula.diaLabel(a.diaSemana)} '
            '${a.horaInicio}–${a.horaFim} (${a.disciplina}) × ${b.horaInicio}–${b.horaFim} (${b.disciplina})',
          );
        }
      }
    }
    return messages;
  }

  static List<String> describeConflicts(List<HorarioAula> horarios) {
    final messages = <String>[];
    for (var i = 0; i < horarios.length; i++) {
      for (var j = i + 1; j < horarios.length; j++) {
        final a = horarios[i];
        final b = horarios[j];
        if (a.diaSemana != b.diaSemana) continue;
        if (_overlaps(a.horaInicio, a.horaFim, b.horaInicio, b.horaFim)) {
          messages.add(
            '${HorarioAula.diaLabel(a.diaSemana)} ${a.horaInicio}–${a.horaFim} (${a.disciplina}) '
            '× ${b.horaInicio}–${b.horaFim} (${b.disciplina})',
          );
        }
      }
    }
    return messages;
  }
}
