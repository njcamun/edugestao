import '../entities/mensalidade.dart';
import '../entities/pagamento.dart';
import '../entities/evidencia_pagamento.dart';

abstract class FinanceRepository {
  Stream<List<Mensalidade>> watchMensalidades({String? alunoId});
  Future<void> saveMensalidade(Mensalidade mensalidade);
  Future<void> saveMultipleMensalidades(List<Mensalidade> mensalidades);
  
  // Novo: Gestão de Pagamentos e Evidências
  Future<void> confirmarPagamento({
    required Pagamento pagamento,
    required EvidenciaPagamento evidencia,
    required String mensalidadeId,
  });
  
  Future<List<Pagamento>> getPagamentosByMensalidade(String mensalidadeId);
  Future<EvidenciaPagamento?> getEvidenciaById(String evidenciaId);

  // Manutenção
  Future<void> resetAndRecreateMensalidades(int startingMonth, int year);
  Future<void> generateMonthlyFees({String? matriculaId, required int month, required int year});
  Future<void> deleteFeesFromMonth(int startingMonth, int year);
}
