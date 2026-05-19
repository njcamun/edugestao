import 'package:drift/drift.dart';

import 'tables.dart';
import 'connection/connection.dart' as impl;
import '../../../domain/entities/sync_entity.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/funcionario.dart';
import '../../../domain/entities/salario.dart';
import '../../../domain/entities/ativo_inventario.dart';

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
  Funcionarios,
  Salarios,
  PresencasFuncionarios,
  AtivosInventario,
  ManutencoesAtivo,
  NotasAvaliacao,
  HorariosAula,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(funcionarios);
            await m.createTable(salarios);
            await m.createTable(presencasFuncionarios);
          }
          if (from < 3) {
            await m.createTable(ativosInventario);
            await m.createTable(manutencoesAtivo);
          }
          if (from < 4) {
            await m.createTable(notasAvaliacao);
            await m.createTable(horariosAula);
          }
        },
      );
}
