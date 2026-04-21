import 'sync_entity.dart';

class EvidenciaPagamento {
  int? localId;

  late String id;

  late String tipoArquivo;
  late String nomeArquivo;
  String? urlRemota;
  late String caminhoLocal;
  late int tamanhoBytes;
  late String mimeType;
  
  late DateTime createdAt;
  
  late SyncStatus syncStatus;

  EvidenciaPagamento();
}
