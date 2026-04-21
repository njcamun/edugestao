import 'package:drift/drift.dart';
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/domain/entities/aluno.dart';
import 'package:edugestao/src/domain/entities/sync_entity.dart';

extension AlunoMapper on Aluno {
  AlunosCompanion toCompanion() {
    return AlunosCompanion.insert(
      id: id,
      numeroAluno: numeroAluno,
      nomeCompleto: nomeCompleto,
      dataNascimento: dataNascimento,
      sexo: sexo,
      morada: morada,
      escolaQueFrequenta: escolaQueFrequenta,
      anoEscolaridade: anoEscolaridade,
      possuiCondicaoMedica: possuiCondicaoMedica,
      descricaoCondicaoMedica: Value(descricaoCondicaoMedica),
      nomeEncarregado: nomeEncarregado,
      telefonePrincipal: telefonePrincipal,
      telefoneAlternativo: Value(telefoneAlternativo),
      email: Value(email),
      comoConheceuInstituicao: Value(comoConheceuInstituicao),
      dataInscricao: dataInscricao,
      observacoes: Value(observacoes),
      valorPagamentoInscricao: valorPagamentoInscricao,
      isentoPagamento: isentoPagamento,
      comprovativoInscricaoUrl: Value(comprovativoInscricaoUrl),
      comprovativoInscricaoLocal: Value(comprovativoInscricaoLocal),
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      isDeleted: Value(isDeleted),
    );
  }
}

extension AlunoDataMapper on AlunoData {
  Aluno toEntity() {
    return Aluno()
      ..localId = localId
      ..id = id
      ..numeroAluno = numeroAluno
      ..nomeCompleto = nomeCompleto
      ..dataNascimento = dataNascimento
      ..sexo = sexo
      ..morada = morada
      ..escolaQueFrequenta = escolaQueFrequenta
      ..anoEscolaridade = anoEscolaridade
      ..possuiCondicaoMedica = possuiCondicaoMedica
      ..descricaoCondicaoMedica = descricaoCondicaoMedica
      ..nomeEncarregado = nomeEncarregado
      ..telefonePrincipal = telefonePrincipal
      ..telefoneAlternativo = telefoneAlternativo
      ..email = email
      ..comoConheceuInstituicao = comoConheceuInstituicao
      ..dataInscricao = dataInscricao
      ..observacoes = observacoes
      ..valorPagamentoInscricao = valorPagamentoInscricao
      ..isentoPagamento = isentoPagamento
      ..comprovativoInscricaoUrl = comprovativoInscricaoUrl
      ..comprovativoInscricaoLocal = comprovativoInscricaoLocal
      ..status = status
      ..isDeleted = isDeleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..syncStatus = syncStatus
      ..createdBy = createdBy
      ..updatedBy = updatedBy;
  }
}
