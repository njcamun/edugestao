import 'package:drift/drift.dart';
import '../../../domain/entities/sync_entity.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/funcionario.dart';
import '../../../domain/entities/salario.dart';
import '../../../domain/entities/ativo_inventario.dart';

mixin SyncColumns on Table {
  TextColumn get id => text()(); // UUID único
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get syncStatus => intEnum<SyncStatus>()();
  TextColumn get createdBy => text().nullable()();
  TextColumn get updatedBy => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

@DataClassName('AlunoData')
class Alunos extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  
  TextColumn get numeroAluno => text().unique()();
  TextColumn get nomeCompleto => text()();
  DateTimeColumn get dataNascimento => dateTime()();
  TextColumn get sexo => text()();
  TextColumn get morada => text()();
  TextColumn get escolaQueFrequenta => text()();
  TextColumn get anoEscolaridade => text()();
  
  BoolColumn get possuiCondicaoMedica => boolean()();
  TextColumn get descricaoCondicaoMedica => text().nullable()();
  
  TextColumn get nomeEncarregado => text()();
  TextColumn get telefonePrincipal => text()();
  TextColumn get telefoneAlternativo => text().nullable()();
  TextColumn get email => text().nullable()();
  
  TextColumn get comoConheceuInstituicao => text().nullable()();
  DateTimeColumn get dataInscricao => dateTime()();
  TextColumn get observacoes => text().nullable()();

  RealColumn get valorPagamentoInscricao => real()();
  BoolColumn get isentoPagamento => boolean()();
  TextColumn get comprovativoInscricaoUrl => text().nullable()();
  TextColumn get comprovativoInscricaoLocal => text().nullable()();

  IntColumn get status => intEnum<AlunoStatus>()();
}

@DataClassName('CustoMensalData')
class CustosMensais extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  
  TextColumn get descricao => text()();
  TextColumn get categoria => text()();
  RealColumn get valor => real()();
  DateTimeColumn get data => dateTime()();
  
  TextColumn get tipo => text()(); 
  IntColumn get mesReferencia => integer()();
  IntColumn get anoReferencia => integer()();
  
  TextColumn get estado => text()(); 

  TextColumn get observacao => text().nullable()();
  TextColumn get comprovativoUrl => text().nullable()();
  TextColumn get comprovativoLocal => text().nullable()();
  TextColumn get responsavelId => text()();
}

@DataClassName('TurmaData')
class Turmas extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get nomeTurma => text()();
  IntColumn get limiteAlunos => integer()();
  TextColumn get turno => text()();
  TextColumn get numeroSala => text()();
  BoolColumn get ativa => boolean()();
  TextColumn get anoLectivoId => text()(); // Referência
}

@DataClassName('AnosLectivoData')
class AnosLectivos extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get ano => text().unique()();
  DateTimeColumn get dataInicio => dateTime()();
  DateTimeColumn get dataFim => dateTime()();
  BoolColumn get isActive => boolean()();
}

@DataClassName('MatriculaData')
class Matriculas extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get numeroMatricula => text()();
  TextColumn get alunoId => text()();
  TextColumn get turmaId => text()();
  TextColumn get turno => text()();
  TextColumn get anoLectivo => text()();
  DateTimeColumn get dataMatricula => dateTime()();
  TextColumn get estado => text()();
  RealColumn get valorMensalidade => real()();
  IntColumn get diaVencimento => integer()();
}

@DataClassName('PagamentoData')
class Pagamentos extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get mensalidadeId => text()();
  RealColumn get valorPago => real()();
  DateTimeColumn get dataPagamento => dateTime()();
  TextColumn get formaPagamento => text()();
  TextColumn get observacao => text().nullable()();
  TextColumn get evidenciaId => text().nullable()();
  TextColumn get numeroRecibo => text()();
  TextColumn get confirmadoPor => text()();
}

@DataClassName('AuditoriaData')
class Auditorias extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get entidade => text()();
  TextColumn get entidadeId => text()();
  TextColumn get acao => text()();
  TextColumn get valorAnteriorJson => text().nullable()();
  TextColumn get valorNovoJson => text().nullable()();
  TextColumn get utilizadorId => text()();
  DateTimeColumn get dataHora => dateTime()();
}

@DataClassName('NotificacoesInternaData')
class NotificacoesInternas extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get titulo => text()();
  TextColumn get mensagem => text()();
  TextColumn get tipo => text()();
  TextColumn get entidadeRelacionada => text().nullable()();
  TextColumn get entidadeId => text().nullable()();
  BoolColumn get lida => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('MensalidadeData')
class Mensalidades extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get matriculaId => text()();
  TextColumn get alunoId => text()();
  TextColumn get turmaId => text()();
  TextColumn get turno => text()();
  IntColumn get mesReferencia => integer()();
  IntColumn get anoReferencia => integer()();
  RealColumn get valor => real()();
  DateTimeColumn get dataVencimento => dateTime()();
  TextColumn get estado => text()();
  DateTimeColumn get dataPagamento => dateTime().nullable()();
  TextColumn get observacao => text().nullable()();
}

@DataClassName('EvidenciaPagamentoData')
class EvidenciaPagamentos extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get id => text().unique()();
  TextColumn get tipoArquivo => text()();
  TextColumn get nomeArquivo => text()();
  TextColumn get urlRemota => text().nullable()();
  TextColumn get caminhoLocal => text()();
  IntColumn get tamanhoBytes => integer()();
  TextColumn get mimeType => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncStatus => intEnum<SyncStatus>()();
}

@DataClassName('FuncionarioData')
class Funcionarios extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get numeroFuncionario => text().unique()();
  TextColumn get nomeCompleto => text()();
  TextColumn get cargo => text()();
  TextColumn get email => text().nullable()();
  TextColumn get telefone => text()();
  TextColumn get documentoIdentidade => text().nullable()();
  DateTimeColumn get dataAdmissao => dateTime()();
  RealColumn get salarioBase => real()();
  IntColumn get status => intEnum<FuncionarioStatus>()();
  DateTimeColumn get ultimaPresenca => dateTime().nullable()();
  TextColumn get observacoes => text().nullable()();
}

@DataClassName('SalarioData')
class Salarios extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get funcionarioId => text()();
  TextColumn get funcionarioNome => text()();
  IntColumn get mesReferencia => integer()();
  IntColumn get anoReferencia => integer()();
  RealColumn get valorBase => real()();
  RealColumn get descontos => real()();
  RealColumn get bonus => real()();
  RealColumn get valorLiquido => real()();
  IntColumn get estado => intEnum<SalarioEstado>()();
  DateTimeColumn get dataPagamento => dateTime().nullable()();
  TextColumn get observacao => text().nullable()();
}

@DataClassName('PresencaFuncionarioData')
class PresencasFuncionarios extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get funcionarioId => text()();
  DateTimeColumn get data => dateTime()();
  BoolColumn get presente => boolean()();
  TextColumn get observacao => text().nullable()();
}

@DataClassName('AtivoInventarioData')
class AtivosInventario extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get codigo => text().unique()();
  TextColumn get nome => text()();
  TextColumn get categoria => text()();
  TextColumn get localizacao => text()();
  IntColumn get estado => intEnum<AtivoEstado>()();
  RealColumn get valorAquisicao => real()();
  DateTimeColumn get dataAquisicao => dateTime()();
  DateTimeColumn get ultimaManutencao => dateTime().nullable()();
  TextColumn get observacoes => text().nullable()();
}

@DataClassName('NotaAvaliacaoData')
class NotasAvaliacao extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get alunoId => text()();
  TextColumn get disciplina => text()();
  IntColumn get trimestre => integer()();
  TextColumn get anoLectivo => text()();
  RealColumn get valor => real()();
  TextColumn get observacao => text().nullable()();
}

@DataClassName('HorarioAulaData')
class HorariosAula extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();

  TextColumn get turmaId => text()();
  IntColumn get diaSemana => integer()();
  TextColumn get horaInicio => text()();
  TextColumn get horaFim => text()();
  TextColumn get disciplina => text()();
  TextColumn get professor => text().nullable()();
}

@DataClassName('ManutencaoAtivoData')
class ManutencoesAtivo extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get ativoId => text()();
  DateTimeColumn get data => dateTime()();
  TextColumn get descricao => text()();
  RealColumn get custo => real()();
  TextColumn get realizadoPor => text().nullable()();
}

@DataClassName('ConfiguracaoData')
class Configuracoes extends Table with SyncColumns {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get nomeInstituicao => text()();
  TextColumn get logotipoUrl => text().nullable()();
  TextColumn get morada => text()();
  TextColumn get telefone => text()();
  TextColumn get email => text()();
  TextColumn get nif => text()();
  TextColumn get moedaPadrao => text()();
  TextColumn get textoRodapeRelatorio => text()();
  TextColumn get reciboPrefixo => text()();
}
