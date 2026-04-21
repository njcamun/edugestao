import 'package:drift/drift.dart';

import 'tables.dart';
import 'connection/connection.dart' as impl;
import '../../../domain/entities/sync_entity.dart';
import '../../../domain/entities/aluno.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Alunos,
  CustosMensais,
  Turmas,
  AnosLectivos,
  Matriculas,
  Pagamentos,
  Auditorias,
  NotificacoesInternas,
  Mensalidades,
  Configuracoes,
  EvidenciaPagamentos,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;
}
