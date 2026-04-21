import '../entities/aluno.dart';

abstract class StudentRepository {
  Stream<List<Aluno>> watchAlunos();
  Stream<List<Aluno>> watchAlunosAdmin(); // Permite ver deletados
  Future<void> saveAluno(Aluno aluno);
  Future<void> deleteAluno(String id);
  Future<void> permanentDeleteAluno(String id);
  Future<void> restoreAluno(String id);
  Future<Aluno?> getAlunoById(String id);
}
