class NotificacaoInterna {
  int? localId;

  late String id;

  late String titulo;
  late String mensagem;
  late String tipo; // 'info', 'warning', 'error', 'success'
  late bool lida;
  
  String? entidadeRelacionada; // 'Matricula', 'Pagamento'
  String? entidadeId;
  
  late DateTime createdAt;

  NotificacaoInterna() {
    lida = false;
    createdAt = DateTime.now();
  }
}
