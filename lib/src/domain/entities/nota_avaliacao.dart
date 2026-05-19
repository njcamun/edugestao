import 'sync_entity.dart';

class NotaAvaliacao {
  int? localId;
  late String id;
  late String alunoId;
  late String disciplina;
  late int trimestre;
  late String anoLectivo;
  late double valor;
  String? observacao;

  late bool isDeleted;
  late DateTime createdAt;
  late DateTime updatedAt;
  late SyncStatus syncStatus;
  String? createdBy;
  String? updatedBy;

  NotaAvaliacao();

  static String trimestreLabel(int t) => switch (t) {
        1 => '1º Trimestre',
        2 => '2º Trimestre',
        3 => '3º Trimestre',
        _ => '$tº Trimestre',
      };
}
