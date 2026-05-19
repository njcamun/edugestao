import 'sync_entity.dart';

class HorarioAula {
  int? localId;
  late String id;
  late String turmaId;
  late int diaSemana;
  late String horaInicio;
  late String horaFim;
  late String disciplina;
  String? professor;

  late bool isDeleted;
  late DateTime createdAt;
  late DateTime updatedAt;
  late SyncStatus syncStatus;
  String? createdBy;
  String? updatedBy;

  HorarioAula();

  static const diasSemana = {
    1: 'Segunda',
    2: 'Terça',
    3: 'Quarta',
    4: 'Quinta',
    5: 'Sexta',
    6: 'Sábado',
    7: 'Domingo',
  };

  static String diaLabel(int dia) => diasSemana[dia] ?? 'Dia $dia';
}
