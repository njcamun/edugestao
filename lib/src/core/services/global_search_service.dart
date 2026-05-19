import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';
import '../../data/local/drift/app_database.dart';
import '../../data/local/drift/mappers/aluno_mapper.dart';
import '../../data/local/drift/mappers/ativo_inventario_mapper.dart';
import '../../data/local/drift/mappers/funcionario_mapper.dart';
import '../../data/local/drift/mappers/turma_mapper.dart';

enum SearchResultType { aluno, turma, funcionario, matricula, ativo }

class SearchResult {
  final SearchResultType type;
  final String id;
  final String title;
  final String subtitle;
  final String route;

  const SearchResult({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}

class GlobalSearchService {
  final AppDatabase _db;

  GlobalSearchService(this._db);

  Future<List<SearchResult>> search(String query, {int limit = 25}) async {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return [];

    final results = <SearchResult>[];

    final alunos = await (_db.select(_db.alunos)..where((t) => t.isDeleted.equals(false))).get();
    final alunoMap = <String, String>{};
    for (final row in alunos) {
      final a = row.toEntity();
      alunoMap[a.id] = a.nomeCompleto;
      if (a.nomeCompleto.toLowerCase().contains(q) || a.numeroAluno.toLowerCase().contains(q)) {
        results.add(SearchResult(
          type: SearchResultType.aluno,
          id: a.id,
          title: a.nomeCompleto,
          subtitle: 'Aluno · Nº ${a.numeroAluno}',
          route: '/alunos/${a.id}',
        ));
      }
    }

    final matriculas =
        await (_db.select(_db.matriculas)..where((t) => t.isDeleted.equals(false))).get();
    for (final m in matriculas) {
      if (m.numeroMatricula.toLowerCase().contains(q)) {
        final nome = alunoMap[m.alunoId] ?? 'Aluno';
        results.add(SearchResult(
          type: SearchResultType.matricula,
          id: m.id,
          title: 'Matrícula ${m.numeroMatricula}',
          subtitle: '$nome · ${m.anoLectivo}',
          route: '/alunos',
        ));
      }
    }

    final turmas = await (_db.select(_db.turmas)..where((t) => t.isDeleted.equals(false))).get();
    for (final row in turmas) {
      final t = row.toEntity();
      if (t.nomeTurma.toLowerCase().contains(q) || t.numeroSala.toLowerCase().contains(q)) {
        results.add(SearchResult(
          type: SearchResultType.turma,
          id: t.id,
          title: t.nomeTurma,
          subtitle: 'Turma · Sala ${t.numeroSala}',
          route: '/alunos',
        ));
      }
    }

    final funcs =
        await (_db.select(_db.funcionarios)..where((t) => t.isDeleted.equals(false))).get();
    for (final row in funcs) {
      final f = row.toEntity();
      if (f.nomeCompleto.toLowerCase().contains(q) ||
          f.numeroFuncionario.toLowerCase().contains(q) ||
          f.cargo.toLowerCase().contains(q)) {
        results.add(SearchResult(
          type: SearchResultType.funcionario,
          id: f.id,
          title: f.nomeCompleto,
          subtitle: 'Funcionário · ${f.cargo}',
          route: '/funcionarios',
        ));
      }
    }

    final ativos =
        await (_db.select(_db.ativosInventario)..where((t) => t.isDeleted.equals(false))).get();
    for (final row in ativos) {
      final a = row.toEntity();
      if (a.nome.toLowerCase().contains(q) ||
          a.codigo.toLowerCase().contains(q) ||
          a.localizacao.toLowerCase().contains(q)) {
        results.add(SearchResult(
          type: SearchResultType.ativo,
          id: a.id,
          title: a.nome,
          subtitle: 'Inventário · ${a.codigo} · ${a.localizacao}',
          route: '/inventario',
        ));
      }
    }

    return results.take(limit).toList();
  }
}

final globalSearchServiceProvider = Provider<GlobalSearchService>((ref) {
  return GlobalSearchService(ref.watch(databaseProvider));
});
