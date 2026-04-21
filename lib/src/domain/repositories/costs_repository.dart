import '../entities/custo.dart';

abstract class CostsRepository {
  Stream<List<CustoMensal>> watchCustos();
  Stream<List<CustoMensal>> watchCustosAdmin();
  Future<void> saveCusto(CustoMensal custo);
  Future<void> deleteCusto(String id);
  Future<void> permanentDeleteCusto(String id);
  Future<void> restoreCusto(String id);
  Future<CustoMensal?> getCustoById(String id);
  Future<void> checkAndGenerateMonthlyCosts(); // Nova funcionalidade para itens fixos
}
