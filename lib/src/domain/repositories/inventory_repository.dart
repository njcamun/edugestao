import '../entities/ativo_inventario.dart';

abstract class InventoryRepository {
  Stream<List<AtivoInventario>> watchAtivos();
  Future<AtivoInventario?> getAtivoById(String id);
  Future<void> saveAtivo(AtivoInventario ativo);
  Future<void> deleteAtivo(String id);
  Stream<List<ManutencaoAtivo>> watchManutencoes(String ativoId);
  Future<void> registrarManutencao(ManutencaoAtivo manutencao);
}
