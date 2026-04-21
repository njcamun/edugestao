import 'sync_entity.dart';

enum AlunoStatus { ativo, inativo }

class Aluno implements SyncEntity {
  int? localId;

  @override
  late String id;

  late String numeroAluno;
  
  late String nomeCompleto;
  
  late DateTime dataNascimento;
  late String sexo;
  late String morada;
  late String escolaQueFrequenta;
  late String anoEscolaridade;
  
  late bool possuiCondicaoMedica;
  String? descricaoCondicaoMedica;
  
  late String nomeEncarregado;
  late String telefonePrincipal;
  String? telefoneAlternativo;
  String? email;
  
  String? comoConheceuInstituicao;
  late DateTime dataInscricao;
  String? observacoes;

  // Novos campos de Pagamento de Inscrição
  late double valorPagamentoInscricao;
  late bool isentoPagamento;
  String? comprovativoInscricaoUrl;
  String? comprovativoInscricaoLocal;

  late AlunoStatus status;

  @override
  bool isDeleted = false;

  @override
  late DateTime createdAt;
  @override
  late DateTime updatedAt;
  @override
  late SyncStatus syncStatus;
  @override
  String? createdBy;
  @override
  String? updatedBy;

  Aluno();
}
