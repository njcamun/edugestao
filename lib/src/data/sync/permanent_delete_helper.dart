import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/data/sync/sync_service.dart';

/// Remoção definitiva local + Firebase (aguarda cloud).
class PermanentDeleteHelper {
  PermanentDeleteHelper(this._db, this._sync);

  final AppDatabase _db;
  final SyncService _sync;

  Future<void> hardDeleteCusto(String id) async {
    await (_db.delete(_db.custosMensais)..where((t) => t.id.equals(id))).go();
    await _sync.deleteFromCloud('custos', id);
  }

  Future<void> hardDeleteMensalidadeGraph(String mensalidadeId) async {
    final cloud = <({String collection, String id})>[];

    final pagamentos = await (_db.select(_db.pagamentos)
          ..where((t) => t.mensalidadeId.equals(mensalidadeId)))
        .get();

    for (final p in pagamentos) {
      if (p.evidenciaId != null) {
        await (_db.delete(_db.evidenciaPagamentos)
              ..where((t) => t.id.equals(p.evidenciaId!)))
            .go();
      }
      await (_db.delete(_db.pagamentos)..where((t) => t.id.equals(p.id))).go();
      cloud.add((collection: 'pagamentos', id: p.id));
    }

    await (_db.delete(_db.mensalidades)..where((t) => t.id.equals(mensalidadeId))).go();
    cloud.add((collection: 'mensalidades', id: mensalidadeId));

    await _sync.deleteManyFromCloud(cloud);
  }

  Future<void> hardDeleteMatriculaCascade(String matriculaId) async {
    final mensalidades = await (_db.select(_db.mensalidades)
          ..where((t) => t.matriculaId.equals(matriculaId)))
        .get();

    for (final m in mensalidades) {
      await hardDeleteMensalidadeGraph(m.id);
    }

    await (_db.delete(_db.matriculas)..where((t) => t.id.equals(matriculaId))).go();
    await _sync.deleteFromCloud('matriculas', matriculaId);
  }

  Future<void> hardDeleteTurmaCascade(String turmaId) async {
    final cloud = <({String collection, String id})>[];

    final mensalidades = await (_db.select(_db.mensalidades)
          ..where((t) => t.turmaId.equals(turmaId)))
        .get();

    for (final m in mensalidades) {
      final pagamentos = await (_db.select(_db.pagamentos)
            ..where((t) => t.mensalidadeId.equals(m.id)))
          .get();
      for (final p in pagamentos) {
        if (p.evidenciaId != null) {
          await (_db.delete(_db.evidenciaPagamentos)
                ..where((t) => t.id.equals(p.evidenciaId!)))
              .go();
        }
        await (_db.delete(_db.pagamentos)..where((t) => t.id.equals(p.id))).go();
        cloud.add((collection: 'pagamentos', id: p.id));
      }
      await (_db.delete(_db.mensalidades)..where((t) => t.id.equals(m.id))).go();
      cloud.add((collection: 'mensalidades', id: m.id));
    }

    final matriculas = await (_db.select(_db.matriculas)
          ..where((t) => t.turmaId.equals(turmaId)))
        .get();
    await (_db.delete(_db.matriculas)..where((t) => t.turmaId.equals(turmaId))).go();
    for (final mat in matriculas) {
      cloud.add((collection: 'matriculas', id: mat.id));
    }

    await (_db.delete(_db.turmas)..where((t) => t.id.equals(turmaId))).go();
    cloud.add((collection: 'turmas', id: turmaId));

    await _sync.deleteManyFromCloud(cloud);
  }

  Future<void> hardDeleteAlunoCascade(String alunoId) async {
    final cloud = <({String collection, String id})>[];

    final mensalidades = await (_db.select(_db.mensalidades)
          ..where((t) => t.alunoId.equals(alunoId)))
        .get();

    for (final m in mensalidades) {
      final pagamentos = await (_db.select(_db.pagamentos)
            ..where((t) => t.mensalidadeId.equals(m.id)))
          .get();
      for (final p in pagamentos) {
        if (p.evidenciaId != null) {
          await (_db.delete(_db.evidenciaPagamentos)
                ..where((t) => t.id.equals(p.evidenciaId!)))
              .go();
        }
        await (_db.delete(_db.pagamentos)..where((t) => t.id.equals(p.id))).go();
        cloud.add((collection: 'pagamentos', id: p.id));
      }
      await (_db.delete(_db.mensalidades)..where((t) => t.id.equals(m.id))).go();
      cloud.add((collection: 'mensalidades', id: m.id));
    }

    final matriculas = await (_db.select(_db.matriculas)
          ..where((t) => t.alunoId.equals(alunoId)))
        .get();
    await (_db.delete(_db.matriculas)..where((t) => t.alunoId.equals(alunoId))).go();
    for (final mat in matriculas) {
      cloud.add((collection: 'matriculas', id: mat.id));
    }

    await (_db.delete(_db.alunos)..where((t) => t.id.equals(alunoId))).go();
    cloud.add((collection: 'alunos', id: alunoId));

    await _sync.deleteManyFromCloud(cloud);
  }
}
