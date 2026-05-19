import '../entities/funcionario.dart';

abstract class StaffRepository {
  Stream<List<Funcionario>> watchFuncionarios();
  Future<Funcionario?> getById(String id);
  Future<void> save(Funcionario funcionario);
  Future<void> delete(String id);
  Future<void> registrarPresenca(String funcionarioId, {required bool presente, String? observacao});
}
