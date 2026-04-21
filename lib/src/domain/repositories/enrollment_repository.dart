import '../entities/matricula.dart';

abstract class EnrollmentRepository {
  Stream<List<Matricula>> watchMatriculas();
  Stream<List<Matricula>> watchMatriculasAdmin();
  Future<void> saveMatricula(Matricula matricula);
  Future<void> deleteMatricula(String id);
  Future<void> permanentDeleteMatricula(String id);
  Future<void> restoreMatricula(String id);
  Future<Matricula?> getMatriculaById(String id);
}
