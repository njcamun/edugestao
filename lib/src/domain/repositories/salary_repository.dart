import '../entities/salario.dart';

abstract class SalaryRepository {
  Stream<List<Salario>> watchSalarios({int? mes, int? ano});
  Future<Salario?> getById(String id);
  Future<void> save(Salario salario);
  Future<void> marcarComoPago(String id);
  Future<void> delete(String id);
}
