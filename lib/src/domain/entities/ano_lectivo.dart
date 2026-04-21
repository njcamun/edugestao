import 'sync_entity.dart';

class AnoLectivo implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String ano; // ex: 2024, 2024/2025

  late DateTime dataInicio;
  late DateTime dataFim;
  
  late bool isActive;

  @override
  bool isDeleted = false;

  @override
  late DateTime createdAt;
  @override
  late DateTime updatedAt;
  @override
  late SyncStatus syncStatus;
  @override
  String? createdBy;
  @override
  String? updatedBy;

  AnoLectivo();
}
