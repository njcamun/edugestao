class Auditoria {
  int? localId;

  late String id;
  late String entidade; // 'Aluno', 'Mensalidade', etc.
  late String entidadeId;
  late String acao; // 'CREATE', 'UPDATE', 'DELETE'
  
  String? valorAnteriorJson;
  String? valorNovoJson;
  
  late String utilizadorId;
  late DateTime dataHora;

  Auditoria();
}
