import '../entities/horario_aula.dart';

abstract class SchedulesRepository {
  Stream<List<HorarioAula>> watchHorarios(String turmaId);
  Future<List<HorarioAula>> listHorarios(String turmaId);
  Future<List<HorarioAula>> listAllHorarios();
  Future<void> save(HorarioAula horario);
  Future<void> delete(String id);
}
