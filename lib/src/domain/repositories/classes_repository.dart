import '../entities/turma.dart';

abstract class ClassesRepository {
  Stream<List<Turma>> watchTurmas();
  Stream<List<Turma>> watchTurmasAdmin();
  Future<void> saveTurma(Turma turma);
  Future<void> deleteTurma(String id);
  Future<void> permanentDeleteTurma(String id);
  Future<void> restoreTurma(String id);
  Future<Turma?> getTurmaById(String id);
}
