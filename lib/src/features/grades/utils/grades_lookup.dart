import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/matricula.dart';
import '../../../domain/entities/turma.dart';

class GradesLookup {
  static Matricula? _matriculaAtiva(String alunoId, String anoLectivo, List<Matricula> matriculas) {
    final ano = anoLectivo.split('/').first;
    for (final m in matriculas) {
      if (m.alunoId != alunoId || m.estado != 'ativa') continue;
      if (m.anoLectivo == anoLectivo || m.anoLectivo.contains(ano)) return m;
    }
    for (final m in matriculas) {
      if (m.alunoId == alunoId && m.estado == 'ativa') return m;
    }
    return null;
  }

  static String? turmaNomeAluno({
    required String alunoId,
    required String anoLectivo,
    required List<Matricula> matriculas,
    required List<Turma> turmas,
  }) {
    final mat = _matriculaAtiva(alunoId, anoLectivo, matriculas);
    if (mat == null) return null;
    for (final t in turmas) {
      if (t.id == mat.turmaId) return t.nomeTurma;
    }
    return null;
  }

  static List<Aluno> alunosDaTurma({
    required String turmaId,
    required List<Aluno> alunos,
    required List<Matricula> matriculas,
  }) {
    final ids = matriculas
        .where((m) => m.turmaId == turmaId && m.estado == 'ativa')
        .map((m) => m.alunoId)
        .toSet();
    final lista = alunos.where((a) => ids.contains(a.id)).toList()
      ..sort((a, b) => a.nomeCompleto.compareTo(b.nomeCompleto));
    return lista;
  }

  static Map<String, String> turmasPorAluno({
    required List<Aluno> alunos,
    required String anoLectivo,
    required List<Matricula> matriculas,
    required List<Turma> turmas,
  }) {
    return {
      for (final a in alunos)
        a.id: turmaNomeAluno(
              alunoId: a.id,
              anoLectivo: anoLectivo,
              matriculas: matriculas,
              turmas: turmas,
            ) ??
            '',
    };
  }
}
