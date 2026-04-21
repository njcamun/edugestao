// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AlunosTable extends Alunos with TableInfo<$AlunosTable, AlunoData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$AlunosTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($AlunosTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _numeroAlunoMeta = const VerificationMeta('numeroAluno');
@override
late final GeneratedColumn<String> numeroAluno = GeneratedColumn<String>('numero_aluno', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
static const VerificationMeta _nomeCompletoMeta = const VerificationMeta('nomeCompleto');
@override
late final GeneratedColumn<String> nomeCompleto = GeneratedColumn<String>('nome_completo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _dataNascimentoMeta = const VerificationMeta('dataNascimento');
@override
late final GeneratedColumn<DateTime> dataNascimento = GeneratedColumn<DateTime>('data_nascimento', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _sexoMeta = const VerificationMeta('sexo');
@override
late final GeneratedColumn<String> sexo = GeneratedColumn<String>('sexo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _moradaMeta = const VerificationMeta('morada');
@override
late final GeneratedColumn<String> morada = GeneratedColumn<String>('morada', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _escolaQueFrequentaMeta = const VerificationMeta('escolaQueFrequenta');
@override
late final GeneratedColumn<String> escolaQueFrequenta = GeneratedColumn<String>('escola_que_frequenta', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _anoEscolaridadeMeta = const VerificationMeta('anoEscolaridade');
@override
late final GeneratedColumn<String> anoEscolaridade = GeneratedColumn<String>('ano_escolaridade', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _possuiCondicaoMedicaMeta = const VerificationMeta('possuiCondicaoMedica');
@override
late final GeneratedColumn<bool> possuiCondicaoMedica = GeneratedColumn<bool>('possui_condicao_medica', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("possui_condicao_medica" IN (0, 1))'));
static const VerificationMeta _descricaoCondicaoMedicaMeta = const VerificationMeta('descricaoCondicaoMedica');
@override
late final GeneratedColumn<String> descricaoCondicaoMedica = GeneratedColumn<String>('descricao_condicao_medica', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _nomeEncarregadoMeta = const VerificationMeta('nomeEncarregado');
@override
late final GeneratedColumn<String> nomeEncarregado = GeneratedColumn<String>('nome_encarregado', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _telefonePrincipalMeta = const VerificationMeta('telefonePrincipal');
@override
late final GeneratedColumn<String> telefonePrincipal = GeneratedColumn<String>('telefone_principal', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _telefoneAlternativoMeta = const VerificationMeta('telefoneAlternativo');
@override
late final GeneratedColumn<String> telefoneAlternativo = GeneratedColumn<String>('telefone_alternativo', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _emailMeta = const VerificationMeta('email');
@override
late final GeneratedColumn<String> email = GeneratedColumn<String>('email', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _comoConheceuInstituicaoMeta = const VerificationMeta('comoConheceuInstituicao');
@override
late final GeneratedColumn<String> comoConheceuInstituicao = GeneratedColumn<String>('como_conheceu_instituicao', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _dataInscricaoMeta = const VerificationMeta('dataInscricao');
@override
late final GeneratedColumn<DateTime> dataInscricao = GeneratedColumn<DateTime>('data_inscricao', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _observacoesMeta = const VerificationMeta('observacoes');
@override
late final GeneratedColumn<String> observacoes = GeneratedColumn<String>('observacoes', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _valorPagamentoInscricaoMeta = const VerificationMeta('valorPagamentoInscricao');
@override
late final GeneratedColumn<double> valorPagamentoInscricao = GeneratedColumn<double>('valor_pagamento_inscricao', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
static const VerificationMeta _isentoPagamentoMeta = const VerificationMeta('isentoPagamento');
@override
late final GeneratedColumn<bool> isentoPagamento = GeneratedColumn<bool>('isento_pagamento', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("isento_pagamento" IN (0, 1))'));
static const VerificationMeta _comprovativoInscricaoUrlMeta = const VerificationMeta('comprovativoInscricaoUrl');
@override
late final GeneratedColumn<String> comprovativoInscricaoUrl = GeneratedColumn<String>('comprovativo_inscricao_url', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _comprovativoInscricaoLocalMeta = const VerificationMeta('comprovativoInscricaoLocal');
@override
late final GeneratedColumn<String> comprovativoInscricaoLocal = GeneratedColumn<String>('comprovativo_inscricao_local', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _statusMeta = const VerificationMeta('status');
@override
late final GeneratedColumnWithTypeConverter<AlunoStatus, int> status = GeneratedColumn<int>('status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<AlunoStatus>($AlunosTable.$converterstatus);
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, numeroAluno, nomeCompleto, dataNascimento, sexo, morada, escolaQueFrequenta, anoEscolaridade, possuiCondicaoMedica, descricaoCondicaoMedica, nomeEncarregado, telefonePrincipal, telefoneAlternativo, email, comoConheceuInstituicao, dataInscricao, observacoes, valorPagamentoInscricao, isentoPagamento, comprovativoInscricaoUrl, comprovativoInscricaoLocal, status];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'alunos';
@override
VerificationContext validateIntegrity(Insertable<AlunoData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('numero_aluno')) {
context.handle(_numeroAlunoMeta, numeroAluno.isAcceptableOrUnknown(data['numero_aluno']!, _numeroAlunoMeta));} else if (isInserting) {
context.missing(_numeroAlunoMeta);
}
if (data.containsKey('nome_completo')) {
context.handle(_nomeCompletoMeta, nomeCompleto.isAcceptableOrUnknown(data['nome_completo']!, _nomeCompletoMeta));} else if (isInserting) {
context.missing(_nomeCompletoMeta);
}
if (data.containsKey('data_nascimento')) {
context.handle(_dataNascimentoMeta, dataNascimento.isAcceptableOrUnknown(data['data_nascimento']!, _dataNascimentoMeta));} else if (isInserting) {
context.missing(_dataNascimentoMeta);
}
if (data.containsKey('sexo')) {
context.handle(_sexoMeta, sexo.isAcceptableOrUnknown(data['sexo']!, _sexoMeta));} else if (isInserting) {
context.missing(_sexoMeta);
}
if (data.containsKey('morada')) {
context.handle(_moradaMeta, morada.isAcceptableOrUnknown(data['morada']!, _moradaMeta));} else if (isInserting) {
context.missing(_moradaMeta);
}
if (data.containsKey('escola_que_frequenta')) {
context.handle(_escolaQueFrequentaMeta, escolaQueFrequenta.isAcceptableOrUnknown(data['escola_que_frequenta']!, _escolaQueFrequentaMeta));} else if (isInserting) {
context.missing(_escolaQueFrequentaMeta);
}
if (data.containsKey('ano_escolaridade')) {
context.handle(_anoEscolaridadeMeta, anoEscolaridade.isAcceptableOrUnknown(data['ano_escolaridade']!, _anoEscolaridadeMeta));} else if (isInserting) {
context.missing(_anoEscolaridadeMeta);
}
if (data.containsKey('possui_condicao_medica')) {
context.handle(_possuiCondicaoMedicaMeta, possuiCondicaoMedica.isAcceptableOrUnknown(data['possui_condicao_medica']!, _possuiCondicaoMedicaMeta));} else if (isInserting) {
context.missing(_possuiCondicaoMedicaMeta);
}
if (data.containsKey('descricao_condicao_medica')) {
context.handle(_descricaoCondicaoMedicaMeta, descricaoCondicaoMedica.isAcceptableOrUnknown(data['descricao_condicao_medica']!, _descricaoCondicaoMedicaMeta));}if (data.containsKey('nome_encarregado')) {
context.handle(_nomeEncarregadoMeta, nomeEncarregado.isAcceptableOrUnknown(data['nome_encarregado']!, _nomeEncarregadoMeta));} else if (isInserting) {
context.missing(_nomeEncarregadoMeta);
}
if (data.containsKey('telefone_principal')) {
context.handle(_telefonePrincipalMeta, telefonePrincipal.isAcceptableOrUnknown(data['telefone_principal']!, _telefonePrincipalMeta));} else if (isInserting) {
context.missing(_telefonePrincipalMeta);
}
if (data.containsKey('telefone_alternativo')) {
context.handle(_telefoneAlternativoMeta, telefoneAlternativo.isAcceptableOrUnknown(data['telefone_alternativo']!, _telefoneAlternativoMeta));}if (data.containsKey('email')) {
context.handle(_emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));}if (data.containsKey('como_conheceu_instituicao')) {
context.handle(_comoConheceuInstituicaoMeta, comoConheceuInstituicao.isAcceptableOrUnknown(data['como_conheceu_instituicao']!, _comoConheceuInstituicaoMeta));}if (data.containsKey('data_inscricao')) {
context.handle(_dataInscricaoMeta, dataInscricao.isAcceptableOrUnknown(data['data_inscricao']!, _dataInscricaoMeta));} else if (isInserting) {
context.missing(_dataInscricaoMeta);
}
if (data.containsKey('observacoes')) {
context.handle(_observacoesMeta, observacoes.isAcceptableOrUnknown(data['observacoes']!, _observacoesMeta));}if (data.containsKey('valor_pagamento_inscricao')) {
context.handle(_valorPagamentoInscricaoMeta, valorPagamentoInscricao.isAcceptableOrUnknown(data['valor_pagamento_inscricao']!, _valorPagamentoInscricaoMeta));} else if (isInserting) {
context.missing(_valorPagamentoInscricaoMeta);
}
if (data.containsKey('isento_pagamento')) {
context.handle(_isentoPagamentoMeta, isentoPagamento.isAcceptableOrUnknown(data['isento_pagamento']!, _isentoPagamentoMeta));} else if (isInserting) {
context.missing(_isentoPagamentoMeta);
}
if (data.containsKey('comprovativo_inscricao_url')) {
context.handle(_comprovativoInscricaoUrlMeta, comprovativoInscricaoUrl.isAcceptableOrUnknown(data['comprovativo_inscricao_url']!, _comprovativoInscricaoUrlMeta));}if (data.containsKey('comprovativo_inscricao_local')) {
context.handle(_comprovativoInscricaoLocalMeta, comprovativoInscricaoLocal.isAcceptableOrUnknown(data['comprovativo_inscricao_local']!, _comprovativoInscricaoLocalMeta));}context.handle(_statusMeta, const VerificationResult.success());return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override AlunoData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return AlunoData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $AlunosTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, numeroAluno: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}numero_aluno'])!, nomeCompleto: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nome_completo'])!, dataNascimento: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_nascimento'])!, sexo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sexo'])!, morada: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}morada'])!, escolaQueFrequenta: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}escola_que_frequenta'])!, anoEscolaridade: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}ano_escolaridade'])!, possuiCondicaoMedica: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}possui_condicao_medica'])!, descricaoCondicaoMedica: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}descricao_condicao_medica']), nomeEncarregado: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nome_encarregado'])!, telefonePrincipal: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}telefone_principal'])!, telefoneAlternativo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}telefone_alternativo']), email: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}email']), comoConheceuInstituicao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}como_conheceu_instituicao']), dataInscricao: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_inscricao'])!, observacoes: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}observacoes']), valorPagamentoInscricao: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}valor_pagamento_inscricao'])!, isentoPagamento: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}isento_pagamento'])!, comprovativoInscricaoUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}comprovativo_inscricao_url']), comprovativoInscricaoLocal: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}comprovativo_inscricao_local']), status: $AlunosTable.$converterstatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}status'])!), );
}
@override
$AlunosTable createAlias(String alias) {
return $AlunosTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);static JsonTypeConverter2<AlunoStatus,int,int> $converterstatus = const EnumIndexConverter<AlunoStatus>(AlunoStatus.values);}class AlunoData extends DataClass implements Insertable<AlunoData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String numeroAluno;
final String nomeCompleto;
final DateTime dataNascimento;
final String sexo;
final String morada;
final String escolaQueFrequenta;
final String anoEscolaridade;
final bool possuiCondicaoMedica;
final String? descricaoCondicaoMedica;
final String nomeEncarregado;
final String telefonePrincipal;
final String? telefoneAlternativo;
final String? email;
final String? comoConheceuInstituicao;
final DateTime dataInscricao;
final String? observacoes;
final double valorPagamentoInscricao;
final bool isentoPagamento;
final String? comprovativoInscricaoUrl;
final String? comprovativoInscricaoLocal;
final AlunoStatus status;
const AlunoData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.numeroAluno, required this.nomeCompleto, required this.dataNascimento, required this.sexo, required this.morada, required this.escolaQueFrequenta, required this.anoEscolaridade, required this.possuiCondicaoMedica, this.descricaoCondicaoMedica, required this.nomeEncarregado, required this.telefonePrincipal, this.telefoneAlternativo, this.email, this.comoConheceuInstituicao, required this.dataInscricao, this.observacoes, required this.valorPagamentoInscricao, required this.isentoPagamento, this.comprovativoInscricaoUrl, this.comprovativoInscricaoLocal, required this.status});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($AlunosTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['numero_aluno'] = Variable<String>(numeroAluno);
map['nome_completo'] = Variable<String>(nomeCompleto);
map['data_nascimento'] = Variable<DateTime>(dataNascimento);
map['sexo'] = Variable<String>(sexo);
map['morada'] = Variable<String>(morada);
map['escola_que_frequenta'] = Variable<String>(escolaQueFrequenta);
map['ano_escolaridade'] = Variable<String>(anoEscolaridade);
map['possui_condicao_medica'] = Variable<bool>(possuiCondicaoMedica);
if (!nullToAbsent || descricaoCondicaoMedica != null){map['descricao_condicao_medica'] = Variable<String>(descricaoCondicaoMedica);
}map['nome_encarregado'] = Variable<String>(nomeEncarregado);
map['telefone_principal'] = Variable<String>(telefonePrincipal);
if (!nullToAbsent || telefoneAlternativo != null){map['telefone_alternativo'] = Variable<String>(telefoneAlternativo);
}if (!nullToAbsent || email != null){map['email'] = Variable<String>(email);
}if (!nullToAbsent || comoConheceuInstituicao != null){map['como_conheceu_instituicao'] = Variable<String>(comoConheceuInstituicao);
}map['data_inscricao'] = Variable<DateTime>(dataInscricao);
if (!nullToAbsent || observacoes != null){map['observacoes'] = Variable<String>(observacoes);
}map['valor_pagamento_inscricao'] = Variable<double>(valorPagamentoInscricao);
map['isento_pagamento'] = Variable<bool>(isentoPagamento);
if (!nullToAbsent || comprovativoInscricaoUrl != null){map['comprovativo_inscricao_url'] = Variable<String>(comprovativoInscricaoUrl);
}if (!nullToAbsent || comprovativoInscricaoLocal != null){map['comprovativo_inscricao_local'] = Variable<String>(comprovativoInscricaoLocal);
}{map['status'] = Variable<int>($AlunosTable.$converterstatus.toSql(status));
}return map; 
}
AlunosCompanion toCompanion(bool nullToAbsent) {
return AlunosCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),numeroAluno: Value(numeroAluno),nomeCompleto: Value(nomeCompleto),dataNascimento: Value(dataNascimento),sexo: Value(sexo),morada: Value(morada),escolaQueFrequenta: Value(escolaQueFrequenta),anoEscolaridade: Value(anoEscolaridade),possuiCondicaoMedica: Value(possuiCondicaoMedica),descricaoCondicaoMedica: descricaoCondicaoMedica == null && nullToAbsent ? const Value.absent() : Value(descricaoCondicaoMedica),nomeEncarregado: Value(nomeEncarregado),telefonePrincipal: Value(telefonePrincipal),telefoneAlternativo: telefoneAlternativo == null && nullToAbsent ? const Value.absent() : Value(telefoneAlternativo),email: email == null && nullToAbsent ? const Value.absent() : Value(email),comoConheceuInstituicao: comoConheceuInstituicao == null && nullToAbsent ? const Value.absent() : Value(comoConheceuInstituicao),dataInscricao: Value(dataInscricao),observacoes: observacoes == null && nullToAbsent ? const Value.absent() : Value(observacoes),valorPagamentoInscricao: Value(valorPagamentoInscricao),isentoPagamento: Value(isentoPagamento),comprovativoInscricaoUrl: comprovativoInscricaoUrl == null && nullToAbsent ? const Value.absent() : Value(comprovativoInscricaoUrl),comprovativoInscricaoLocal: comprovativoInscricaoLocal == null && nullToAbsent ? const Value.absent() : Value(comprovativoInscricaoLocal),status: Value(status),);
}
factory AlunoData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return AlunoData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $AlunosTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),numeroAluno: serializer.fromJson<String>(json['numeroAluno']),nomeCompleto: serializer.fromJson<String>(json['nomeCompleto']),dataNascimento: serializer.fromJson<DateTime>(json['dataNascimento']),sexo: serializer.fromJson<String>(json['sexo']),morada: serializer.fromJson<String>(json['morada']),escolaQueFrequenta: serializer.fromJson<String>(json['escolaQueFrequenta']),anoEscolaridade: serializer.fromJson<String>(json['anoEscolaridade']),possuiCondicaoMedica: serializer.fromJson<bool>(json['possuiCondicaoMedica']),descricaoCondicaoMedica: serializer.fromJson<String?>(json['descricaoCondicaoMedica']),nomeEncarregado: serializer.fromJson<String>(json['nomeEncarregado']),telefonePrincipal: serializer.fromJson<String>(json['telefonePrincipal']),telefoneAlternativo: serializer.fromJson<String?>(json['telefoneAlternativo']),email: serializer.fromJson<String?>(json['email']),comoConheceuInstituicao: serializer.fromJson<String?>(json['comoConheceuInstituicao']),dataInscricao: serializer.fromJson<DateTime>(json['dataInscricao']),observacoes: serializer.fromJson<String?>(json['observacoes']),valorPagamentoInscricao: serializer.fromJson<double>(json['valorPagamentoInscricao']),isentoPagamento: serializer.fromJson<bool>(json['isentoPagamento']),comprovativoInscricaoUrl: serializer.fromJson<String?>(json['comprovativoInscricaoUrl']),comprovativoInscricaoLocal: serializer.fromJson<String?>(json['comprovativoInscricaoLocal']),status: $AlunosTable.$converterstatus.fromJson(serializer.fromJson<int>(json['status'])),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($AlunosTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'numeroAluno': serializer.toJson<String>(numeroAluno),'nomeCompleto': serializer.toJson<String>(nomeCompleto),'dataNascimento': serializer.toJson<DateTime>(dataNascimento),'sexo': serializer.toJson<String>(sexo),'morada': serializer.toJson<String>(morada),'escolaQueFrequenta': serializer.toJson<String>(escolaQueFrequenta),'anoEscolaridade': serializer.toJson<String>(anoEscolaridade),'possuiCondicaoMedica': serializer.toJson<bool>(possuiCondicaoMedica),'descricaoCondicaoMedica': serializer.toJson<String?>(descricaoCondicaoMedica),'nomeEncarregado': serializer.toJson<String>(nomeEncarregado),'telefonePrincipal': serializer.toJson<String>(telefonePrincipal),'telefoneAlternativo': serializer.toJson<String?>(telefoneAlternativo),'email': serializer.toJson<String?>(email),'comoConheceuInstituicao': serializer.toJson<String?>(comoConheceuInstituicao),'dataInscricao': serializer.toJson<DateTime>(dataInscricao),'observacoes': serializer.toJson<String?>(observacoes),'valorPagamentoInscricao': serializer.toJson<double>(valorPagamentoInscricao),'isentoPagamento': serializer.toJson<bool>(isentoPagamento),'comprovativoInscricaoUrl': serializer.toJson<String?>(comprovativoInscricaoUrl),'comprovativoInscricaoLocal': serializer.toJson<String?>(comprovativoInscricaoLocal),'status': serializer.toJson<int>($AlunosTable.$converterstatus.toJson(status)),};}AlunoData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? numeroAluno,String? nomeCompleto,DateTime? dataNascimento,String? sexo,String? morada,String? escolaQueFrequenta,String? anoEscolaridade,bool? possuiCondicaoMedica,Value<String?> descricaoCondicaoMedica = const Value.absent(),String? nomeEncarregado,String? telefonePrincipal,Value<String?> telefoneAlternativo = const Value.absent(),Value<String?> email = const Value.absent(),Value<String?> comoConheceuInstituicao = const Value.absent(),DateTime? dataInscricao,Value<String?> observacoes = const Value.absent(),double? valorPagamentoInscricao,bool? isentoPagamento,Value<String?> comprovativoInscricaoUrl = const Value.absent(),Value<String?> comprovativoInscricaoLocal = const Value.absent(),AlunoStatus? status}) => AlunoData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,numeroAluno: numeroAluno ?? this.numeroAluno,nomeCompleto: nomeCompleto ?? this.nomeCompleto,dataNascimento: dataNascimento ?? this.dataNascimento,sexo: sexo ?? this.sexo,morada: morada ?? this.morada,escolaQueFrequenta: escolaQueFrequenta ?? this.escolaQueFrequenta,anoEscolaridade: anoEscolaridade ?? this.anoEscolaridade,possuiCondicaoMedica: possuiCondicaoMedica ?? this.possuiCondicaoMedica,descricaoCondicaoMedica: descricaoCondicaoMedica.present ? descricaoCondicaoMedica.value : this.descricaoCondicaoMedica,nomeEncarregado: nomeEncarregado ?? this.nomeEncarregado,telefonePrincipal: telefonePrincipal ?? this.telefonePrincipal,telefoneAlternativo: telefoneAlternativo.present ? telefoneAlternativo.value : this.telefoneAlternativo,email: email.present ? email.value : this.email,comoConheceuInstituicao: comoConheceuInstituicao.present ? comoConheceuInstituicao.value : this.comoConheceuInstituicao,dataInscricao: dataInscricao ?? this.dataInscricao,observacoes: observacoes.present ? observacoes.value : this.observacoes,valorPagamentoInscricao: valorPagamentoInscricao ?? this.valorPagamentoInscricao,isentoPagamento: isentoPagamento ?? this.isentoPagamento,comprovativoInscricaoUrl: comprovativoInscricaoUrl.present ? comprovativoInscricaoUrl.value : this.comprovativoInscricaoUrl,comprovativoInscricaoLocal: comprovativoInscricaoLocal.present ? comprovativoInscricaoLocal.value : this.comprovativoInscricaoLocal,status: status ?? this.status,);AlunoData copyWithCompanion(AlunosCompanion data) {
return AlunoData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,numeroAluno: data.numeroAluno.present ? data.numeroAluno.value : this.numeroAluno,nomeCompleto: data.nomeCompleto.present ? data.nomeCompleto.value : this.nomeCompleto,dataNascimento: data.dataNascimento.present ? data.dataNascimento.value : this.dataNascimento,sexo: data.sexo.present ? data.sexo.value : this.sexo,morada: data.morada.present ? data.morada.value : this.morada,escolaQueFrequenta: data.escolaQueFrequenta.present ? data.escolaQueFrequenta.value : this.escolaQueFrequenta,anoEscolaridade: data.anoEscolaridade.present ? data.anoEscolaridade.value : this.anoEscolaridade,possuiCondicaoMedica: data.possuiCondicaoMedica.present ? data.possuiCondicaoMedica.value : this.possuiCondicaoMedica,descricaoCondicaoMedica: data.descricaoCondicaoMedica.present ? data.descricaoCondicaoMedica.value : this.descricaoCondicaoMedica,nomeEncarregado: data.nomeEncarregado.present ? data.nomeEncarregado.value : this.nomeEncarregado,telefonePrincipal: data.telefonePrincipal.present ? data.telefonePrincipal.value : this.telefonePrincipal,telefoneAlternativo: data.telefoneAlternativo.present ? data.telefoneAlternativo.value : this.telefoneAlternativo,email: data.email.present ? data.email.value : this.email,comoConheceuInstituicao: data.comoConheceuInstituicao.present ? data.comoConheceuInstituicao.value : this.comoConheceuInstituicao,dataInscricao: data.dataInscricao.present ? data.dataInscricao.value : this.dataInscricao,observacoes: data.observacoes.present ? data.observacoes.value : this.observacoes,valorPagamentoInscricao: data.valorPagamentoInscricao.present ? data.valorPagamentoInscricao.value : this.valorPagamentoInscricao,isentoPagamento: data.isentoPagamento.present ? data.isentoPagamento.value : this.isentoPagamento,comprovativoInscricaoUrl: data.comprovativoInscricaoUrl.present ? data.comprovativoInscricaoUrl.value : this.comprovativoInscricaoUrl,comprovativoInscricaoLocal: data.comprovativoInscricaoLocal.present ? data.comprovativoInscricaoLocal.value : this.comprovativoInscricaoLocal,status: data.status.present ? data.status.value : this.status,);
}
@override
String toString() {return (StringBuffer('AlunoData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('numeroAluno: $numeroAluno, ')..write('nomeCompleto: $nomeCompleto, ')..write('dataNascimento: $dataNascimento, ')..write('sexo: $sexo, ')..write('morada: $morada, ')..write('escolaQueFrequenta: $escolaQueFrequenta, ')..write('anoEscolaridade: $anoEscolaridade, ')..write('possuiCondicaoMedica: $possuiCondicaoMedica, ')..write('descricaoCondicaoMedica: $descricaoCondicaoMedica, ')..write('nomeEncarregado: $nomeEncarregado, ')..write('telefonePrincipal: $telefonePrincipal, ')..write('telefoneAlternativo: $telefoneAlternativo, ')..write('email: $email, ')..write('comoConheceuInstituicao: $comoConheceuInstituicao, ')..write('dataInscricao: $dataInscricao, ')..write('observacoes: $observacoes, ')..write('valorPagamentoInscricao: $valorPagamentoInscricao, ')..write('isentoPagamento: $isentoPagamento, ')..write('comprovativoInscricaoUrl: $comprovativoInscricaoUrl, ')..write('comprovativoInscricaoLocal: $comprovativoInscricaoLocal, ')..write('status: $status')..write(')')).toString();}
@override
 int get hashCode => Object.hashAll([id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, numeroAluno, nomeCompleto, dataNascimento, sexo, morada, escolaQueFrequenta, anoEscolaridade, possuiCondicaoMedica, descricaoCondicaoMedica, nomeEncarregado, telefonePrincipal, telefoneAlternativo, email, comoConheceuInstituicao, dataInscricao, observacoes, valorPagamentoInscricao, isentoPagamento, comprovativoInscricaoUrl, comprovativoInscricaoLocal, status]);@override
bool operator ==(Object other) => identical(this, other) || (other is AlunoData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.numeroAluno == this.numeroAluno && other.nomeCompleto == this.nomeCompleto && other.dataNascimento == this.dataNascimento && other.sexo == this.sexo && other.morada == this.morada && other.escolaQueFrequenta == this.escolaQueFrequenta && other.anoEscolaridade == this.anoEscolaridade && other.possuiCondicaoMedica == this.possuiCondicaoMedica && other.descricaoCondicaoMedica == this.descricaoCondicaoMedica && other.nomeEncarregado == this.nomeEncarregado && other.telefonePrincipal == this.telefonePrincipal && other.telefoneAlternativo == this.telefoneAlternativo && other.email == this.email && other.comoConheceuInstituicao == this.comoConheceuInstituicao && other.dataInscricao == this.dataInscricao && other.observacoes == this.observacoes && other.valorPagamentoInscricao == this.valorPagamentoInscricao && other.isentoPagamento == this.isentoPagamento && other.comprovativoInscricaoUrl == this.comprovativoInscricaoUrl && other.comprovativoInscricaoLocal == this.comprovativoInscricaoLocal && other.status == this.status);
}class AlunosCompanion extends UpdateCompanion<AlunoData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> numeroAluno;
final Value<String> nomeCompleto;
final Value<DateTime> dataNascimento;
final Value<String> sexo;
final Value<String> morada;
final Value<String> escolaQueFrequenta;
final Value<String> anoEscolaridade;
final Value<bool> possuiCondicaoMedica;
final Value<String?> descricaoCondicaoMedica;
final Value<String> nomeEncarregado;
final Value<String> telefonePrincipal;
final Value<String?> telefoneAlternativo;
final Value<String?> email;
final Value<String?> comoConheceuInstituicao;
final Value<DateTime> dataInscricao;
final Value<String?> observacoes;
final Value<double> valorPagamentoInscricao;
final Value<bool> isentoPagamento;
final Value<String?> comprovativoInscricaoUrl;
final Value<String?> comprovativoInscricaoLocal;
final Value<AlunoStatus> status;
const AlunosCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.numeroAluno = const Value.absent(),this.nomeCompleto = const Value.absent(),this.dataNascimento = const Value.absent(),this.sexo = const Value.absent(),this.morada = const Value.absent(),this.escolaQueFrequenta = const Value.absent(),this.anoEscolaridade = const Value.absent(),this.possuiCondicaoMedica = const Value.absent(),this.descricaoCondicaoMedica = const Value.absent(),this.nomeEncarregado = const Value.absent(),this.telefonePrincipal = const Value.absent(),this.telefoneAlternativo = const Value.absent(),this.email = const Value.absent(),this.comoConheceuInstituicao = const Value.absent(),this.dataInscricao = const Value.absent(),this.observacoes = const Value.absent(),this.valorPagamentoInscricao = const Value.absent(),this.isentoPagamento = const Value.absent(),this.comprovativoInscricaoUrl = const Value.absent(),this.comprovativoInscricaoLocal = const Value.absent(),this.status = const Value.absent(),});
AlunosCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String numeroAluno,required String nomeCompleto,required DateTime dataNascimento,required String sexo,required String morada,required String escolaQueFrequenta,required String anoEscolaridade,required bool possuiCondicaoMedica,this.descricaoCondicaoMedica = const Value.absent(),required String nomeEncarregado,required String telefonePrincipal,this.telefoneAlternativo = const Value.absent(),this.email = const Value.absent(),this.comoConheceuInstituicao = const Value.absent(),required DateTime dataInscricao,this.observacoes = const Value.absent(),required double valorPagamentoInscricao,required bool isentoPagamento,this.comprovativoInscricaoUrl = const Value.absent(),this.comprovativoInscricaoLocal = const Value.absent(),required AlunoStatus status,}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), numeroAluno = Value(numeroAluno), nomeCompleto = Value(nomeCompleto), dataNascimento = Value(dataNascimento), sexo = Value(sexo), morada = Value(morada), escolaQueFrequenta = Value(escolaQueFrequenta), anoEscolaridade = Value(anoEscolaridade), possuiCondicaoMedica = Value(possuiCondicaoMedica), nomeEncarregado = Value(nomeEncarregado), telefonePrincipal = Value(telefonePrincipal), dataInscricao = Value(dataInscricao), valorPagamentoInscricao = Value(valorPagamentoInscricao), isentoPagamento = Value(isentoPagamento), status = Value(status);
static Insertable<AlunoData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? numeroAluno, 
Expression<String>? nomeCompleto, 
Expression<DateTime>? dataNascimento, 
Expression<String>? sexo, 
Expression<String>? morada, 
Expression<String>? escolaQueFrequenta, 
Expression<String>? anoEscolaridade, 
Expression<bool>? possuiCondicaoMedica, 
Expression<String>? descricaoCondicaoMedica, 
Expression<String>? nomeEncarregado, 
Expression<String>? telefonePrincipal, 
Expression<String>? telefoneAlternativo, 
Expression<String>? email, 
Expression<String>? comoConheceuInstituicao, 
Expression<DateTime>? dataInscricao, 
Expression<String>? observacoes, 
Expression<double>? valorPagamentoInscricao, 
Expression<bool>? isentoPagamento, 
Expression<String>? comprovativoInscricaoUrl, 
Expression<String>? comprovativoInscricaoLocal, 
Expression<int>? status, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (numeroAluno != null)'numero_aluno': numeroAluno,if (nomeCompleto != null)'nome_completo': nomeCompleto,if (dataNascimento != null)'data_nascimento': dataNascimento,if (sexo != null)'sexo': sexo,if (morada != null)'morada': morada,if (escolaQueFrequenta != null)'escola_que_frequenta': escolaQueFrequenta,if (anoEscolaridade != null)'ano_escolaridade': anoEscolaridade,if (possuiCondicaoMedica != null)'possui_condicao_medica': possuiCondicaoMedica,if (descricaoCondicaoMedica != null)'descricao_condicao_medica': descricaoCondicaoMedica,if (nomeEncarregado != null)'nome_encarregado': nomeEncarregado,if (telefonePrincipal != null)'telefone_principal': telefonePrincipal,if (telefoneAlternativo != null)'telefone_alternativo': telefoneAlternativo,if (email != null)'email': email,if (comoConheceuInstituicao != null)'como_conheceu_instituicao': comoConheceuInstituicao,if (dataInscricao != null)'data_inscricao': dataInscricao,if (observacoes != null)'observacoes': observacoes,if (valorPagamentoInscricao != null)'valor_pagamento_inscricao': valorPagamentoInscricao,if (isentoPagamento != null)'isento_pagamento': isentoPagamento,if (comprovativoInscricaoUrl != null)'comprovativo_inscricao_url': comprovativoInscricaoUrl,if (comprovativoInscricaoLocal != null)'comprovativo_inscricao_local': comprovativoInscricaoLocal,if (status != null)'status': status,});
}AlunosCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? numeroAluno, Value<String>? nomeCompleto, Value<DateTime>? dataNascimento, Value<String>? sexo, Value<String>? morada, Value<String>? escolaQueFrequenta, Value<String>? anoEscolaridade, Value<bool>? possuiCondicaoMedica, Value<String?>? descricaoCondicaoMedica, Value<String>? nomeEncarregado, Value<String>? telefonePrincipal, Value<String?>? telefoneAlternativo, Value<String?>? email, Value<String?>? comoConheceuInstituicao, Value<DateTime>? dataInscricao, Value<String?>? observacoes, Value<double>? valorPagamentoInscricao, Value<bool>? isentoPagamento, Value<String?>? comprovativoInscricaoUrl, Value<String?>? comprovativoInscricaoLocal, Value<AlunoStatus>? status}) {
return AlunosCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,numeroAluno: numeroAluno ?? this.numeroAluno,nomeCompleto: nomeCompleto ?? this.nomeCompleto,dataNascimento: dataNascimento ?? this.dataNascimento,sexo: sexo ?? this.sexo,morada: morada ?? this.morada,escolaQueFrequenta: escolaQueFrequenta ?? this.escolaQueFrequenta,anoEscolaridade: anoEscolaridade ?? this.anoEscolaridade,possuiCondicaoMedica: possuiCondicaoMedica ?? this.possuiCondicaoMedica,descricaoCondicaoMedica: descricaoCondicaoMedica ?? this.descricaoCondicaoMedica,nomeEncarregado: nomeEncarregado ?? this.nomeEncarregado,telefonePrincipal: telefonePrincipal ?? this.telefonePrincipal,telefoneAlternativo: telefoneAlternativo ?? this.telefoneAlternativo,email: email ?? this.email,comoConheceuInstituicao: comoConheceuInstituicao ?? this.comoConheceuInstituicao,dataInscricao: dataInscricao ?? this.dataInscricao,observacoes: observacoes ?? this.observacoes,valorPagamentoInscricao: valorPagamentoInscricao ?? this.valorPagamentoInscricao,isentoPagamento: isentoPagamento ?? this.isentoPagamento,comprovativoInscricaoUrl: comprovativoInscricaoUrl ?? this.comprovativoInscricaoUrl,comprovativoInscricaoLocal: comprovativoInscricaoLocal ?? this.comprovativoInscricaoLocal,status: status ?? this.status,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($AlunosTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (numeroAluno.present) {
map['numero_aluno'] = Variable<String>(numeroAluno.value);}
if (nomeCompleto.present) {
map['nome_completo'] = Variable<String>(nomeCompleto.value);}
if (dataNascimento.present) {
map['data_nascimento'] = Variable<DateTime>(dataNascimento.value);}
if (sexo.present) {
map['sexo'] = Variable<String>(sexo.value);}
if (morada.present) {
map['morada'] = Variable<String>(morada.value);}
if (escolaQueFrequenta.present) {
map['escola_que_frequenta'] = Variable<String>(escolaQueFrequenta.value);}
if (anoEscolaridade.present) {
map['ano_escolaridade'] = Variable<String>(anoEscolaridade.value);}
if (possuiCondicaoMedica.present) {
map['possui_condicao_medica'] = Variable<bool>(possuiCondicaoMedica.value);}
if (descricaoCondicaoMedica.present) {
map['descricao_condicao_medica'] = Variable<String>(descricaoCondicaoMedica.value);}
if (nomeEncarregado.present) {
map['nome_encarregado'] = Variable<String>(nomeEncarregado.value);}
if (telefonePrincipal.present) {
map['telefone_principal'] = Variable<String>(telefonePrincipal.value);}
if (telefoneAlternativo.present) {
map['telefone_alternativo'] = Variable<String>(telefoneAlternativo.value);}
if (email.present) {
map['email'] = Variable<String>(email.value);}
if (comoConheceuInstituicao.present) {
map['como_conheceu_instituicao'] = Variable<String>(comoConheceuInstituicao.value);}
if (dataInscricao.present) {
map['data_inscricao'] = Variable<DateTime>(dataInscricao.value);}
if (observacoes.present) {
map['observacoes'] = Variable<String>(observacoes.value);}
if (valorPagamentoInscricao.present) {
map['valor_pagamento_inscricao'] = Variable<double>(valorPagamentoInscricao.value);}
if (isentoPagamento.present) {
map['isento_pagamento'] = Variable<bool>(isentoPagamento.value);}
if (comprovativoInscricaoUrl.present) {
map['comprovativo_inscricao_url'] = Variable<String>(comprovativoInscricaoUrl.value);}
if (comprovativoInscricaoLocal.present) {
map['comprovativo_inscricao_local'] = Variable<String>(comprovativoInscricaoLocal.value);}
if (status.present) {
map['status'] = Variable<int>($AlunosTable.$converterstatus.toSql(status.value));}
return map; 
}
@override
String toString() {return (StringBuffer('AlunosCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('numeroAluno: $numeroAluno, ')..write('nomeCompleto: $nomeCompleto, ')..write('dataNascimento: $dataNascimento, ')..write('sexo: $sexo, ')..write('morada: $morada, ')..write('escolaQueFrequenta: $escolaQueFrequenta, ')..write('anoEscolaridade: $anoEscolaridade, ')..write('possuiCondicaoMedica: $possuiCondicaoMedica, ')..write('descricaoCondicaoMedica: $descricaoCondicaoMedica, ')..write('nomeEncarregado: $nomeEncarregado, ')..write('telefonePrincipal: $telefonePrincipal, ')..write('telefoneAlternativo: $telefoneAlternativo, ')..write('email: $email, ')..write('comoConheceuInstituicao: $comoConheceuInstituicao, ')..write('dataInscricao: $dataInscricao, ')..write('observacoes: $observacoes, ')..write('valorPagamentoInscricao: $valorPagamentoInscricao, ')..write('isentoPagamento: $isentoPagamento, ')..write('comprovativoInscricaoUrl: $comprovativoInscricaoUrl, ')..write('comprovativoInscricaoLocal: $comprovativoInscricaoLocal, ')..write('status: $status')..write(')')).toString();}
}
class $CustosMensaisTable extends CustosMensais with TableInfo<$CustosMensaisTable, CustoMensalData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$CustosMensaisTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($CustosMensaisTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _descricaoMeta = const VerificationMeta('descricao');
@override
late final GeneratedColumn<String> descricao = GeneratedColumn<String>('descricao', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _categoriaMeta = const VerificationMeta('categoria');
@override
late final GeneratedColumn<String> categoria = GeneratedColumn<String>('categoria', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _valorMeta = const VerificationMeta('valor');
@override
late final GeneratedColumn<double> valor = GeneratedColumn<double>('valor', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
static const VerificationMeta _dataMeta = const VerificationMeta('data');
@override
late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>('data', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
@override
late final GeneratedColumn<String> tipo = GeneratedColumn<String>('tipo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _mesReferenciaMeta = const VerificationMeta('mesReferencia');
@override
late final GeneratedColumn<int> mesReferencia = GeneratedColumn<int>('mes_referencia', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _anoReferenciaMeta = const VerificationMeta('anoReferencia');
@override
late final GeneratedColumn<int> anoReferencia = GeneratedColumn<int>('ano_referencia', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
@override
late final GeneratedColumn<String> estado = GeneratedColumn<String>('estado', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _observacaoMeta = const VerificationMeta('observacao');
@override
late final GeneratedColumn<String> observacao = GeneratedColumn<String>('observacao', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _comprovativoUrlMeta = const VerificationMeta('comprovativoUrl');
@override
late final GeneratedColumn<String> comprovativoUrl = GeneratedColumn<String>('comprovativo_url', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _comprovativoLocalMeta = const VerificationMeta('comprovativoLocal');
@override
late final GeneratedColumn<String> comprovativoLocal = GeneratedColumn<String>('comprovativo_local', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _responsavelIdMeta = const VerificationMeta('responsavelId');
@override
late final GeneratedColumn<String> responsavelId = GeneratedColumn<String>('responsavel_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, descricao, categoria, valor, data, tipo, mesReferencia, anoReferencia, estado, observacao, comprovativoUrl, comprovativoLocal, responsavelId];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'custos_mensais';
@override
VerificationContext validateIntegrity(Insertable<CustoMensalData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('descricao')) {
context.handle(_descricaoMeta, descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));} else if (isInserting) {
context.missing(_descricaoMeta);
}
if (data.containsKey('categoria')) {
context.handle(_categoriaMeta, categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta));} else if (isInserting) {
context.missing(_categoriaMeta);
}
if (data.containsKey('valor')) {
context.handle(_valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));} else if (isInserting) {
context.missing(_valorMeta);
}
if (data.containsKey('data')) {
context.handle(_dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));} else if (isInserting) {
context.missing(_dataMeta);
}
if (data.containsKey('tipo')) {
context.handle(_tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));} else if (isInserting) {
context.missing(_tipoMeta);
}
if (data.containsKey('mes_referencia')) {
context.handle(_mesReferenciaMeta, mesReferencia.isAcceptableOrUnknown(data['mes_referencia']!, _mesReferenciaMeta));} else if (isInserting) {
context.missing(_mesReferenciaMeta);
}
if (data.containsKey('ano_referencia')) {
context.handle(_anoReferenciaMeta, anoReferencia.isAcceptableOrUnknown(data['ano_referencia']!, _anoReferenciaMeta));} else if (isInserting) {
context.missing(_anoReferenciaMeta);
}
if (data.containsKey('estado')) {
context.handle(_estadoMeta, estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));} else if (isInserting) {
context.missing(_estadoMeta);
}
if (data.containsKey('observacao')) {
context.handle(_observacaoMeta, observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta));}if (data.containsKey('comprovativo_url')) {
context.handle(_comprovativoUrlMeta, comprovativoUrl.isAcceptableOrUnknown(data['comprovativo_url']!, _comprovativoUrlMeta));}if (data.containsKey('comprovativo_local')) {
context.handle(_comprovativoLocalMeta, comprovativoLocal.isAcceptableOrUnknown(data['comprovativo_local']!, _comprovativoLocalMeta));}if (data.containsKey('responsavel_id')) {
context.handle(_responsavelIdMeta, responsavelId.isAcceptableOrUnknown(data['responsavel_id']!, _responsavelIdMeta));} else if (isInserting) {
context.missing(_responsavelIdMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override CustoMensalData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return CustoMensalData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $CustosMensaisTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, descricao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}descricao'])!, categoria: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}categoria'])!, valor: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}valor'])!, data: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!, tipo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tipo'])!, mesReferencia: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}mes_referencia'])!, anoReferencia: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}ano_referencia'])!, estado: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}estado'])!, observacao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}observacao']), comprovativoUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}comprovativo_url']), comprovativoLocal: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}comprovativo_local']), responsavelId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}responsavel_id'])!, );
}
@override
$CustosMensaisTable createAlias(String alias) {
return $CustosMensaisTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class CustoMensalData extends DataClass implements Insertable<CustoMensalData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String descricao;
final String categoria;
final double valor;
final DateTime data;
final String tipo;
final int mesReferencia;
final int anoReferencia;
final String estado;
final String? observacao;
final String? comprovativoUrl;
final String? comprovativoLocal;
final String responsavelId;
const CustoMensalData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.descricao, required this.categoria, required this.valor, required this.data, required this.tipo, required this.mesReferencia, required this.anoReferencia, required this.estado, this.observacao, this.comprovativoUrl, this.comprovativoLocal, required this.responsavelId});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($CustosMensaisTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['descricao'] = Variable<String>(descricao);
map['categoria'] = Variable<String>(categoria);
map['valor'] = Variable<double>(valor);
map['data'] = Variable<DateTime>(data);
map['tipo'] = Variable<String>(tipo);
map['mes_referencia'] = Variable<int>(mesReferencia);
map['ano_referencia'] = Variable<int>(anoReferencia);
map['estado'] = Variable<String>(estado);
if (!nullToAbsent || observacao != null){map['observacao'] = Variable<String>(observacao);
}if (!nullToAbsent || comprovativoUrl != null){map['comprovativo_url'] = Variable<String>(comprovativoUrl);
}if (!nullToAbsent || comprovativoLocal != null){map['comprovativo_local'] = Variable<String>(comprovativoLocal);
}map['responsavel_id'] = Variable<String>(responsavelId);
return map; 
}
CustosMensaisCompanion toCompanion(bool nullToAbsent) {
return CustosMensaisCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),descricao: Value(descricao),categoria: Value(categoria),valor: Value(valor),data: Value(data),tipo: Value(tipo),mesReferencia: Value(mesReferencia),anoReferencia: Value(anoReferencia),estado: Value(estado),observacao: observacao == null && nullToAbsent ? const Value.absent() : Value(observacao),comprovativoUrl: comprovativoUrl == null && nullToAbsent ? const Value.absent() : Value(comprovativoUrl),comprovativoLocal: comprovativoLocal == null && nullToAbsent ? const Value.absent() : Value(comprovativoLocal),responsavelId: Value(responsavelId),);
}
factory CustoMensalData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return CustoMensalData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $CustosMensaisTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),descricao: serializer.fromJson<String>(json['descricao']),categoria: serializer.fromJson<String>(json['categoria']),valor: serializer.fromJson<double>(json['valor']),data: serializer.fromJson<DateTime>(json['data']),tipo: serializer.fromJson<String>(json['tipo']),mesReferencia: serializer.fromJson<int>(json['mesReferencia']),anoReferencia: serializer.fromJson<int>(json['anoReferencia']),estado: serializer.fromJson<String>(json['estado']),observacao: serializer.fromJson<String?>(json['observacao']),comprovativoUrl: serializer.fromJson<String?>(json['comprovativoUrl']),comprovativoLocal: serializer.fromJson<String?>(json['comprovativoLocal']),responsavelId: serializer.fromJson<String>(json['responsavelId']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($CustosMensaisTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'descricao': serializer.toJson<String>(descricao),'categoria': serializer.toJson<String>(categoria),'valor': serializer.toJson<double>(valor),'data': serializer.toJson<DateTime>(data),'tipo': serializer.toJson<String>(tipo),'mesReferencia': serializer.toJson<int>(mesReferencia),'anoReferencia': serializer.toJson<int>(anoReferencia),'estado': serializer.toJson<String>(estado),'observacao': serializer.toJson<String?>(observacao),'comprovativoUrl': serializer.toJson<String?>(comprovativoUrl),'comprovativoLocal': serializer.toJson<String?>(comprovativoLocal),'responsavelId': serializer.toJson<String>(responsavelId),};}CustoMensalData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? descricao,String? categoria,double? valor,DateTime? data,String? tipo,int? mesReferencia,int? anoReferencia,String? estado,Value<String?> observacao = const Value.absent(),Value<String?> comprovativoUrl = const Value.absent(),Value<String?> comprovativoLocal = const Value.absent(),String? responsavelId}) => CustoMensalData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,descricao: descricao ?? this.descricao,categoria: categoria ?? this.categoria,valor: valor ?? this.valor,data: data ?? this.data,tipo: tipo ?? this.tipo,mesReferencia: mesReferencia ?? this.mesReferencia,anoReferencia: anoReferencia ?? this.anoReferencia,estado: estado ?? this.estado,observacao: observacao.present ? observacao.value : this.observacao,comprovativoUrl: comprovativoUrl.present ? comprovativoUrl.value : this.comprovativoUrl,comprovativoLocal: comprovativoLocal.present ? comprovativoLocal.value : this.comprovativoLocal,responsavelId: responsavelId ?? this.responsavelId,);CustoMensalData copyWithCompanion(CustosMensaisCompanion data) {
return CustoMensalData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,descricao: data.descricao.present ? data.descricao.value : this.descricao,categoria: data.categoria.present ? data.categoria.value : this.categoria,valor: data.valor.present ? data.valor.value : this.valor,data: data.data.present ? data.data.value : this.data,tipo: data.tipo.present ? data.tipo.value : this.tipo,mesReferencia: data.mesReferencia.present ? data.mesReferencia.value : this.mesReferencia,anoReferencia: data.anoReferencia.present ? data.anoReferencia.value : this.anoReferencia,estado: data.estado.present ? data.estado.value : this.estado,observacao: data.observacao.present ? data.observacao.value : this.observacao,comprovativoUrl: data.comprovativoUrl.present ? data.comprovativoUrl.value : this.comprovativoUrl,comprovativoLocal: data.comprovativoLocal.present ? data.comprovativoLocal.value : this.comprovativoLocal,responsavelId: data.responsavelId.present ? data.responsavelId.value : this.responsavelId,);
}
@override
String toString() {return (StringBuffer('CustoMensalData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('descricao: $descricao, ')..write('categoria: $categoria, ')..write('valor: $valor, ')..write('data: $data, ')..write('tipo: $tipo, ')..write('mesReferencia: $mesReferencia, ')..write('anoReferencia: $anoReferencia, ')..write('estado: $estado, ')..write('observacao: $observacao, ')..write('comprovativoUrl: $comprovativoUrl, ')..write('comprovativoLocal: $comprovativoLocal, ')..write('responsavelId: $responsavelId')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, descricao, categoria, valor, data, tipo, mesReferencia, anoReferencia, estado, observacao, comprovativoUrl, comprovativoLocal, responsavelId);@override
bool operator ==(Object other) => identical(this, other) || (other is CustoMensalData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.descricao == this.descricao && other.categoria == this.categoria && other.valor == this.valor && other.data == this.data && other.tipo == this.tipo && other.mesReferencia == this.mesReferencia && other.anoReferencia == this.anoReferencia && other.estado == this.estado && other.observacao == this.observacao && other.comprovativoUrl == this.comprovativoUrl && other.comprovativoLocal == this.comprovativoLocal && other.responsavelId == this.responsavelId);
}class CustosMensaisCompanion extends UpdateCompanion<CustoMensalData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> descricao;
final Value<String> categoria;
final Value<double> valor;
final Value<DateTime> data;
final Value<String> tipo;
final Value<int> mesReferencia;
final Value<int> anoReferencia;
final Value<String> estado;
final Value<String?> observacao;
final Value<String?> comprovativoUrl;
final Value<String?> comprovativoLocal;
final Value<String> responsavelId;
const CustosMensaisCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.descricao = const Value.absent(),this.categoria = const Value.absent(),this.valor = const Value.absent(),this.data = const Value.absent(),this.tipo = const Value.absent(),this.mesReferencia = const Value.absent(),this.anoReferencia = const Value.absent(),this.estado = const Value.absent(),this.observacao = const Value.absent(),this.comprovativoUrl = const Value.absent(),this.comprovativoLocal = const Value.absent(),this.responsavelId = const Value.absent(),});
CustosMensaisCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String descricao,required String categoria,required double valor,required DateTime data,required String tipo,required int mesReferencia,required int anoReferencia,required String estado,this.observacao = const Value.absent(),this.comprovativoUrl = const Value.absent(),this.comprovativoLocal = const Value.absent(),required String responsavelId,}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), descricao = Value(descricao), categoria = Value(categoria), valor = Value(valor), data = Value(data), tipo = Value(tipo), mesReferencia = Value(mesReferencia), anoReferencia = Value(anoReferencia), estado = Value(estado), responsavelId = Value(responsavelId);
static Insertable<CustoMensalData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? descricao, 
Expression<String>? categoria, 
Expression<double>? valor, 
Expression<DateTime>? data, 
Expression<String>? tipo, 
Expression<int>? mesReferencia, 
Expression<int>? anoReferencia, 
Expression<String>? estado, 
Expression<String>? observacao, 
Expression<String>? comprovativoUrl, 
Expression<String>? comprovativoLocal, 
Expression<String>? responsavelId, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (descricao != null)'descricao': descricao,if (categoria != null)'categoria': categoria,if (valor != null)'valor': valor,if (data != null)'data': data,if (tipo != null)'tipo': tipo,if (mesReferencia != null)'mes_referencia': mesReferencia,if (anoReferencia != null)'ano_referencia': anoReferencia,if (estado != null)'estado': estado,if (observacao != null)'observacao': observacao,if (comprovativoUrl != null)'comprovativo_url': comprovativoUrl,if (comprovativoLocal != null)'comprovativo_local': comprovativoLocal,if (responsavelId != null)'responsavel_id': responsavelId,});
}CustosMensaisCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? descricao, Value<String>? categoria, Value<double>? valor, Value<DateTime>? data, Value<String>? tipo, Value<int>? mesReferencia, Value<int>? anoReferencia, Value<String>? estado, Value<String?>? observacao, Value<String?>? comprovativoUrl, Value<String?>? comprovativoLocal, Value<String>? responsavelId}) {
return CustosMensaisCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,descricao: descricao ?? this.descricao,categoria: categoria ?? this.categoria,valor: valor ?? this.valor,data: data ?? this.data,tipo: tipo ?? this.tipo,mesReferencia: mesReferencia ?? this.mesReferencia,anoReferencia: anoReferencia ?? this.anoReferencia,estado: estado ?? this.estado,observacao: observacao ?? this.observacao,comprovativoUrl: comprovativoUrl ?? this.comprovativoUrl,comprovativoLocal: comprovativoLocal ?? this.comprovativoLocal,responsavelId: responsavelId ?? this.responsavelId,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($CustosMensaisTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (descricao.present) {
map['descricao'] = Variable<String>(descricao.value);}
if (categoria.present) {
map['categoria'] = Variable<String>(categoria.value);}
if (valor.present) {
map['valor'] = Variable<double>(valor.value);}
if (data.present) {
map['data'] = Variable<DateTime>(data.value);}
if (tipo.present) {
map['tipo'] = Variable<String>(tipo.value);}
if (mesReferencia.present) {
map['mes_referencia'] = Variable<int>(mesReferencia.value);}
if (anoReferencia.present) {
map['ano_referencia'] = Variable<int>(anoReferencia.value);}
if (estado.present) {
map['estado'] = Variable<String>(estado.value);}
if (observacao.present) {
map['observacao'] = Variable<String>(observacao.value);}
if (comprovativoUrl.present) {
map['comprovativo_url'] = Variable<String>(comprovativoUrl.value);}
if (comprovativoLocal.present) {
map['comprovativo_local'] = Variable<String>(comprovativoLocal.value);}
if (responsavelId.present) {
map['responsavel_id'] = Variable<String>(responsavelId.value);}
return map; 
}
@override
String toString() {return (StringBuffer('CustosMensaisCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('descricao: $descricao, ')..write('categoria: $categoria, ')..write('valor: $valor, ')..write('data: $data, ')..write('tipo: $tipo, ')..write('mesReferencia: $mesReferencia, ')..write('anoReferencia: $anoReferencia, ')..write('estado: $estado, ')..write('observacao: $observacao, ')..write('comprovativoUrl: $comprovativoUrl, ')..write('comprovativoLocal: $comprovativoLocal, ')..write('responsavelId: $responsavelId')..write(')')).toString();}
}
class $TurmasTable extends Turmas with TableInfo<$TurmasTable, TurmaData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$TurmasTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($TurmasTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _nomeTurmaMeta = const VerificationMeta('nomeTurma');
@override
late final GeneratedColumn<String> nomeTurma = GeneratedColumn<String>('nome_turma', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _limiteAlunosMeta = const VerificationMeta('limiteAlunos');
@override
late final GeneratedColumn<int> limiteAlunos = GeneratedColumn<int>('limite_alunos', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _turnoMeta = const VerificationMeta('turno');
@override
late final GeneratedColumn<String> turno = GeneratedColumn<String>('turno', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _numeroSalaMeta = const VerificationMeta('numeroSala');
@override
late final GeneratedColumn<String> numeroSala = GeneratedColumn<String>('numero_sala', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _ativaMeta = const VerificationMeta('ativa');
@override
late final GeneratedColumn<bool> ativa = GeneratedColumn<bool>('ativa', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("ativa" IN (0, 1))'));
static const VerificationMeta _anoLectivoIdMeta = const VerificationMeta('anoLectivoId');
@override
late final GeneratedColumn<String> anoLectivoId = GeneratedColumn<String>('ano_lectivo_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, nomeTurma, limiteAlunos, turno, numeroSala, ativa, anoLectivoId];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'turmas';
@override
VerificationContext validateIntegrity(Insertable<TurmaData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('nome_turma')) {
context.handle(_nomeTurmaMeta, nomeTurma.isAcceptableOrUnknown(data['nome_turma']!, _nomeTurmaMeta));} else if (isInserting) {
context.missing(_nomeTurmaMeta);
}
if (data.containsKey('limite_alunos')) {
context.handle(_limiteAlunosMeta, limiteAlunos.isAcceptableOrUnknown(data['limite_alunos']!, _limiteAlunosMeta));} else if (isInserting) {
context.missing(_limiteAlunosMeta);
}
if (data.containsKey('turno')) {
context.handle(_turnoMeta, turno.isAcceptableOrUnknown(data['turno']!, _turnoMeta));} else if (isInserting) {
context.missing(_turnoMeta);
}
if (data.containsKey('numero_sala')) {
context.handle(_numeroSalaMeta, numeroSala.isAcceptableOrUnknown(data['numero_sala']!, _numeroSalaMeta));} else if (isInserting) {
context.missing(_numeroSalaMeta);
}
if (data.containsKey('ativa')) {
context.handle(_ativaMeta, ativa.isAcceptableOrUnknown(data['ativa']!, _ativaMeta));} else if (isInserting) {
context.missing(_ativaMeta);
}
if (data.containsKey('ano_lectivo_id')) {
context.handle(_anoLectivoIdMeta, anoLectivoId.isAcceptableOrUnknown(data['ano_lectivo_id']!, _anoLectivoIdMeta));} else if (isInserting) {
context.missing(_anoLectivoIdMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override TurmaData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return TurmaData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $TurmasTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, nomeTurma: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nome_turma'])!, limiteAlunos: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}limite_alunos'])!, turno: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}turno'])!, numeroSala: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}numero_sala'])!, ativa: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}ativa'])!, anoLectivoId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}ano_lectivo_id'])!, );
}
@override
$TurmasTable createAlias(String alias) {
return $TurmasTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class TurmaData extends DataClass implements Insertable<TurmaData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String nomeTurma;
final int limiteAlunos;
final String turno;
final String numeroSala;
final bool ativa;
final String anoLectivoId;
const TurmaData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.nomeTurma, required this.limiteAlunos, required this.turno, required this.numeroSala, required this.ativa, required this.anoLectivoId});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($TurmasTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['nome_turma'] = Variable<String>(nomeTurma);
map['limite_alunos'] = Variable<int>(limiteAlunos);
map['turno'] = Variable<String>(turno);
map['numero_sala'] = Variable<String>(numeroSala);
map['ativa'] = Variable<bool>(ativa);
map['ano_lectivo_id'] = Variable<String>(anoLectivoId);
return map; 
}
TurmasCompanion toCompanion(bool nullToAbsent) {
return TurmasCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),nomeTurma: Value(nomeTurma),limiteAlunos: Value(limiteAlunos),turno: Value(turno),numeroSala: Value(numeroSala),ativa: Value(ativa),anoLectivoId: Value(anoLectivoId),);
}
factory TurmaData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return TurmaData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $TurmasTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),nomeTurma: serializer.fromJson<String>(json['nomeTurma']),limiteAlunos: serializer.fromJson<int>(json['limiteAlunos']),turno: serializer.fromJson<String>(json['turno']),numeroSala: serializer.fromJson<String>(json['numeroSala']),ativa: serializer.fromJson<bool>(json['ativa']),anoLectivoId: serializer.fromJson<String>(json['anoLectivoId']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($TurmasTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'nomeTurma': serializer.toJson<String>(nomeTurma),'limiteAlunos': serializer.toJson<int>(limiteAlunos),'turno': serializer.toJson<String>(turno),'numeroSala': serializer.toJson<String>(numeroSala),'ativa': serializer.toJson<bool>(ativa),'anoLectivoId': serializer.toJson<String>(anoLectivoId),};}TurmaData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? nomeTurma,int? limiteAlunos,String? turno,String? numeroSala,bool? ativa,String? anoLectivoId}) => TurmaData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,nomeTurma: nomeTurma ?? this.nomeTurma,limiteAlunos: limiteAlunos ?? this.limiteAlunos,turno: turno ?? this.turno,numeroSala: numeroSala ?? this.numeroSala,ativa: ativa ?? this.ativa,anoLectivoId: anoLectivoId ?? this.anoLectivoId,);TurmaData copyWithCompanion(TurmasCompanion data) {
return TurmaData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,nomeTurma: data.nomeTurma.present ? data.nomeTurma.value : this.nomeTurma,limiteAlunos: data.limiteAlunos.present ? data.limiteAlunos.value : this.limiteAlunos,turno: data.turno.present ? data.turno.value : this.turno,numeroSala: data.numeroSala.present ? data.numeroSala.value : this.numeroSala,ativa: data.ativa.present ? data.ativa.value : this.ativa,anoLectivoId: data.anoLectivoId.present ? data.anoLectivoId.value : this.anoLectivoId,);
}
@override
String toString() {return (StringBuffer('TurmaData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('nomeTurma: $nomeTurma, ')..write('limiteAlunos: $limiteAlunos, ')..write('turno: $turno, ')..write('numeroSala: $numeroSala, ')..write('ativa: $ativa, ')..write('anoLectivoId: $anoLectivoId')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, nomeTurma, limiteAlunos, turno, numeroSala, ativa, anoLectivoId);@override
bool operator ==(Object other) => identical(this, other) || (other is TurmaData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.nomeTurma == this.nomeTurma && other.limiteAlunos == this.limiteAlunos && other.turno == this.turno && other.numeroSala == this.numeroSala && other.ativa == this.ativa && other.anoLectivoId == this.anoLectivoId);
}class TurmasCompanion extends UpdateCompanion<TurmaData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> nomeTurma;
final Value<int> limiteAlunos;
final Value<String> turno;
final Value<String> numeroSala;
final Value<bool> ativa;
final Value<String> anoLectivoId;
const TurmasCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.nomeTurma = const Value.absent(),this.limiteAlunos = const Value.absent(),this.turno = const Value.absent(),this.numeroSala = const Value.absent(),this.ativa = const Value.absent(),this.anoLectivoId = const Value.absent(),});
TurmasCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String nomeTurma,required int limiteAlunos,required String turno,required String numeroSala,required bool ativa,required String anoLectivoId,}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), nomeTurma = Value(nomeTurma), limiteAlunos = Value(limiteAlunos), turno = Value(turno), numeroSala = Value(numeroSala), ativa = Value(ativa), anoLectivoId = Value(anoLectivoId);
static Insertable<TurmaData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? nomeTurma, 
Expression<int>? limiteAlunos, 
Expression<String>? turno, 
Expression<String>? numeroSala, 
Expression<bool>? ativa, 
Expression<String>? anoLectivoId, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (nomeTurma != null)'nome_turma': nomeTurma,if (limiteAlunos != null)'limite_alunos': limiteAlunos,if (turno != null)'turno': turno,if (numeroSala != null)'numero_sala': numeroSala,if (ativa != null)'ativa': ativa,if (anoLectivoId != null)'ano_lectivo_id': anoLectivoId,});
}TurmasCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? nomeTurma, Value<int>? limiteAlunos, Value<String>? turno, Value<String>? numeroSala, Value<bool>? ativa, Value<String>? anoLectivoId}) {
return TurmasCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,nomeTurma: nomeTurma ?? this.nomeTurma,limiteAlunos: limiteAlunos ?? this.limiteAlunos,turno: turno ?? this.turno,numeroSala: numeroSala ?? this.numeroSala,ativa: ativa ?? this.ativa,anoLectivoId: anoLectivoId ?? this.anoLectivoId,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($TurmasTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (nomeTurma.present) {
map['nome_turma'] = Variable<String>(nomeTurma.value);}
if (limiteAlunos.present) {
map['limite_alunos'] = Variable<int>(limiteAlunos.value);}
if (turno.present) {
map['turno'] = Variable<String>(turno.value);}
if (numeroSala.present) {
map['numero_sala'] = Variable<String>(numeroSala.value);}
if (ativa.present) {
map['ativa'] = Variable<bool>(ativa.value);}
if (anoLectivoId.present) {
map['ano_lectivo_id'] = Variable<String>(anoLectivoId.value);}
return map; 
}
@override
String toString() {return (StringBuffer('TurmasCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('nomeTurma: $nomeTurma, ')..write('limiteAlunos: $limiteAlunos, ')..write('turno: $turno, ')..write('numeroSala: $numeroSala, ')..write('ativa: $ativa, ')..write('anoLectivoId: $anoLectivoId')..write(')')).toString();}
}
class $AnosLectivosTable extends AnosLectivos with TableInfo<$AnosLectivosTable, AnosLectivoData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$AnosLectivosTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($AnosLectivosTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _anoMeta = const VerificationMeta('ano');
@override
late final GeneratedColumn<String> ano = GeneratedColumn<String>('ano', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
static const VerificationMeta _dataInicioMeta = const VerificationMeta('dataInicio');
@override
late final GeneratedColumn<DateTime> dataInicio = GeneratedColumn<DateTime>('data_inicio', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _dataFimMeta = const VerificationMeta('dataFim');
@override
late final GeneratedColumn<DateTime> dataFim = GeneratedColumn<DateTime>('data_fim', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _isActiveMeta = const VerificationMeta('isActive');
@override
late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>('is_active', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'));
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, ano, dataInicio, dataFim, isActive];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'anos_lectivos';
@override
VerificationContext validateIntegrity(Insertable<AnosLectivoData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('ano')) {
context.handle(_anoMeta, ano.isAcceptableOrUnknown(data['ano']!, _anoMeta));} else if (isInserting) {
context.missing(_anoMeta);
}
if (data.containsKey('data_inicio')) {
context.handle(_dataInicioMeta, dataInicio.isAcceptableOrUnknown(data['data_inicio']!, _dataInicioMeta));} else if (isInserting) {
context.missing(_dataInicioMeta);
}
if (data.containsKey('data_fim')) {
context.handle(_dataFimMeta, dataFim.isAcceptableOrUnknown(data['data_fim']!, _dataFimMeta));} else if (isInserting) {
context.missing(_dataFimMeta);
}
if (data.containsKey('is_active')) {
context.handle(_isActiveMeta, isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));} else if (isInserting) {
context.missing(_isActiveMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override AnosLectivoData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return AnosLectivoData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $AnosLectivosTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, ano: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}ano'])!, dataInicio: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_inicio'])!, dataFim: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_fim'])!, isActive: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!, );
}
@override
$AnosLectivosTable createAlias(String alias) {
return $AnosLectivosTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class AnosLectivoData extends DataClass implements Insertable<AnosLectivoData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String ano;
final DateTime dataInicio;
final DateTime dataFim;
final bool isActive;
const AnosLectivoData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.ano, required this.dataInicio, required this.dataFim, required this.isActive});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($AnosLectivosTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['ano'] = Variable<String>(ano);
map['data_inicio'] = Variable<DateTime>(dataInicio);
map['data_fim'] = Variable<DateTime>(dataFim);
map['is_active'] = Variable<bool>(isActive);
return map; 
}
AnosLectivosCompanion toCompanion(bool nullToAbsent) {
return AnosLectivosCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),ano: Value(ano),dataInicio: Value(dataInicio),dataFim: Value(dataFim),isActive: Value(isActive),);
}
factory AnosLectivoData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return AnosLectivoData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $AnosLectivosTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),ano: serializer.fromJson<String>(json['ano']),dataInicio: serializer.fromJson<DateTime>(json['dataInicio']),dataFim: serializer.fromJson<DateTime>(json['dataFim']),isActive: serializer.fromJson<bool>(json['isActive']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($AnosLectivosTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'ano': serializer.toJson<String>(ano),'dataInicio': serializer.toJson<DateTime>(dataInicio),'dataFim': serializer.toJson<DateTime>(dataFim),'isActive': serializer.toJson<bool>(isActive),};}AnosLectivoData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? ano,DateTime? dataInicio,DateTime? dataFim,bool? isActive}) => AnosLectivoData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,ano: ano ?? this.ano,dataInicio: dataInicio ?? this.dataInicio,dataFim: dataFim ?? this.dataFim,isActive: isActive ?? this.isActive,);AnosLectivoData copyWithCompanion(AnosLectivosCompanion data) {
return AnosLectivoData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,ano: data.ano.present ? data.ano.value : this.ano,dataInicio: data.dataInicio.present ? data.dataInicio.value : this.dataInicio,dataFim: data.dataFim.present ? data.dataFim.value : this.dataFim,isActive: data.isActive.present ? data.isActive.value : this.isActive,);
}
@override
String toString() {return (StringBuffer('AnosLectivoData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('ano: $ano, ')..write('dataInicio: $dataInicio, ')..write('dataFim: $dataFim, ')..write('isActive: $isActive')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, ano, dataInicio, dataFim, isActive);@override
bool operator ==(Object other) => identical(this, other) || (other is AnosLectivoData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.ano == this.ano && other.dataInicio == this.dataInicio && other.dataFim == this.dataFim && other.isActive == this.isActive);
}class AnosLectivosCompanion extends UpdateCompanion<AnosLectivoData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> ano;
final Value<DateTime> dataInicio;
final Value<DateTime> dataFim;
final Value<bool> isActive;
const AnosLectivosCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.ano = const Value.absent(),this.dataInicio = const Value.absent(),this.dataFim = const Value.absent(),this.isActive = const Value.absent(),});
AnosLectivosCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String ano,required DateTime dataInicio,required DateTime dataFim,required bool isActive,}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), ano = Value(ano), dataInicio = Value(dataInicio), dataFim = Value(dataFim), isActive = Value(isActive);
static Insertable<AnosLectivoData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? ano, 
Expression<DateTime>? dataInicio, 
Expression<DateTime>? dataFim, 
Expression<bool>? isActive, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (ano != null)'ano': ano,if (dataInicio != null)'data_inicio': dataInicio,if (dataFim != null)'data_fim': dataFim,if (isActive != null)'is_active': isActive,});
}AnosLectivosCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? ano, Value<DateTime>? dataInicio, Value<DateTime>? dataFim, Value<bool>? isActive}) {
return AnosLectivosCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,ano: ano ?? this.ano,dataInicio: dataInicio ?? this.dataInicio,dataFim: dataFim ?? this.dataFim,isActive: isActive ?? this.isActive,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($AnosLectivosTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (ano.present) {
map['ano'] = Variable<String>(ano.value);}
if (dataInicio.present) {
map['data_inicio'] = Variable<DateTime>(dataInicio.value);}
if (dataFim.present) {
map['data_fim'] = Variable<DateTime>(dataFim.value);}
if (isActive.present) {
map['is_active'] = Variable<bool>(isActive.value);}
return map; 
}
@override
String toString() {return (StringBuffer('AnosLectivosCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('ano: $ano, ')..write('dataInicio: $dataInicio, ')..write('dataFim: $dataFim, ')..write('isActive: $isActive')..write(')')).toString();}
}
class $MatriculasTable extends Matriculas with TableInfo<$MatriculasTable, MatriculaData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$MatriculasTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($MatriculasTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _numeroMatriculaMeta = const VerificationMeta('numeroMatricula');
@override
late final GeneratedColumn<String> numeroMatricula = GeneratedColumn<String>('numero_matricula', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _alunoIdMeta = const VerificationMeta('alunoId');
@override
late final GeneratedColumn<String> alunoId = GeneratedColumn<String>('aluno_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _turmaIdMeta = const VerificationMeta('turmaId');
@override
late final GeneratedColumn<String> turmaId = GeneratedColumn<String>('turma_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _turnoMeta = const VerificationMeta('turno');
@override
late final GeneratedColumn<String> turno = GeneratedColumn<String>('turno', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _anoLectivoMeta = const VerificationMeta('anoLectivo');
@override
late final GeneratedColumn<String> anoLectivo = GeneratedColumn<String>('ano_lectivo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _dataMatriculaMeta = const VerificationMeta('dataMatricula');
@override
late final GeneratedColumn<DateTime> dataMatricula = GeneratedColumn<DateTime>('data_matricula', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
@override
late final GeneratedColumn<String> estado = GeneratedColumn<String>('estado', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _valorMensalidadeMeta = const VerificationMeta('valorMensalidade');
@override
late final GeneratedColumn<double> valorMensalidade = GeneratedColumn<double>('valor_mensalidade', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
static const VerificationMeta _diaVencimentoMeta = const VerificationMeta('diaVencimento');
@override
late final GeneratedColumn<int> diaVencimento = GeneratedColumn<int>('dia_vencimento', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, numeroMatricula, alunoId, turmaId, turno, anoLectivo, dataMatricula, estado, valorMensalidade, diaVencimento];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'matriculas';
@override
VerificationContext validateIntegrity(Insertable<MatriculaData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('numero_matricula')) {
context.handle(_numeroMatriculaMeta, numeroMatricula.isAcceptableOrUnknown(data['numero_matricula']!, _numeroMatriculaMeta));} else if (isInserting) {
context.missing(_numeroMatriculaMeta);
}
if (data.containsKey('aluno_id')) {
context.handle(_alunoIdMeta, alunoId.isAcceptableOrUnknown(data['aluno_id']!, _alunoIdMeta));} else if (isInserting) {
context.missing(_alunoIdMeta);
}
if (data.containsKey('turma_id')) {
context.handle(_turmaIdMeta, turmaId.isAcceptableOrUnknown(data['turma_id']!, _turmaIdMeta));} else if (isInserting) {
context.missing(_turmaIdMeta);
}
if (data.containsKey('turno')) {
context.handle(_turnoMeta, turno.isAcceptableOrUnknown(data['turno']!, _turnoMeta));} else if (isInserting) {
context.missing(_turnoMeta);
}
if (data.containsKey('ano_lectivo')) {
context.handle(_anoLectivoMeta, anoLectivo.isAcceptableOrUnknown(data['ano_lectivo']!, _anoLectivoMeta));} else if (isInserting) {
context.missing(_anoLectivoMeta);
}
if (data.containsKey('data_matricula')) {
context.handle(_dataMatriculaMeta, dataMatricula.isAcceptableOrUnknown(data['data_matricula']!, _dataMatriculaMeta));} else if (isInserting) {
context.missing(_dataMatriculaMeta);
}
if (data.containsKey('estado')) {
context.handle(_estadoMeta, estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));} else if (isInserting) {
context.missing(_estadoMeta);
}
if (data.containsKey('valor_mensalidade')) {
context.handle(_valorMensalidadeMeta, valorMensalidade.isAcceptableOrUnknown(data['valor_mensalidade']!, _valorMensalidadeMeta));} else if (isInserting) {
context.missing(_valorMensalidadeMeta);
}
if (data.containsKey('dia_vencimento')) {
context.handle(_diaVencimentoMeta, diaVencimento.isAcceptableOrUnknown(data['dia_vencimento']!, _diaVencimentoMeta));} else if (isInserting) {
context.missing(_diaVencimentoMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override MatriculaData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return MatriculaData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $MatriculasTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, numeroMatricula: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}numero_matricula'])!, alunoId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}aluno_id'])!, turmaId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}turma_id'])!, turno: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}turno'])!, anoLectivo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}ano_lectivo'])!, dataMatricula: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_matricula'])!, estado: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}estado'])!, valorMensalidade: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}valor_mensalidade'])!, diaVencimento: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}dia_vencimento'])!, );
}
@override
$MatriculasTable createAlias(String alias) {
return $MatriculasTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class MatriculaData extends DataClass implements Insertable<MatriculaData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String numeroMatricula;
final String alunoId;
final String turmaId;
final String turno;
final String anoLectivo;
final DateTime dataMatricula;
final String estado;
final double valorMensalidade;
final int diaVencimento;
const MatriculaData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.numeroMatricula, required this.alunoId, required this.turmaId, required this.turno, required this.anoLectivo, required this.dataMatricula, required this.estado, required this.valorMensalidade, required this.diaVencimento});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($MatriculasTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['numero_matricula'] = Variable<String>(numeroMatricula);
map['aluno_id'] = Variable<String>(alunoId);
map['turma_id'] = Variable<String>(turmaId);
map['turno'] = Variable<String>(turno);
map['ano_lectivo'] = Variable<String>(anoLectivo);
map['data_matricula'] = Variable<DateTime>(dataMatricula);
map['estado'] = Variable<String>(estado);
map['valor_mensalidade'] = Variable<double>(valorMensalidade);
map['dia_vencimento'] = Variable<int>(diaVencimento);
return map; 
}
MatriculasCompanion toCompanion(bool nullToAbsent) {
return MatriculasCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),numeroMatricula: Value(numeroMatricula),alunoId: Value(alunoId),turmaId: Value(turmaId),turno: Value(turno),anoLectivo: Value(anoLectivo),dataMatricula: Value(dataMatricula),estado: Value(estado),valorMensalidade: Value(valorMensalidade),diaVencimento: Value(diaVencimento),);
}
factory MatriculaData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return MatriculaData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $MatriculasTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),numeroMatricula: serializer.fromJson<String>(json['numeroMatricula']),alunoId: serializer.fromJson<String>(json['alunoId']),turmaId: serializer.fromJson<String>(json['turmaId']),turno: serializer.fromJson<String>(json['turno']),anoLectivo: serializer.fromJson<String>(json['anoLectivo']),dataMatricula: serializer.fromJson<DateTime>(json['dataMatricula']),estado: serializer.fromJson<String>(json['estado']),valorMensalidade: serializer.fromJson<double>(json['valorMensalidade']),diaVencimento: serializer.fromJson<int>(json['diaVencimento']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($MatriculasTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'numeroMatricula': serializer.toJson<String>(numeroMatricula),'alunoId': serializer.toJson<String>(alunoId),'turmaId': serializer.toJson<String>(turmaId),'turno': serializer.toJson<String>(turno),'anoLectivo': serializer.toJson<String>(anoLectivo),'dataMatricula': serializer.toJson<DateTime>(dataMatricula),'estado': serializer.toJson<String>(estado),'valorMensalidade': serializer.toJson<double>(valorMensalidade),'diaVencimento': serializer.toJson<int>(diaVencimento),};}MatriculaData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? numeroMatricula,String? alunoId,String? turmaId,String? turno,String? anoLectivo,DateTime? dataMatricula,String? estado,double? valorMensalidade,int? diaVencimento}) => MatriculaData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,numeroMatricula: numeroMatricula ?? this.numeroMatricula,alunoId: alunoId ?? this.alunoId,turmaId: turmaId ?? this.turmaId,turno: turno ?? this.turno,anoLectivo: anoLectivo ?? this.anoLectivo,dataMatricula: dataMatricula ?? this.dataMatricula,estado: estado ?? this.estado,valorMensalidade: valorMensalidade ?? this.valorMensalidade,diaVencimento: diaVencimento ?? this.diaVencimento,);MatriculaData copyWithCompanion(MatriculasCompanion data) {
return MatriculaData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,numeroMatricula: data.numeroMatricula.present ? data.numeroMatricula.value : this.numeroMatricula,alunoId: data.alunoId.present ? data.alunoId.value : this.alunoId,turmaId: data.turmaId.present ? data.turmaId.value : this.turmaId,turno: data.turno.present ? data.turno.value : this.turno,anoLectivo: data.anoLectivo.present ? data.anoLectivo.value : this.anoLectivo,dataMatricula: data.dataMatricula.present ? data.dataMatricula.value : this.dataMatricula,estado: data.estado.present ? data.estado.value : this.estado,valorMensalidade: data.valorMensalidade.present ? data.valorMensalidade.value : this.valorMensalidade,diaVencimento: data.diaVencimento.present ? data.diaVencimento.value : this.diaVencimento,);
}
@override
String toString() {return (StringBuffer('MatriculaData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('numeroMatricula: $numeroMatricula, ')..write('alunoId: $alunoId, ')..write('turmaId: $turmaId, ')..write('turno: $turno, ')..write('anoLectivo: $anoLectivo, ')..write('dataMatricula: $dataMatricula, ')..write('estado: $estado, ')..write('valorMensalidade: $valorMensalidade, ')..write('diaVencimento: $diaVencimento')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, numeroMatricula, alunoId, turmaId, turno, anoLectivo, dataMatricula, estado, valorMensalidade, diaVencimento);@override
bool operator ==(Object other) => identical(this, other) || (other is MatriculaData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.numeroMatricula == this.numeroMatricula && other.alunoId == this.alunoId && other.turmaId == this.turmaId && other.turno == this.turno && other.anoLectivo == this.anoLectivo && other.dataMatricula == this.dataMatricula && other.estado == this.estado && other.valorMensalidade == this.valorMensalidade && other.diaVencimento == this.diaVencimento);
}class MatriculasCompanion extends UpdateCompanion<MatriculaData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> numeroMatricula;
final Value<String> alunoId;
final Value<String> turmaId;
final Value<String> turno;
final Value<String> anoLectivo;
final Value<DateTime> dataMatricula;
final Value<String> estado;
final Value<double> valorMensalidade;
final Value<int> diaVencimento;
const MatriculasCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.numeroMatricula = const Value.absent(),this.alunoId = const Value.absent(),this.turmaId = const Value.absent(),this.turno = const Value.absent(),this.anoLectivo = const Value.absent(),this.dataMatricula = const Value.absent(),this.estado = const Value.absent(),this.valorMensalidade = const Value.absent(),this.diaVencimento = const Value.absent(),});
MatriculasCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String numeroMatricula,required String alunoId,required String turmaId,required String turno,required String anoLectivo,required DateTime dataMatricula,required String estado,required double valorMensalidade,required int diaVencimento,}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), numeroMatricula = Value(numeroMatricula), alunoId = Value(alunoId), turmaId = Value(turmaId), turno = Value(turno), anoLectivo = Value(anoLectivo), dataMatricula = Value(dataMatricula), estado = Value(estado), valorMensalidade = Value(valorMensalidade), diaVencimento = Value(diaVencimento);
static Insertable<MatriculaData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? numeroMatricula, 
Expression<String>? alunoId, 
Expression<String>? turmaId, 
Expression<String>? turno, 
Expression<String>? anoLectivo, 
Expression<DateTime>? dataMatricula, 
Expression<String>? estado, 
Expression<double>? valorMensalidade, 
Expression<int>? diaVencimento, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (numeroMatricula != null)'numero_matricula': numeroMatricula,if (alunoId != null)'aluno_id': alunoId,if (turmaId != null)'turma_id': turmaId,if (turno != null)'turno': turno,if (anoLectivo != null)'ano_lectivo': anoLectivo,if (dataMatricula != null)'data_matricula': dataMatricula,if (estado != null)'estado': estado,if (valorMensalidade != null)'valor_mensalidade': valorMensalidade,if (diaVencimento != null)'dia_vencimento': diaVencimento,});
}MatriculasCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? numeroMatricula, Value<String>? alunoId, Value<String>? turmaId, Value<String>? turno, Value<String>? anoLectivo, Value<DateTime>? dataMatricula, Value<String>? estado, Value<double>? valorMensalidade, Value<int>? diaVencimento}) {
return MatriculasCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,numeroMatricula: numeroMatricula ?? this.numeroMatricula,alunoId: alunoId ?? this.alunoId,turmaId: turmaId ?? this.turmaId,turno: turno ?? this.turno,anoLectivo: anoLectivo ?? this.anoLectivo,dataMatricula: dataMatricula ?? this.dataMatricula,estado: estado ?? this.estado,valorMensalidade: valorMensalidade ?? this.valorMensalidade,diaVencimento: diaVencimento ?? this.diaVencimento,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($MatriculasTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (numeroMatricula.present) {
map['numero_matricula'] = Variable<String>(numeroMatricula.value);}
if (alunoId.present) {
map['aluno_id'] = Variable<String>(alunoId.value);}
if (turmaId.present) {
map['turma_id'] = Variable<String>(turmaId.value);}
if (turno.present) {
map['turno'] = Variable<String>(turno.value);}
if (anoLectivo.present) {
map['ano_lectivo'] = Variable<String>(anoLectivo.value);}
if (dataMatricula.present) {
map['data_matricula'] = Variable<DateTime>(dataMatricula.value);}
if (estado.present) {
map['estado'] = Variable<String>(estado.value);}
if (valorMensalidade.present) {
map['valor_mensalidade'] = Variable<double>(valorMensalidade.value);}
if (diaVencimento.present) {
map['dia_vencimento'] = Variable<int>(diaVencimento.value);}
return map; 
}
@override
String toString() {return (StringBuffer('MatriculasCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('numeroMatricula: $numeroMatricula, ')..write('alunoId: $alunoId, ')..write('turmaId: $turmaId, ')..write('turno: $turno, ')..write('anoLectivo: $anoLectivo, ')..write('dataMatricula: $dataMatricula, ')..write('estado: $estado, ')..write('valorMensalidade: $valorMensalidade, ')..write('diaVencimento: $diaVencimento')..write(')')).toString();}
}
class $PagamentosTable extends Pagamentos with TableInfo<$PagamentosTable, PagamentoData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$PagamentosTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($PagamentosTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _mensalidadeIdMeta = const VerificationMeta('mensalidadeId');
@override
late final GeneratedColumn<String> mensalidadeId = GeneratedColumn<String>('mensalidade_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _valorPagoMeta = const VerificationMeta('valorPago');
@override
late final GeneratedColumn<double> valorPago = GeneratedColumn<double>('valor_pago', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
static const VerificationMeta _dataPagamentoMeta = const VerificationMeta('dataPagamento');
@override
late final GeneratedColumn<DateTime> dataPagamento = GeneratedColumn<DateTime>('data_pagamento', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _formaPagamentoMeta = const VerificationMeta('formaPagamento');
@override
late final GeneratedColumn<String> formaPagamento = GeneratedColumn<String>('forma_pagamento', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _observacaoMeta = const VerificationMeta('observacao');
@override
late final GeneratedColumn<String> observacao = GeneratedColumn<String>('observacao', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _evidenciaIdMeta = const VerificationMeta('evidenciaId');
@override
late final GeneratedColumn<String> evidenciaId = GeneratedColumn<String>('evidencia_id', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _numeroReciboMeta = const VerificationMeta('numeroRecibo');
@override
late final GeneratedColumn<String> numeroRecibo = GeneratedColumn<String>('numero_recibo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _confirmadoPorMeta = const VerificationMeta('confirmadoPor');
@override
late final GeneratedColumn<String> confirmadoPor = GeneratedColumn<String>('confirmado_por', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, mensalidadeId, valorPago, dataPagamento, formaPagamento, observacao, evidenciaId, numeroRecibo, confirmadoPor];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'pagamentos';
@override
VerificationContext validateIntegrity(Insertable<PagamentoData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('mensalidade_id')) {
context.handle(_mensalidadeIdMeta, mensalidadeId.isAcceptableOrUnknown(data['mensalidade_id']!, _mensalidadeIdMeta));} else if (isInserting) {
context.missing(_mensalidadeIdMeta);
}
if (data.containsKey('valor_pago')) {
context.handle(_valorPagoMeta, valorPago.isAcceptableOrUnknown(data['valor_pago']!, _valorPagoMeta));} else if (isInserting) {
context.missing(_valorPagoMeta);
}
if (data.containsKey('data_pagamento')) {
context.handle(_dataPagamentoMeta, dataPagamento.isAcceptableOrUnknown(data['data_pagamento']!, _dataPagamentoMeta));} else if (isInserting) {
context.missing(_dataPagamentoMeta);
}
if (data.containsKey('forma_pagamento')) {
context.handle(_formaPagamentoMeta, formaPagamento.isAcceptableOrUnknown(data['forma_pagamento']!, _formaPagamentoMeta));} else if (isInserting) {
context.missing(_formaPagamentoMeta);
}
if (data.containsKey('observacao')) {
context.handle(_observacaoMeta, observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta));}if (data.containsKey('evidencia_id')) {
context.handle(_evidenciaIdMeta, evidenciaId.isAcceptableOrUnknown(data['evidencia_id']!, _evidenciaIdMeta));}if (data.containsKey('numero_recibo')) {
context.handle(_numeroReciboMeta, numeroRecibo.isAcceptableOrUnknown(data['numero_recibo']!, _numeroReciboMeta));} else if (isInserting) {
context.missing(_numeroReciboMeta);
}
if (data.containsKey('confirmado_por')) {
context.handle(_confirmadoPorMeta, confirmadoPor.isAcceptableOrUnknown(data['confirmado_por']!, _confirmadoPorMeta));} else if (isInserting) {
context.missing(_confirmadoPorMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override PagamentoData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return PagamentoData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $PagamentosTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, mensalidadeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}mensalidade_id'])!, valorPago: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}valor_pago'])!, dataPagamento: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_pagamento'])!, formaPagamento: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}forma_pagamento'])!, observacao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}observacao']), evidenciaId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}evidencia_id']), numeroRecibo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}numero_recibo'])!, confirmadoPor: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}confirmado_por'])!, );
}
@override
$PagamentosTable createAlias(String alias) {
return $PagamentosTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class PagamentoData extends DataClass implements Insertable<PagamentoData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String mensalidadeId;
final double valorPago;
final DateTime dataPagamento;
final String formaPagamento;
final String? observacao;
final String? evidenciaId;
final String numeroRecibo;
final String confirmadoPor;
const PagamentoData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.mensalidadeId, required this.valorPago, required this.dataPagamento, required this.formaPagamento, this.observacao, this.evidenciaId, required this.numeroRecibo, required this.confirmadoPor});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($PagamentosTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['mensalidade_id'] = Variable<String>(mensalidadeId);
map['valor_pago'] = Variable<double>(valorPago);
map['data_pagamento'] = Variable<DateTime>(dataPagamento);
map['forma_pagamento'] = Variable<String>(formaPagamento);
if (!nullToAbsent || observacao != null){map['observacao'] = Variable<String>(observacao);
}if (!nullToAbsent || evidenciaId != null){map['evidencia_id'] = Variable<String>(evidenciaId);
}map['numero_recibo'] = Variable<String>(numeroRecibo);
map['confirmado_por'] = Variable<String>(confirmadoPor);
return map; 
}
PagamentosCompanion toCompanion(bool nullToAbsent) {
return PagamentosCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),mensalidadeId: Value(mensalidadeId),valorPago: Value(valorPago),dataPagamento: Value(dataPagamento),formaPagamento: Value(formaPagamento),observacao: observacao == null && nullToAbsent ? const Value.absent() : Value(observacao),evidenciaId: evidenciaId == null && nullToAbsent ? const Value.absent() : Value(evidenciaId),numeroRecibo: Value(numeroRecibo),confirmadoPor: Value(confirmadoPor),);
}
factory PagamentoData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return PagamentoData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $PagamentosTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),mensalidadeId: serializer.fromJson<String>(json['mensalidadeId']),valorPago: serializer.fromJson<double>(json['valorPago']),dataPagamento: serializer.fromJson<DateTime>(json['dataPagamento']),formaPagamento: serializer.fromJson<String>(json['formaPagamento']),observacao: serializer.fromJson<String?>(json['observacao']),evidenciaId: serializer.fromJson<String?>(json['evidenciaId']),numeroRecibo: serializer.fromJson<String>(json['numeroRecibo']),confirmadoPor: serializer.fromJson<String>(json['confirmadoPor']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($PagamentosTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'mensalidadeId': serializer.toJson<String>(mensalidadeId),'valorPago': serializer.toJson<double>(valorPago),'dataPagamento': serializer.toJson<DateTime>(dataPagamento),'formaPagamento': serializer.toJson<String>(formaPagamento),'observacao': serializer.toJson<String?>(observacao),'evidenciaId': serializer.toJson<String?>(evidenciaId),'numeroRecibo': serializer.toJson<String>(numeroRecibo),'confirmadoPor': serializer.toJson<String>(confirmadoPor),};}PagamentoData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? mensalidadeId,double? valorPago,DateTime? dataPagamento,String? formaPagamento,Value<String?> observacao = const Value.absent(),Value<String?> evidenciaId = const Value.absent(),String? numeroRecibo,String? confirmadoPor}) => PagamentoData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,mensalidadeId: mensalidadeId ?? this.mensalidadeId,valorPago: valorPago ?? this.valorPago,dataPagamento: dataPagamento ?? this.dataPagamento,formaPagamento: formaPagamento ?? this.formaPagamento,observacao: observacao.present ? observacao.value : this.observacao,evidenciaId: evidenciaId.present ? evidenciaId.value : this.evidenciaId,numeroRecibo: numeroRecibo ?? this.numeroRecibo,confirmadoPor: confirmadoPor ?? this.confirmadoPor,);PagamentoData copyWithCompanion(PagamentosCompanion data) {
return PagamentoData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,mensalidadeId: data.mensalidadeId.present ? data.mensalidadeId.value : this.mensalidadeId,valorPago: data.valorPago.present ? data.valorPago.value : this.valorPago,dataPagamento: data.dataPagamento.present ? data.dataPagamento.value : this.dataPagamento,formaPagamento: data.formaPagamento.present ? data.formaPagamento.value : this.formaPagamento,observacao: data.observacao.present ? data.observacao.value : this.observacao,evidenciaId: data.evidenciaId.present ? data.evidenciaId.value : this.evidenciaId,numeroRecibo: data.numeroRecibo.present ? data.numeroRecibo.value : this.numeroRecibo,confirmadoPor: data.confirmadoPor.present ? data.confirmadoPor.value : this.confirmadoPor,);
}
@override
String toString() {return (StringBuffer('PagamentoData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('mensalidadeId: $mensalidadeId, ')..write('valorPago: $valorPago, ')..write('dataPagamento: $dataPagamento, ')..write('formaPagamento: $formaPagamento, ')..write('observacao: $observacao, ')..write('evidenciaId: $evidenciaId, ')..write('numeroRecibo: $numeroRecibo, ')..write('confirmadoPor: $confirmadoPor')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, mensalidadeId, valorPago, dataPagamento, formaPagamento, observacao, evidenciaId, numeroRecibo, confirmadoPor);@override
bool operator ==(Object other) => identical(this, other) || (other is PagamentoData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.mensalidadeId == this.mensalidadeId && other.valorPago == this.valorPago && other.dataPagamento == this.dataPagamento && other.formaPagamento == this.formaPagamento && other.observacao == this.observacao && other.evidenciaId == this.evidenciaId && other.numeroRecibo == this.numeroRecibo && other.confirmadoPor == this.confirmadoPor);
}class PagamentosCompanion extends UpdateCompanion<PagamentoData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> mensalidadeId;
final Value<double> valorPago;
final Value<DateTime> dataPagamento;
final Value<String> formaPagamento;
final Value<String?> observacao;
final Value<String?> evidenciaId;
final Value<String> numeroRecibo;
final Value<String> confirmadoPor;
const PagamentosCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.mensalidadeId = const Value.absent(),this.valorPago = const Value.absent(),this.dataPagamento = const Value.absent(),this.formaPagamento = const Value.absent(),this.observacao = const Value.absent(),this.evidenciaId = const Value.absent(),this.numeroRecibo = const Value.absent(),this.confirmadoPor = const Value.absent(),});
PagamentosCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String mensalidadeId,required double valorPago,required DateTime dataPagamento,required String formaPagamento,this.observacao = const Value.absent(),this.evidenciaId = const Value.absent(),required String numeroRecibo,required String confirmadoPor,}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), mensalidadeId = Value(mensalidadeId), valorPago = Value(valorPago), dataPagamento = Value(dataPagamento), formaPagamento = Value(formaPagamento), numeroRecibo = Value(numeroRecibo), confirmadoPor = Value(confirmadoPor);
static Insertable<PagamentoData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? mensalidadeId, 
Expression<double>? valorPago, 
Expression<DateTime>? dataPagamento, 
Expression<String>? formaPagamento, 
Expression<String>? observacao, 
Expression<String>? evidenciaId, 
Expression<String>? numeroRecibo, 
Expression<String>? confirmadoPor, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (mensalidadeId != null)'mensalidade_id': mensalidadeId,if (valorPago != null)'valor_pago': valorPago,if (dataPagamento != null)'data_pagamento': dataPagamento,if (formaPagamento != null)'forma_pagamento': formaPagamento,if (observacao != null)'observacao': observacao,if (evidenciaId != null)'evidencia_id': evidenciaId,if (numeroRecibo != null)'numero_recibo': numeroRecibo,if (confirmadoPor != null)'confirmado_por': confirmadoPor,});
}PagamentosCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? mensalidadeId, Value<double>? valorPago, Value<DateTime>? dataPagamento, Value<String>? formaPagamento, Value<String?>? observacao, Value<String?>? evidenciaId, Value<String>? numeroRecibo, Value<String>? confirmadoPor}) {
return PagamentosCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,mensalidadeId: mensalidadeId ?? this.mensalidadeId,valorPago: valorPago ?? this.valorPago,dataPagamento: dataPagamento ?? this.dataPagamento,formaPagamento: formaPagamento ?? this.formaPagamento,observacao: observacao ?? this.observacao,evidenciaId: evidenciaId ?? this.evidenciaId,numeroRecibo: numeroRecibo ?? this.numeroRecibo,confirmadoPor: confirmadoPor ?? this.confirmadoPor,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($PagamentosTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (mensalidadeId.present) {
map['mensalidade_id'] = Variable<String>(mensalidadeId.value);}
if (valorPago.present) {
map['valor_pago'] = Variable<double>(valorPago.value);}
if (dataPagamento.present) {
map['data_pagamento'] = Variable<DateTime>(dataPagamento.value);}
if (formaPagamento.present) {
map['forma_pagamento'] = Variable<String>(formaPagamento.value);}
if (observacao.present) {
map['observacao'] = Variable<String>(observacao.value);}
if (evidenciaId.present) {
map['evidencia_id'] = Variable<String>(evidenciaId.value);}
if (numeroRecibo.present) {
map['numero_recibo'] = Variable<String>(numeroRecibo.value);}
if (confirmadoPor.present) {
map['confirmado_por'] = Variable<String>(confirmadoPor.value);}
return map; 
}
@override
String toString() {return (StringBuffer('PagamentosCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('mensalidadeId: $mensalidadeId, ')..write('valorPago: $valorPago, ')..write('dataPagamento: $dataPagamento, ')..write('formaPagamento: $formaPagamento, ')..write('observacao: $observacao, ')..write('evidenciaId: $evidenciaId, ')..write('numeroRecibo: $numeroRecibo, ')..write('confirmadoPor: $confirmadoPor')..write(')')).toString();}
}
class $AuditoriasTable extends Auditorias with TableInfo<$AuditoriasTable, AuditoriaData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$AuditoriasTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _entidadeMeta = const VerificationMeta('entidade');
@override
late final GeneratedColumn<String> entidade = GeneratedColumn<String>('entidade', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _entidadeIdMeta = const VerificationMeta('entidadeId');
@override
late final GeneratedColumn<String> entidadeId = GeneratedColumn<String>('entidade_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _acaoMeta = const VerificationMeta('acao');
@override
late final GeneratedColumn<String> acao = GeneratedColumn<String>('acao', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _valorAnteriorJsonMeta = const VerificationMeta('valorAnteriorJson');
@override
late final GeneratedColumn<String> valorAnteriorJson = GeneratedColumn<String>('valor_anterior_json', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _valorNovoJsonMeta = const VerificationMeta('valorNovoJson');
@override
late final GeneratedColumn<String> valorNovoJson = GeneratedColumn<String>('valor_novo_json', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _utilizadorIdMeta = const VerificationMeta('utilizadorId');
@override
late final GeneratedColumn<String> utilizadorId = GeneratedColumn<String>('utilizador_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _dataHoraMeta = const VerificationMeta('dataHora');
@override
late final GeneratedColumn<DateTime> dataHora = GeneratedColumn<DateTime>('data_hora', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [localId, id, entidade, entidadeId, acao, valorAnteriorJson, valorNovoJson, utilizadorId, dataHora];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'auditorias';
@override
VerificationContext validateIntegrity(Insertable<AuditoriaData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('entidade')) {
context.handle(_entidadeMeta, entidade.isAcceptableOrUnknown(data['entidade']!, _entidadeMeta));} else if (isInserting) {
context.missing(_entidadeMeta);
}
if (data.containsKey('entidade_id')) {
context.handle(_entidadeIdMeta, entidadeId.isAcceptableOrUnknown(data['entidade_id']!, _entidadeIdMeta));} else if (isInserting) {
context.missing(_entidadeIdMeta);
}
if (data.containsKey('acao')) {
context.handle(_acaoMeta, acao.isAcceptableOrUnknown(data['acao']!, _acaoMeta));} else if (isInserting) {
context.missing(_acaoMeta);
}
if (data.containsKey('valor_anterior_json')) {
context.handle(_valorAnteriorJsonMeta, valorAnteriorJson.isAcceptableOrUnknown(data['valor_anterior_json']!, _valorAnteriorJsonMeta));}if (data.containsKey('valor_novo_json')) {
context.handle(_valorNovoJsonMeta, valorNovoJson.isAcceptableOrUnknown(data['valor_novo_json']!, _valorNovoJsonMeta));}if (data.containsKey('utilizador_id')) {
context.handle(_utilizadorIdMeta, utilizadorId.isAcceptableOrUnknown(data['utilizador_id']!, _utilizadorIdMeta));} else if (isInserting) {
context.missing(_utilizadorIdMeta);
}
if (data.containsKey('data_hora')) {
context.handle(_dataHoraMeta, dataHora.isAcceptableOrUnknown(data['data_hora']!, _dataHoraMeta));} else if (isInserting) {
context.missing(_dataHoraMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override AuditoriaData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return AuditoriaData(localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, entidade: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entidade'])!, entidadeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entidade_id'])!, acao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}acao'])!, valorAnteriorJson: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}valor_anterior_json']), valorNovoJson: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}valor_novo_json']), utilizadorId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}utilizador_id'])!, dataHora: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_hora'])!, );
}
@override
$AuditoriasTable createAlias(String alias) {
return $AuditoriasTable(attachedDatabase, alias);}}class AuditoriaData extends DataClass implements Insertable<AuditoriaData> 
{
final int localId;
final String id;
final String entidade;
final String entidadeId;
final String acao;
final String? valorAnteriorJson;
final String? valorNovoJson;
final String utilizadorId;
final DateTime dataHora;
const AuditoriaData({required this.localId, required this.id, required this.entidade, required this.entidadeId, required this.acao, this.valorAnteriorJson, this.valorNovoJson, required this.utilizadorId, required this.dataHora});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['local_id'] = Variable<int>(localId);
map['id'] = Variable<String>(id);
map['entidade'] = Variable<String>(entidade);
map['entidade_id'] = Variable<String>(entidadeId);
map['acao'] = Variable<String>(acao);
if (!nullToAbsent || valorAnteriorJson != null){map['valor_anterior_json'] = Variable<String>(valorAnteriorJson);
}if (!nullToAbsent || valorNovoJson != null){map['valor_novo_json'] = Variable<String>(valorNovoJson);
}map['utilizador_id'] = Variable<String>(utilizadorId);
map['data_hora'] = Variable<DateTime>(dataHora);
return map; 
}
AuditoriasCompanion toCompanion(bool nullToAbsent) {
return AuditoriasCompanion(localId: Value(localId),id: Value(id),entidade: Value(entidade),entidadeId: Value(entidadeId),acao: Value(acao),valorAnteriorJson: valorAnteriorJson == null && nullToAbsent ? const Value.absent() : Value(valorAnteriorJson),valorNovoJson: valorNovoJson == null && nullToAbsent ? const Value.absent() : Value(valorNovoJson),utilizadorId: Value(utilizadorId),dataHora: Value(dataHora),);
}
factory AuditoriaData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return AuditoriaData(localId: serializer.fromJson<int>(json['localId']),id: serializer.fromJson<String>(json['id']),entidade: serializer.fromJson<String>(json['entidade']),entidadeId: serializer.fromJson<String>(json['entidadeId']),acao: serializer.fromJson<String>(json['acao']),valorAnteriorJson: serializer.fromJson<String?>(json['valorAnteriorJson']),valorNovoJson: serializer.fromJson<String?>(json['valorNovoJson']),utilizadorId: serializer.fromJson<String>(json['utilizadorId']),dataHora: serializer.fromJson<DateTime>(json['dataHora']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'localId': serializer.toJson<int>(localId),'id': serializer.toJson<String>(id),'entidade': serializer.toJson<String>(entidade),'entidadeId': serializer.toJson<String>(entidadeId),'acao': serializer.toJson<String>(acao),'valorAnteriorJson': serializer.toJson<String?>(valorAnteriorJson),'valorNovoJson': serializer.toJson<String?>(valorNovoJson),'utilizadorId': serializer.toJson<String>(utilizadorId),'dataHora': serializer.toJson<DateTime>(dataHora),};}AuditoriaData copyWith({int? localId,String? id,String? entidade,String? entidadeId,String? acao,Value<String?> valorAnteriorJson = const Value.absent(),Value<String?> valorNovoJson = const Value.absent(),String? utilizadorId,DateTime? dataHora}) => AuditoriaData(localId: localId ?? this.localId,id: id ?? this.id,entidade: entidade ?? this.entidade,entidadeId: entidadeId ?? this.entidadeId,acao: acao ?? this.acao,valorAnteriorJson: valorAnteriorJson.present ? valorAnteriorJson.value : this.valorAnteriorJson,valorNovoJson: valorNovoJson.present ? valorNovoJson.value : this.valorNovoJson,utilizadorId: utilizadorId ?? this.utilizadorId,dataHora: dataHora ?? this.dataHora,);AuditoriaData copyWithCompanion(AuditoriasCompanion data) {
return AuditoriaData(
localId: data.localId.present ? data.localId.value : this.localId,id: data.id.present ? data.id.value : this.id,entidade: data.entidade.present ? data.entidade.value : this.entidade,entidadeId: data.entidadeId.present ? data.entidadeId.value : this.entidadeId,acao: data.acao.present ? data.acao.value : this.acao,valorAnteriorJson: data.valorAnteriorJson.present ? data.valorAnteriorJson.value : this.valorAnteriorJson,valorNovoJson: data.valorNovoJson.present ? data.valorNovoJson.value : this.valorNovoJson,utilizadorId: data.utilizadorId.present ? data.utilizadorId.value : this.utilizadorId,dataHora: data.dataHora.present ? data.dataHora.value : this.dataHora,);
}
@override
String toString() {return (StringBuffer('AuditoriaData(')..write('localId: $localId, ')..write('id: $id, ')..write('entidade: $entidade, ')..write('entidadeId: $entidadeId, ')..write('acao: $acao, ')..write('valorAnteriorJson: $valorAnteriorJson, ')..write('valorNovoJson: $valorNovoJson, ')..write('utilizadorId: $utilizadorId, ')..write('dataHora: $dataHora')..write(')')).toString();}
@override
 int get hashCode => Object.hash(localId, id, entidade, entidadeId, acao, valorAnteriorJson, valorNovoJson, utilizadorId, dataHora);@override
bool operator ==(Object other) => identical(this, other) || (other is AuditoriaData && other.localId == this.localId && other.id == this.id && other.entidade == this.entidade && other.entidadeId == this.entidadeId && other.acao == this.acao && other.valorAnteriorJson == this.valorAnteriorJson && other.valorNovoJson == this.valorNovoJson && other.utilizadorId == this.utilizadorId && other.dataHora == this.dataHora);
}class AuditoriasCompanion extends UpdateCompanion<AuditoriaData> {
final Value<int> localId;
final Value<String> id;
final Value<String> entidade;
final Value<String> entidadeId;
final Value<String> acao;
final Value<String?> valorAnteriorJson;
final Value<String?> valorNovoJson;
final Value<String> utilizadorId;
final Value<DateTime> dataHora;
const AuditoriasCompanion({this.localId = const Value.absent(),this.id = const Value.absent(),this.entidade = const Value.absent(),this.entidadeId = const Value.absent(),this.acao = const Value.absent(),this.valorAnteriorJson = const Value.absent(),this.valorNovoJson = const Value.absent(),this.utilizadorId = const Value.absent(),this.dataHora = const Value.absent(),});
AuditoriasCompanion.insert({this.localId = const Value.absent(),required String id,required String entidade,required String entidadeId,required String acao,this.valorAnteriorJson = const Value.absent(),this.valorNovoJson = const Value.absent(),required String utilizadorId,required DateTime dataHora,}): id = Value(id), entidade = Value(entidade), entidadeId = Value(entidadeId), acao = Value(acao), utilizadorId = Value(utilizadorId), dataHora = Value(dataHora);
static Insertable<AuditoriaData> custom({Expression<int>? localId, 
Expression<String>? id, 
Expression<String>? entidade, 
Expression<String>? entidadeId, 
Expression<String>? acao, 
Expression<String>? valorAnteriorJson, 
Expression<String>? valorNovoJson, 
Expression<String>? utilizadorId, 
Expression<DateTime>? dataHora, 
}) {
return RawValuesInsertable({if (localId != null)'local_id': localId,if (id != null)'id': id,if (entidade != null)'entidade': entidade,if (entidadeId != null)'entidade_id': entidadeId,if (acao != null)'acao': acao,if (valorAnteriorJson != null)'valor_anterior_json': valorAnteriorJson,if (valorNovoJson != null)'valor_novo_json': valorNovoJson,if (utilizadorId != null)'utilizador_id': utilizadorId,if (dataHora != null)'data_hora': dataHora,});
}AuditoriasCompanion copyWith({Value<int>? localId, Value<String>? id, Value<String>? entidade, Value<String>? entidadeId, Value<String>? acao, Value<String?>? valorAnteriorJson, Value<String?>? valorNovoJson, Value<String>? utilizadorId, Value<DateTime>? dataHora}) {
return AuditoriasCompanion(localId: localId ?? this.localId,id: id ?? this.id,entidade: entidade ?? this.entidade,entidadeId: entidadeId ?? this.entidadeId,acao: acao ?? this.acao,valorAnteriorJson: valorAnteriorJson ?? this.valorAnteriorJson,valorNovoJson: valorNovoJson ?? this.valorNovoJson,utilizadorId: utilizadorId ?? this.utilizadorId,dataHora: dataHora ?? this.dataHora,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (id.present) {
map['id'] = Variable<String>(id.value);}
if (entidade.present) {
map['entidade'] = Variable<String>(entidade.value);}
if (entidadeId.present) {
map['entidade_id'] = Variable<String>(entidadeId.value);}
if (acao.present) {
map['acao'] = Variable<String>(acao.value);}
if (valorAnteriorJson.present) {
map['valor_anterior_json'] = Variable<String>(valorAnteriorJson.value);}
if (valorNovoJson.present) {
map['valor_novo_json'] = Variable<String>(valorNovoJson.value);}
if (utilizadorId.present) {
map['utilizador_id'] = Variable<String>(utilizadorId.value);}
if (dataHora.present) {
map['data_hora'] = Variable<DateTime>(dataHora.value);}
return map; 
}
@override
String toString() {return (StringBuffer('AuditoriasCompanion(')..write('localId: $localId, ')..write('id: $id, ')..write('entidade: $entidade, ')..write('entidadeId: $entidadeId, ')..write('acao: $acao, ')..write('valorAnteriorJson: $valorAnteriorJson, ')..write('valorNovoJson: $valorNovoJson, ')..write('utilizadorId: $utilizadorId, ')..write('dataHora: $dataHora')..write(')')).toString();}
}
class $NotificacoesInternasTable extends NotificacoesInternas with TableInfo<$NotificacoesInternasTable, NotificacoesInternaData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$NotificacoesInternasTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
@override
late final GeneratedColumn<String> titulo = GeneratedColumn<String>('titulo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _mensagemMeta = const VerificationMeta('mensagem');
@override
late final GeneratedColumn<String> mensagem = GeneratedColumn<String>('mensagem', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
@override
late final GeneratedColumn<String> tipo = GeneratedColumn<String>('tipo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _entidadeRelacionadaMeta = const VerificationMeta('entidadeRelacionada');
@override
late final GeneratedColumn<String> entidadeRelacionada = GeneratedColumn<String>('entidade_relacionada', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _entidadeIdMeta = const VerificationMeta('entidadeId');
@override
late final GeneratedColumn<String> entidadeId = GeneratedColumn<String>('entidade_id', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _lidaMeta = const VerificationMeta('lida');
@override
late final GeneratedColumn<bool> lida = GeneratedColumn<bool>('lida', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("lida" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [localId, id, titulo, mensagem, tipo, entidadeRelacionada, entidadeId, lida, createdAt];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'notificacoes_internas';
@override
VerificationContext validateIntegrity(Insertable<NotificacoesInternaData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('titulo')) {
context.handle(_tituloMeta, titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));} else if (isInserting) {
context.missing(_tituloMeta);
}
if (data.containsKey('mensagem')) {
context.handle(_mensagemMeta, mensagem.isAcceptableOrUnknown(data['mensagem']!, _mensagemMeta));} else if (isInserting) {
context.missing(_mensagemMeta);
}
if (data.containsKey('tipo')) {
context.handle(_tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));} else if (isInserting) {
context.missing(_tipoMeta);
}
if (data.containsKey('entidade_relacionada')) {
context.handle(_entidadeRelacionadaMeta, entidadeRelacionada.isAcceptableOrUnknown(data['entidade_relacionada']!, _entidadeRelacionadaMeta));}if (data.containsKey('entidade_id')) {
context.handle(_entidadeIdMeta, entidadeId.isAcceptableOrUnknown(data['entidade_id']!, _entidadeIdMeta));}if (data.containsKey('lida')) {
context.handle(_lidaMeta, lida.isAcceptableOrUnknown(data['lida']!, _lidaMeta));}if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override NotificacoesInternaData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return NotificacoesInternaData(localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, titulo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}titulo'])!, mensagem: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}mensagem'])!, tipo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tipo'])!, entidadeRelacionada: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entidade_relacionada']), entidadeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entidade_id']), lida: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}lida'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, );
}
@override
$NotificacoesInternasTable createAlias(String alias) {
return $NotificacoesInternasTable(attachedDatabase, alias);}}class NotificacoesInternaData extends DataClass implements Insertable<NotificacoesInternaData> 
{
final int localId;
final String id;
final String titulo;
final String mensagem;
final String tipo;
final String? entidadeRelacionada;
final String? entidadeId;
final bool lida;
final DateTime createdAt;
const NotificacoesInternaData({required this.localId, required this.id, required this.titulo, required this.mensagem, required this.tipo, this.entidadeRelacionada, this.entidadeId, required this.lida, required this.createdAt});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['local_id'] = Variable<int>(localId);
map['id'] = Variable<String>(id);
map['titulo'] = Variable<String>(titulo);
map['mensagem'] = Variable<String>(mensagem);
map['tipo'] = Variable<String>(tipo);
if (!nullToAbsent || entidadeRelacionada != null){map['entidade_relacionada'] = Variable<String>(entidadeRelacionada);
}if (!nullToAbsent || entidadeId != null){map['entidade_id'] = Variable<String>(entidadeId);
}map['lida'] = Variable<bool>(lida);
map['created_at'] = Variable<DateTime>(createdAt);
return map; 
}
NotificacoesInternasCompanion toCompanion(bool nullToAbsent) {
return NotificacoesInternasCompanion(localId: Value(localId),id: Value(id),titulo: Value(titulo),mensagem: Value(mensagem),tipo: Value(tipo),entidadeRelacionada: entidadeRelacionada == null && nullToAbsent ? const Value.absent() : Value(entidadeRelacionada),entidadeId: entidadeId == null && nullToAbsent ? const Value.absent() : Value(entidadeId),lida: Value(lida),createdAt: Value(createdAt),);
}
factory NotificacoesInternaData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return NotificacoesInternaData(localId: serializer.fromJson<int>(json['localId']),id: serializer.fromJson<String>(json['id']),titulo: serializer.fromJson<String>(json['titulo']),mensagem: serializer.fromJson<String>(json['mensagem']),tipo: serializer.fromJson<String>(json['tipo']),entidadeRelacionada: serializer.fromJson<String?>(json['entidadeRelacionada']),entidadeId: serializer.fromJson<String?>(json['entidadeId']),lida: serializer.fromJson<bool>(json['lida']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'localId': serializer.toJson<int>(localId),'id': serializer.toJson<String>(id),'titulo': serializer.toJson<String>(titulo),'mensagem': serializer.toJson<String>(mensagem),'tipo': serializer.toJson<String>(tipo),'entidadeRelacionada': serializer.toJson<String?>(entidadeRelacionada),'entidadeId': serializer.toJson<String?>(entidadeId),'lida': serializer.toJson<bool>(lida),'createdAt': serializer.toJson<DateTime>(createdAt),};}NotificacoesInternaData copyWith({int? localId,String? id,String? titulo,String? mensagem,String? tipo,Value<String?> entidadeRelacionada = const Value.absent(),Value<String?> entidadeId = const Value.absent(),bool? lida,DateTime? createdAt}) => NotificacoesInternaData(localId: localId ?? this.localId,id: id ?? this.id,titulo: titulo ?? this.titulo,mensagem: mensagem ?? this.mensagem,tipo: tipo ?? this.tipo,entidadeRelacionada: entidadeRelacionada.present ? entidadeRelacionada.value : this.entidadeRelacionada,entidadeId: entidadeId.present ? entidadeId.value : this.entidadeId,lida: lida ?? this.lida,createdAt: createdAt ?? this.createdAt,);NotificacoesInternaData copyWithCompanion(NotificacoesInternasCompanion data) {
return NotificacoesInternaData(
localId: data.localId.present ? data.localId.value : this.localId,id: data.id.present ? data.id.value : this.id,titulo: data.titulo.present ? data.titulo.value : this.titulo,mensagem: data.mensagem.present ? data.mensagem.value : this.mensagem,tipo: data.tipo.present ? data.tipo.value : this.tipo,entidadeRelacionada: data.entidadeRelacionada.present ? data.entidadeRelacionada.value : this.entidadeRelacionada,entidadeId: data.entidadeId.present ? data.entidadeId.value : this.entidadeId,lida: data.lida.present ? data.lida.value : this.lida,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,);
}
@override
String toString() {return (StringBuffer('NotificacoesInternaData(')..write('localId: $localId, ')..write('id: $id, ')..write('titulo: $titulo, ')..write('mensagem: $mensagem, ')..write('tipo: $tipo, ')..write('entidadeRelacionada: $entidadeRelacionada, ')..write('entidadeId: $entidadeId, ')..write('lida: $lida, ')..write('createdAt: $createdAt')..write(')')).toString();}
@override
 int get hashCode => Object.hash(localId, id, titulo, mensagem, tipo, entidadeRelacionada, entidadeId, lida, createdAt);@override
bool operator ==(Object other) => identical(this, other) || (other is NotificacoesInternaData && other.localId == this.localId && other.id == this.id && other.titulo == this.titulo && other.mensagem == this.mensagem && other.tipo == this.tipo && other.entidadeRelacionada == this.entidadeRelacionada && other.entidadeId == this.entidadeId && other.lida == this.lida && other.createdAt == this.createdAt);
}class NotificacoesInternasCompanion extends UpdateCompanion<NotificacoesInternaData> {
final Value<int> localId;
final Value<String> id;
final Value<String> titulo;
final Value<String> mensagem;
final Value<String> tipo;
final Value<String?> entidadeRelacionada;
final Value<String?> entidadeId;
final Value<bool> lida;
final Value<DateTime> createdAt;
const NotificacoesInternasCompanion({this.localId = const Value.absent(),this.id = const Value.absent(),this.titulo = const Value.absent(),this.mensagem = const Value.absent(),this.tipo = const Value.absent(),this.entidadeRelacionada = const Value.absent(),this.entidadeId = const Value.absent(),this.lida = const Value.absent(),this.createdAt = const Value.absent(),});
NotificacoesInternasCompanion.insert({this.localId = const Value.absent(),required String id,required String titulo,required String mensagem,required String tipo,this.entidadeRelacionada = const Value.absent(),this.entidadeId = const Value.absent(),this.lida = const Value.absent(),required DateTime createdAt,}): id = Value(id), titulo = Value(titulo), mensagem = Value(mensagem), tipo = Value(tipo), createdAt = Value(createdAt);
static Insertable<NotificacoesInternaData> custom({Expression<int>? localId, 
Expression<String>? id, 
Expression<String>? titulo, 
Expression<String>? mensagem, 
Expression<String>? tipo, 
Expression<String>? entidadeRelacionada, 
Expression<String>? entidadeId, 
Expression<bool>? lida, 
Expression<DateTime>? createdAt, 
}) {
return RawValuesInsertable({if (localId != null)'local_id': localId,if (id != null)'id': id,if (titulo != null)'titulo': titulo,if (mensagem != null)'mensagem': mensagem,if (tipo != null)'tipo': tipo,if (entidadeRelacionada != null)'entidade_relacionada': entidadeRelacionada,if (entidadeId != null)'entidade_id': entidadeId,if (lida != null)'lida': lida,if (createdAt != null)'created_at': createdAt,});
}NotificacoesInternasCompanion copyWith({Value<int>? localId, Value<String>? id, Value<String>? titulo, Value<String>? mensagem, Value<String>? tipo, Value<String?>? entidadeRelacionada, Value<String?>? entidadeId, Value<bool>? lida, Value<DateTime>? createdAt}) {
return NotificacoesInternasCompanion(localId: localId ?? this.localId,id: id ?? this.id,titulo: titulo ?? this.titulo,mensagem: mensagem ?? this.mensagem,tipo: tipo ?? this.tipo,entidadeRelacionada: entidadeRelacionada ?? this.entidadeRelacionada,entidadeId: entidadeId ?? this.entidadeId,lida: lida ?? this.lida,createdAt: createdAt ?? this.createdAt,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (id.present) {
map['id'] = Variable<String>(id.value);}
if (titulo.present) {
map['titulo'] = Variable<String>(titulo.value);}
if (mensagem.present) {
map['mensagem'] = Variable<String>(mensagem.value);}
if (tipo.present) {
map['tipo'] = Variable<String>(tipo.value);}
if (entidadeRelacionada.present) {
map['entidade_relacionada'] = Variable<String>(entidadeRelacionada.value);}
if (entidadeId.present) {
map['entidade_id'] = Variable<String>(entidadeId.value);}
if (lida.present) {
map['lida'] = Variable<bool>(lida.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
return map; 
}
@override
String toString() {return (StringBuffer('NotificacoesInternasCompanion(')..write('localId: $localId, ')..write('id: $id, ')..write('titulo: $titulo, ')..write('mensagem: $mensagem, ')..write('tipo: $tipo, ')..write('entidadeRelacionada: $entidadeRelacionada, ')..write('entidadeId: $entidadeId, ')..write('lida: $lida, ')..write('createdAt: $createdAt')..write(')')).toString();}
}
class $MensalidadesTable extends Mensalidades with TableInfo<$MensalidadesTable, MensalidadeData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$MensalidadesTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($MensalidadesTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _matriculaIdMeta = const VerificationMeta('matriculaId');
@override
late final GeneratedColumn<String> matriculaId = GeneratedColumn<String>('matricula_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _alunoIdMeta = const VerificationMeta('alunoId');
@override
late final GeneratedColumn<String> alunoId = GeneratedColumn<String>('aluno_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _turmaIdMeta = const VerificationMeta('turmaId');
@override
late final GeneratedColumn<String> turmaId = GeneratedColumn<String>('turma_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _turnoMeta = const VerificationMeta('turno');
@override
late final GeneratedColumn<String> turno = GeneratedColumn<String>('turno', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _mesReferenciaMeta = const VerificationMeta('mesReferencia');
@override
late final GeneratedColumn<int> mesReferencia = GeneratedColumn<int>('mes_referencia', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _anoReferenciaMeta = const VerificationMeta('anoReferencia');
@override
late final GeneratedColumn<int> anoReferencia = GeneratedColumn<int>('ano_referencia', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _valorMeta = const VerificationMeta('valor');
@override
late final GeneratedColumn<double> valor = GeneratedColumn<double>('valor', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: true);
static const VerificationMeta _dataVencimentoMeta = const VerificationMeta('dataVencimento');
@override
late final GeneratedColumn<DateTime> dataVencimento = GeneratedColumn<DateTime>('data_vencimento', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
@override
late final GeneratedColumn<String> estado = GeneratedColumn<String>('estado', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _dataPagamentoMeta = const VerificationMeta('dataPagamento');
@override
late final GeneratedColumn<DateTime> dataPagamento = GeneratedColumn<DateTime>('data_pagamento', aliasedName, true, type: DriftSqlType.dateTime, requiredDuringInsert: false);
static const VerificationMeta _observacaoMeta = const VerificationMeta('observacao');
@override
late final GeneratedColumn<String> observacao = GeneratedColumn<String>('observacao', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, matriculaId, alunoId, turmaId, turno, mesReferencia, anoReferencia, valor, dataVencimento, estado, dataPagamento, observacao];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'mensalidades';
@override
VerificationContext validateIntegrity(Insertable<MensalidadeData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('matricula_id')) {
context.handle(_matriculaIdMeta, matriculaId.isAcceptableOrUnknown(data['matricula_id']!, _matriculaIdMeta));} else if (isInserting) {
context.missing(_matriculaIdMeta);
}
if (data.containsKey('aluno_id')) {
context.handle(_alunoIdMeta, alunoId.isAcceptableOrUnknown(data['aluno_id']!, _alunoIdMeta));} else if (isInserting) {
context.missing(_alunoIdMeta);
}
if (data.containsKey('turma_id')) {
context.handle(_turmaIdMeta, turmaId.isAcceptableOrUnknown(data['turma_id']!, _turmaIdMeta));} else if (isInserting) {
context.missing(_turmaIdMeta);
}
if (data.containsKey('turno')) {
context.handle(_turnoMeta, turno.isAcceptableOrUnknown(data['turno']!, _turnoMeta));} else if (isInserting) {
context.missing(_turnoMeta);
}
if (data.containsKey('mes_referencia')) {
context.handle(_mesReferenciaMeta, mesReferencia.isAcceptableOrUnknown(data['mes_referencia']!, _mesReferenciaMeta));} else if (isInserting) {
context.missing(_mesReferenciaMeta);
}
if (data.containsKey('ano_referencia')) {
context.handle(_anoReferenciaMeta, anoReferencia.isAcceptableOrUnknown(data['ano_referencia']!, _anoReferenciaMeta));} else if (isInserting) {
context.missing(_anoReferenciaMeta);
}
if (data.containsKey('valor')) {
context.handle(_valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));} else if (isInserting) {
context.missing(_valorMeta);
}
if (data.containsKey('data_vencimento')) {
context.handle(_dataVencimentoMeta, dataVencimento.isAcceptableOrUnknown(data['data_vencimento']!, _dataVencimentoMeta));} else if (isInserting) {
context.missing(_dataVencimentoMeta);
}
if (data.containsKey('estado')) {
context.handle(_estadoMeta, estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));} else if (isInserting) {
context.missing(_estadoMeta);
}
if (data.containsKey('data_pagamento')) {
context.handle(_dataPagamentoMeta, dataPagamento.isAcceptableOrUnknown(data['data_pagamento']!, _dataPagamentoMeta));}if (data.containsKey('observacao')) {
context.handle(_observacaoMeta, observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override MensalidadeData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return MensalidadeData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $MensalidadesTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, matriculaId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}matricula_id'])!, alunoId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}aluno_id'])!, turmaId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}turma_id'])!, turno: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}turno'])!, mesReferencia: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}mes_referencia'])!, anoReferencia: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}ano_referencia'])!, valor: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}valor'])!, dataVencimento: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_vencimento'])!, estado: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}estado'])!, dataPagamento: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}data_pagamento']), observacao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}observacao']), );
}
@override
$MensalidadesTable createAlias(String alias) {
return $MensalidadesTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class MensalidadeData extends DataClass implements Insertable<MensalidadeData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String matriculaId;
final String alunoId;
final String turmaId;
final String turno;
final int mesReferencia;
final int anoReferencia;
final double valor;
final DateTime dataVencimento;
final String estado;
final DateTime? dataPagamento;
final String? observacao;
const MensalidadeData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.matriculaId, required this.alunoId, required this.turmaId, required this.turno, required this.mesReferencia, required this.anoReferencia, required this.valor, required this.dataVencimento, required this.estado, this.dataPagamento, this.observacao});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($MensalidadesTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['matricula_id'] = Variable<String>(matriculaId);
map['aluno_id'] = Variable<String>(alunoId);
map['turma_id'] = Variable<String>(turmaId);
map['turno'] = Variable<String>(turno);
map['mes_referencia'] = Variable<int>(mesReferencia);
map['ano_referencia'] = Variable<int>(anoReferencia);
map['valor'] = Variable<double>(valor);
map['data_vencimento'] = Variable<DateTime>(dataVencimento);
map['estado'] = Variable<String>(estado);
if (!nullToAbsent || dataPagamento != null){map['data_pagamento'] = Variable<DateTime>(dataPagamento);
}if (!nullToAbsent || observacao != null){map['observacao'] = Variable<String>(observacao);
}return map; 
}
MensalidadesCompanion toCompanion(bool nullToAbsent) {
return MensalidadesCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),matriculaId: Value(matriculaId),alunoId: Value(alunoId),turmaId: Value(turmaId),turno: Value(turno),mesReferencia: Value(mesReferencia),anoReferencia: Value(anoReferencia),valor: Value(valor),dataVencimento: Value(dataVencimento),estado: Value(estado),dataPagamento: dataPagamento == null && nullToAbsent ? const Value.absent() : Value(dataPagamento),observacao: observacao == null && nullToAbsent ? const Value.absent() : Value(observacao),);
}
factory MensalidadeData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return MensalidadeData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $MensalidadesTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),matriculaId: serializer.fromJson<String>(json['matriculaId']),alunoId: serializer.fromJson<String>(json['alunoId']),turmaId: serializer.fromJson<String>(json['turmaId']),turno: serializer.fromJson<String>(json['turno']),mesReferencia: serializer.fromJson<int>(json['mesReferencia']),anoReferencia: serializer.fromJson<int>(json['anoReferencia']),valor: serializer.fromJson<double>(json['valor']),dataVencimento: serializer.fromJson<DateTime>(json['dataVencimento']),estado: serializer.fromJson<String>(json['estado']),dataPagamento: serializer.fromJson<DateTime?>(json['dataPagamento']),observacao: serializer.fromJson<String?>(json['observacao']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($MensalidadesTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'matriculaId': serializer.toJson<String>(matriculaId),'alunoId': serializer.toJson<String>(alunoId),'turmaId': serializer.toJson<String>(turmaId),'turno': serializer.toJson<String>(turno),'mesReferencia': serializer.toJson<int>(mesReferencia),'anoReferencia': serializer.toJson<int>(anoReferencia),'valor': serializer.toJson<double>(valor),'dataVencimento': serializer.toJson<DateTime>(dataVencimento),'estado': serializer.toJson<String>(estado),'dataPagamento': serializer.toJson<DateTime?>(dataPagamento),'observacao': serializer.toJson<String?>(observacao),};}MensalidadeData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? matriculaId,String? alunoId,String? turmaId,String? turno,int? mesReferencia,int? anoReferencia,double? valor,DateTime? dataVencimento,String? estado,Value<DateTime?> dataPagamento = const Value.absent(),Value<String?> observacao = const Value.absent()}) => MensalidadeData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,matriculaId: matriculaId ?? this.matriculaId,alunoId: alunoId ?? this.alunoId,turmaId: turmaId ?? this.turmaId,turno: turno ?? this.turno,mesReferencia: mesReferencia ?? this.mesReferencia,anoReferencia: anoReferencia ?? this.anoReferencia,valor: valor ?? this.valor,dataVencimento: dataVencimento ?? this.dataVencimento,estado: estado ?? this.estado,dataPagamento: dataPagamento.present ? dataPagamento.value : this.dataPagamento,observacao: observacao.present ? observacao.value : this.observacao,);MensalidadeData copyWithCompanion(MensalidadesCompanion data) {
return MensalidadeData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,matriculaId: data.matriculaId.present ? data.matriculaId.value : this.matriculaId,alunoId: data.alunoId.present ? data.alunoId.value : this.alunoId,turmaId: data.turmaId.present ? data.turmaId.value : this.turmaId,turno: data.turno.present ? data.turno.value : this.turno,mesReferencia: data.mesReferencia.present ? data.mesReferencia.value : this.mesReferencia,anoReferencia: data.anoReferencia.present ? data.anoReferencia.value : this.anoReferencia,valor: data.valor.present ? data.valor.value : this.valor,dataVencimento: data.dataVencimento.present ? data.dataVencimento.value : this.dataVencimento,estado: data.estado.present ? data.estado.value : this.estado,dataPagamento: data.dataPagamento.present ? data.dataPagamento.value : this.dataPagamento,observacao: data.observacao.present ? data.observacao.value : this.observacao,);
}
@override
String toString() {return (StringBuffer('MensalidadeData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('matriculaId: $matriculaId, ')..write('alunoId: $alunoId, ')..write('turmaId: $turmaId, ')..write('turno: $turno, ')..write('mesReferencia: $mesReferencia, ')..write('anoReferencia: $anoReferencia, ')..write('valor: $valor, ')..write('dataVencimento: $dataVencimento, ')..write('estado: $estado, ')..write('dataPagamento: $dataPagamento, ')..write('observacao: $observacao')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, matriculaId, alunoId, turmaId, turno, mesReferencia, anoReferencia, valor, dataVencimento, estado, dataPagamento, observacao);@override
bool operator ==(Object other) => identical(this, other) || (other is MensalidadeData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.matriculaId == this.matriculaId && other.alunoId == this.alunoId && other.turmaId == this.turmaId && other.turno == this.turno && other.mesReferencia == this.mesReferencia && other.anoReferencia == this.anoReferencia && other.valor == this.valor && other.dataVencimento == this.dataVencimento && other.estado == this.estado && other.dataPagamento == this.dataPagamento && other.observacao == this.observacao);
}class MensalidadesCompanion extends UpdateCompanion<MensalidadeData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> matriculaId;
final Value<String> alunoId;
final Value<String> turmaId;
final Value<String> turno;
final Value<int> mesReferencia;
final Value<int> anoReferencia;
final Value<double> valor;
final Value<DateTime> dataVencimento;
final Value<String> estado;
final Value<DateTime?> dataPagamento;
final Value<String?> observacao;
const MensalidadesCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.matriculaId = const Value.absent(),this.alunoId = const Value.absent(),this.turmaId = const Value.absent(),this.turno = const Value.absent(),this.mesReferencia = const Value.absent(),this.anoReferencia = const Value.absent(),this.valor = const Value.absent(),this.dataVencimento = const Value.absent(),this.estado = const Value.absent(),this.dataPagamento = const Value.absent(),this.observacao = const Value.absent(),});
MensalidadesCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String matriculaId,required String alunoId,required String turmaId,required String turno,required int mesReferencia,required int anoReferencia,required double valor,required DateTime dataVencimento,required String estado,this.dataPagamento = const Value.absent(),this.observacao = const Value.absent(),}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), matriculaId = Value(matriculaId), alunoId = Value(alunoId), turmaId = Value(turmaId), turno = Value(turno), mesReferencia = Value(mesReferencia), anoReferencia = Value(anoReferencia), valor = Value(valor), dataVencimento = Value(dataVencimento), estado = Value(estado);
static Insertable<MensalidadeData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? matriculaId, 
Expression<String>? alunoId, 
Expression<String>? turmaId, 
Expression<String>? turno, 
Expression<int>? mesReferencia, 
Expression<int>? anoReferencia, 
Expression<double>? valor, 
Expression<DateTime>? dataVencimento, 
Expression<String>? estado, 
Expression<DateTime>? dataPagamento, 
Expression<String>? observacao, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (matriculaId != null)'matricula_id': matriculaId,if (alunoId != null)'aluno_id': alunoId,if (turmaId != null)'turma_id': turmaId,if (turno != null)'turno': turno,if (mesReferencia != null)'mes_referencia': mesReferencia,if (anoReferencia != null)'ano_referencia': anoReferencia,if (valor != null)'valor': valor,if (dataVencimento != null)'data_vencimento': dataVencimento,if (estado != null)'estado': estado,if (dataPagamento != null)'data_pagamento': dataPagamento,if (observacao != null)'observacao': observacao,});
}MensalidadesCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? matriculaId, Value<String>? alunoId, Value<String>? turmaId, Value<String>? turno, Value<int>? mesReferencia, Value<int>? anoReferencia, Value<double>? valor, Value<DateTime>? dataVencimento, Value<String>? estado, Value<DateTime?>? dataPagamento, Value<String?>? observacao}) {
return MensalidadesCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,matriculaId: matriculaId ?? this.matriculaId,alunoId: alunoId ?? this.alunoId,turmaId: turmaId ?? this.turmaId,turno: turno ?? this.turno,mesReferencia: mesReferencia ?? this.mesReferencia,anoReferencia: anoReferencia ?? this.anoReferencia,valor: valor ?? this.valor,dataVencimento: dataVencimento ?? this.dataVencimento,estado: estado ?? this.estado,dataPagamento: dataPagamento ?? this.dataPagamento,observacao: observacao ?? this.observacao,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($MensalidadesTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (matriculaId.present) {
map['matricula_id'] = Variable<String>(matriculaId.value);}
if (alunoId.present) {
map['aluno_id'] = Variable<String>(alunoId.value);}
if (turmaId.present) {
map['turma_id'] = Variable<String>(turmaId.value);}
if (turno.present) {
map['turno'] = Variable<String>(turno.value);}
if (mesReferencia.present) {
map['mes_referencia'] = Variable<int>(mesReferencia.value);}
if (anoReferencia.present) {
map['ano_referencia'] = Variable<int>(anoReferencia.value);}
if (valor.present) {
map['valor'] = Variable<double>(valor.value);}
if (dataVencimento.present) {
map['data_vencimento'] = Variable<DateTime>(dataVencimento.value);}
if (estado.present) {
map['estado'] = Variable<String>(estado.value);}
if (dataPagamento.present) {
map['data_pagamento'] = Variable<DateTime>(dataPagamento.value);}
if (observacao.present) {
map['observacao'] = Variable<String>(observacao.value);}
return map; 
}
@override
String toString() {return (StringBuffer('MensalidadesCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('matriculaId: $matriculaId, ')..write('alunoId: $alunoId, ')..write('turmaId: $turmaId, ')..write('turno: $turno, ')..write('mesReferencia: $mesReferencia, ')..write('anoReferencia: $anoReferencia, ')..write('valor: $valor, ')..write('dataVencimento: $dataVencimento, ')..write('estado: $estado, ')..write('dataPagamento: $dataPagamento, ')..write('observacao: $observacao')..write(')')).toString();}
}
class $ConfiguracoesTable extends Configuracoes with TableInfo<$ConfiguracoesTable, ConfiguracaoData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$ConfiguracoesTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
@override
late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>('updated_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($ConfiguracoesTable.$convertersyncStatus);
static const VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
@override
late final GeneratedColumn<String> createdBy = GeneratedColumn<String>('created_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _updatedByMeta = const VerificationMeta('updatedBy');
@override
late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>('updated_by', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
@override
late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'), defaultValue: const Constant(false));
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _nomeInstituicaoMeta = const VerificationMeta('nomeInstituicao');
@override
late final GeneratedColumn<String> nomeInstituicao = GeneratedColumn<String>('nome_instituicao', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _logotipoUrlMeta = const VerificationMeta('logotipoUrl');
@override
late final GeneratedColumn<String> logotipoUrl = GeneratedColumn<String>('logotipo_url', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _moradaMeta = const VerificationMeta('morada');
@override
late final GeneratedColumn<String> morada = GeneratedColumn<String>('morada', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _telefoneMeta = const VerificationMeta('telefone');
@override
late final GeneratedColumn<String> telefone = GeneratedColumn<String>('telefone', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _emailMeta = const VerificationMeta('email');
@override
late final GeneratedColumn<String> email = GeneratedColumn<String>('email', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _nifMeta = const VerificationMeta('nif');
@override
late final GeneratedColumn<String> nif = GeneratedColumn<String>('nif', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _moedaPadraoMeta = const VerificationMeta('moedaPadrao');
@override
late final GeneratedColumn<String> moedaPadrao = GeneratedColumn<String>('moeda_padrao', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _textoRodapeRelatorioMeta = const VerificationMeta('textoRodapeRelatorio');
@override
late final GeneratedColumn<String> textoRodapeRelatorio = GeneratedColumn<String>('texto_rodape_relatorio', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _reciboPrefixoMeta = const VerificationMeta('reciboPrefixo');
@override
late final GeneratedColumn<String> reciboPrefixo = GeneratedColumn<String>('recibo_prefixo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, nomeInstituicao, logotipoUrl, morada, telefone, email, nif, moedaPadrao, textoRodapeRelatorio, reciboPrefixo];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'configuracoes';
@override
VerificationContext validateIntegrity(Insertable<ConfiguracaoData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
if (data.containsKey('updated_at')) {
context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));} else if (isInserting) {
context.missing(_updatedAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());if (data.containsKey('created_by')) {
context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));}if (data.containsKey('updated_by')) {
context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));}if (data.containsKey('is_deleted')) {
context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));}if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('nome_instituicao')) {
context.handle(_nomeInstituicaoMeta, nomeInstituicao.isAcceptableOrUnknown(data['nome_instituicao']!, _nomeInstituicaoMeta));} else if (isInserting) {
context.missing(_nomeInstituicaoMeta);
}
if (data.containsKey('logotipo_url')) {
context.handle(_logotipoUrlMeta, logotipoUrl.isAcceptableOrUnknown(data['logotipo_url']!, _logotipoUrlMeta));}if (data.containsKey('morada')) {
context.handle(_moradaMeta, morada.isAcceptableOrUnknown(data['morada']!, _moradaMeta));} else if (isInserting) {
context.missing(_moradaMeta);
}
if (data.containsKey('telefone')) {
context.handle(_telefoneMeta, telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta));} else if (isInserting) {
context.missing(_telefoneMeta);
}
if (data.containsKey('email')) {
context.handle(_emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));} else if (isInserting) {
context.missing(_emailMeta);
}
if (data.containsKey('nif')) {
context.handle(_nifMeta, nif.isAcceptableOrUnknown(data['nif']!, _nifMeta));} else if (isInserting) {
context.missing(_nifMeta);
}
if (data.containsKey('moeda_padrao')) {
context.handle(_moedaPadraoMeta, moedaPadrao.isAcceptableOrUnknown(data['moeda_padrao']!, _moedaPadraoMeta));} else if (isInserting) {
context.missing(_moedaPadraoMeta);
}
if (data.containsKey('texto_rodape_relatorio')) {
context.handle(_textoRodapeRelatorioMeta, textoRodapeRelatorio.isAcceptableOrUnknown(data['texto_rodape_relatorio']!, _textoRodapeRelatorioMeta));} else if (isInserting) {
context.missing(_textoRodapeRelatorioMeta);
}
if (data.containsKey('recibo_prefixo')) {
context.handle(_reciboPrefixoMeta, reciboPrefixo.isAcceptableOrUnknown(data['recibo_prefixo']!, _reciboPrefixoMeta));} else if (isInserting) {
context.missing(_reciboPrefixoMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override ConfiguracaoData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return ConfiguracaoData(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!, syncStatus: $ConfiguracoesTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), createdBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}created_by']), updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}updated_by']), isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!, localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, nomeInstituicao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nome_instituicao'])!, logotipoUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}logotipo_url']), morada: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}morada'])!, telefone: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}telefone'])!, email: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}email'])!, nif: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nif'])!, moedaPadrao: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}moeda_padrao'])!, textoRodapeRelatorio: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}texto_rodape_relatorio'])!, reciboPrefixo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}recibo_prefixo'])!, );
}
@override
$ConfiguracoesTable createAlias(String alias) {
return $ConfiguracoesTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class ConfiguracaoData extends DataClass implements Insertable<ConfiguracaoData> 
{
final String id;
final DateTime createdAt;
final DateTime updatedAt;
final SyncStatus syncStatus;
final String? createdBy;
final String? updatedBy;
final bool isDeleted;
final int localId;
final String nomeInstituicao;
final String? logotipoUrl;
final String morada;
final String telefone;
final String email;
final String nif;
final String moedaPadrao;
final String textoRodapeRelatorio;
final String reciboPrefixo;
const ConfiguracaoData({required this.id, required this.createdAt, required this.updatedAt, required this.syncStatus, this.createdBy, this.updatedBy, required this.isDeleted, required this.localId, required this.nomeInstituicao, this.logotipoUrl, required this.morada, required this.telefone, required this.email, required this.nif, required this.moedaPadrao, required this.textoRodapeRelatorio, required this.reciboPrefixo});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['created_at'] = Variable<DateTime>(createdAt);
map['updated_at'] = Variable<DateTime>(updatedAt);
{map['sync_status'] = Variable<int>($ConfiguracoesTable.$convertersyncStatus.toSql(syncStatus));
}if (!nullToAbsent || createdBy != null){map['created_by'] = Variable<String>(createdBy);
}if (!nullToAbsent || updatedBy != null){map['updated_by'] = Variable<String>(updatedBy);
}map['is_deleted'] = Variable<bool>(isDeleted);
map['local_id'] = Variable<int>(localId);
map['nome_instituicao'] = Variable<String>(nomeInstituicao);
if (!nullToAbsent || logotipoUrl != null){map['logotipo_url'] = Variable<String>(logotipoUrl);
}map['morada'] = Variable<String>(morada);
map['telefone'] = Variable<String>(telefone);
map['email'] = Variable<String>(email);
map['nif'] = Variable<String>(nif);
map['moeda_padrao'] = Variable<String>(moedaPadrao);
map['texto_rodape_relatorio'] = Variable<String>(textoRodapeRelatorio);
map['recibo_prefixo'] = Variable<String>(reciboPrefixo);
return map; 
}
ConfiguracoesCompanion toCompanion(bool nullToAbsent) {
return ConfiguracoesCompanion(id: Value(id),createdAt: Value(createdAt),updatedAt: Value(updatedAt),syncStatus: Value(syncStatus),createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),isDeleted: Value(isDeleted),localId: Value(localId),nomeInstituicao: Value(nomeInstituicao),logotipoUrl: logotipoUrl == null && nullToAbsent ? const Value.absent() : Value(logotipoUrl),morada: Value(morada),telefone: Value(telefone),email: Value(email),nif: Value(nif),moedaPadrao: Value(moedaPadrao),textoRodapeRelatorio: Value(textoRodapeRelatorio),reciboPrefixo: Value(reciboPrefixo),);
}
factory ConfiguracaoData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return ConfiguracaoData(id: serializer.fromJson<String>(json['id']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),syncStatus: $ConfiguracoesTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),createdBy: serializer.fromJson<String?>(json['createdBy']),updatedBy: serializer.fromJson<String?>(json['updatedBy']),isDeleted: serializer.fromJson<bool>(json['isDeleted']),localId: serializer.fromJson<int>(json['localId']),nomeInstituicao: serializer.fromJson<String>(json['nomeInstituicao']),logotipoUrl: serializer.fromJson<String?>(json['logotipoUrl']),morada: serializer.fromJson<String>(json['morada']),telefone: serializer.fromJson<String>(json['telefone']),email: serializer.fromJson<String>(json['email']),nif: serializer.fromJson<String>(json['nif']),moedaPadrao: serializer.fromJson<String>(json['moedaPadrao']),textoRodapeRelatorio: serializer.fromJson<String>(json['textoRodapeRelatorio']),reciboPrefixo: serializer.fromJson<String>(json['reciboPrefixo']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'createdAt': serializer.toJson<DateTime>(createdAt),'updatedAt': serializer.toJson<DateTime>(updatedAt),'syncStatus': serializer.toJson<int>($ConfiguracoesTable.$convertersyncStatus.toJson(syncStatus)),'createdBy': serializer.toJson<String?>(createdBy),'updatedBy': serializer.toJson<String?>(updatedBy),'isDeleted': serializer.toJson<bool>(isDeleted),'localId': serializer.toJson<int>(localId),'nomeInstituicao': serializer.toJson<String>(nomeInstituicao),'logotipoUrl': serializer.toJson<String?>(logotipoUrl),'morada': serializer.toJson<String>(morada),'telefone': serializer.toJson<String>(telefone),'email': serializer.toJson<String>(email),'nif': serializer.toJson<String>(nif),'moedaPadrao': serializer.toJson<String>(moedaPadrao),'textoRodapeRelatorio': serializer.toJson<String>(textoRodapeRelatorio),'reciboPrefixo': serializer.toJson<String>(reciboPrefixo),};}ConfiguracaoData copyWith({String? id,DateTime? createdAt,DateTime? updatedAt,SyncStatus? syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),bool? isDeleted,int? localId,String? nomeInstituicao,Value<String?> logotipoUrl = const Value.absent(),String? morada,String? telefone,String? email,String? nif,String? moedaPadrao,String? textoRodapeRelatorio,String? reciboPrefixo}) => ConfiguracaoData(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy.present ? createdBy.value : this.createdBy,updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,nomeInstituicao: nomeInstituicao ?? this.nomeInstituicao,logotipoUrl: logotipoUrl.present ? logotipoUrl.value : this.logotipoUrl,morada: morada ?? this.morada,telefone: telefone ?? this.telefone,email: email ?? this.email,nif: nif ?? this.nif,moedaPadrao: moedaPadrao ?? this.moedaPadrao,textoRodapeRelatorio: textoRodapeRelatorio ?? this.textoRodapeRelatorio,reciboPrefixo: reciboPrefixo ?? this.reciboPrefixo,);ConfiguracaoData copyWithCompanion(ConfiguracoesCompanion data) {
return ConfiguracaoData(
id: data.id.present ? data.id.value : this.id,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,localId: data.localId.present ? data.localId.value : this.localId,nomeInstituicao: data.nomeInstituicao.present ? data.nomeInstituicao.value : this.nomeInstituicao,logotipoUrl: data.logotipoUrl.present ? data.logotipoUrl.value : this.logotipoUrl,morada: data.morada.present ? data.morada.value : this.morada,telefone: data.telefone.present ? data.telefone.value : this.telefone,email: data.email.present ? data.email.value : this.email,nif: data.nif.present ? data.nif.value : this.nif,moedaPadrao: data.moedaPadrao.present ? data.moedaPadrao.value : this.moedaPadrao,textoRodapeRelatorio: data.textoRodapeRelatorio.present ? data.textoRodapeRelatorio.value : this.textoRodapeRelatorio,reciboPrefixo: data.reciboPrefixo.present ? data.reciboPrefixo.value : this.reciboPrefixo,);
}
@override
String toString() {return (StringBuffer('ConfiguracaoData(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('nomeInstituicao: $nomeInstituicao, ')..write('logotipoUrl: $logotipoUrl, ')..write('morada: $morada, ')..write('telefone: $telefone, ')..write('email: $email, ')..write('nif: $nif, ')..write('moedaPadrao: $moedaPadrao, ')..write('textoRodapeRelatorio: $textoRodapeRelatorio, ')..write('reciboPrefixo: $reciboPrefixo')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, createdAt, updatedAt, syncStatus, createdBy, updatedBy, isDeleted, localId, nomeInstituicao, logotipoUrl, morada, telefone, email, nif, moedaPadrao, textoRodapeRelatorio, reciboPrefixo);@override
bool operator ==(Object other) => identical(this, other) || (other is ConfiguracaoData && other.id == this.id && other.createdAt == this.createdAt && other.updatedAt == this.updatedAt && other.syncStatus == this.syncStatus && other.createdBy == this.createdBy && other.updatedBy == this.updatedBy && other.isDeleted == this.isDeleted && other.localId == this.localId && other.nomeInstituicao == this.nomeInstituicao && other.logotipoUrl == this.logotipoUrl && other.morada == this.morada && other.telefone == this.telefone && other.email == this.email && other.nif == this.nif && other.moedaPadrao == this.moedaPadrao && other.textoRodapeRelatorio == this.textoRodapeRelatorio && other.reciboPrefixo == this.reciboPrefixo);
}class ConfiguracoesCompanion extends UpdateCompanion<ConfiguracaoData> {
final Value<String> id;
final Value<DateTime> createdAt;
final Value<DateTime> updatedAt;
final Value<SyncStatus> syncStatus;
final Value<String?> createdBy;
final Value<String?> updatedBy;
final Value<bool> isDeleted;
final Value<int> localId;
final Value<String> nomeInstituicao;
final Value<String?> logotipoUrl;
final Value<String> morada;
final Value<String> telefone;
final Value<String> email;
final Value<String> nif;
final Value<String> moedaPadrao;
final Value<String> textoRodapeRelatorio;
final Value<String> reciboPrefixo;
const ConfiguracoesCompanion({this.id = const Value.absent(),this.createdAt = const Value.absent(),this.updatedAt = const Value.absent(),this.syncStatus = const Value.absent(),this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),this.nomeInstituicao = const Value.absent(),this.logotipoUrl = const Value.absent(),this.morada = const Value.absent(),this.telefone = const Value.absent(),this.email = const Value.absent(),this.nif = const Value.absent(),this.moedaPadrao = const Value.absent(),this.textoRodapeRelatorio = const Value.absent(),this.reciboPrefixo = const Value.absent(),});
ConfiguracoesCompanion.insert({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,this.createdBy = const Value.absent(),this.updatedBy = const Value.absent(),this.isDeleted = const Value.absent(),this.localId = const Value.absent(),required String nomeInstituicao,this.logotipoUrl = const Value.absent(),required String morada,required String telefone,required String email,required String nif,required String moedaPadrao,required String textoRodapeRelatorio,required String reciboPrefixo,}): id = Value(id), createdAt = Value(createdAt), updatedAt = Value(updatedAt), syncStatus = Value(syncStatus), nomeInstituicao = Value(nomeInstituicao), morada = Value(morada), telefone = Value(telefone), email = Value(email), nif = Value(nif), moedaPadrao = Value(moedaPadrao), textoRodapeRelatorio = Value(textoRodapeRelatorio), reciboPrefixo = Value(reciboPrefixo);
static Insertable<ConfiguracaoData> custom({Expression<String>? id, 
Expression<DateTime>? createdAt, 
Expression<DateTime>? updatedAt, 
Expression<int>? syncStatus, 
Expression<String>? createdBy, 
Expression<String>? updatedBy, 
Expression<bool>? isDeleted, 
Expression<int>? localId, 
Expression<String>? nomeInstituicao, 
Expression<String>? logotipoUrl, 
Expression<String>? morada, 
Expression<String>? telefone, 
Expression<String>? email, 
Expression<String>? nif, 
Expression<String>? moedaPadrao, 
Expression<String>? textoRodapeRelatorio, 
Expression<String>? reciboPrefixo, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (createdAt != null)'created_at': createdAt,if (updatedAt != null)'updated_at': updatedAt,if (syncStatus != null)'sync_status': syncStatus,if (createdBy != null)'created_by': createdBy,if (updatedBy != null)'updated_by': updatedBy,if (isDeleted != null)'is_deleted': isDeleted,if (localId != null)'local_id': localId,if (nomeInstituicao != null)'nome_instituicao': nomeInstituicao,if (logotipoUrl != null)'logotipo_url': logotipoUrl,if (morada != null)'morada': morada,if (telefone != null)'telefone': telefone,if (email != null)'email': email,if (nif != null)'nif': nif,if (moedaPadrao != null)'moeda_padrao': moedaPadrao,if (textoRodapeRelatorio != null)'texto_rodape_relatorio': textoRodapeRelatorio,if (reciboPrefixo != null)'recibo_prefixo': reciboPrefixo,});
}ConfiguracoesCompanion copyWith({Value<String>? id, Value<DateTime>? createdAt, Value<DateTime>? updatedAt, Value<SyncStatus>? syncStatus, Value<String?>? createdBy, Value<String?>? updatedBy, Value<bool>? isDeleted, Value<int>? localId, Value<String>? nomeInstituicao, Value<String?>? logotipoUrl, Value<String>? morada, Value<String>? telefone, Value<String>? email, Value<String>? nif, Value<String>? moedaPadrao, Value<String>? textoRodapeRelatorio, Value<String>? reciboPrefixo}) {
return ConfiguracoesCompanion(id: id ?? this.id,createdAt: createdAt ?? this.createdAt,updatedAt: updatedAt ?? this.updatedAt,syncStatus: syncStatus ?? this.syncStatus,createdBy: createdBy ?? this.createdBy,updatedBy: updatedBy ?? this.updatedBy,isDeleted: isDeleted ?? this.isDeleted,localId: localId ?? this.localId,nomeInstituicao: nomeInstituicao ?? this.nomeInstituicao,logotipoUrl: logotipoUrl ?? this.logotipoUrl,morada: morada ?? this.morada,telefone: telefone ?? this.telefone,email: email ?? this.email,nif: nif ?? this.nif,moedaPadrao: moedaPadrao ?? this.moedaPadrao,textoRodapeRelatorio: textoRodapeRelatorio ?? this.textoRodapeRelatorio,reciboPrefixo: reciboPrefixo ?? this.reciboPrefixo,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (updatedAt.present) {
map['updated_at'] = Variable<DateTime>(updatedAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($ConfiguracoesTable.$convertersyncStatus.toSql(syncStatus.value));}
if (createdBy.present) {
map['created_by'] = Variable<String>(createdBy.value);}
if (updatedBy.present) {
map['updated_by'] = Variable<String>(updatedBy.value);}
if (isDeleted.present) {
map['is_deleted'] = Variable<bool>(isDeleted.value);}
if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (nomeInstituicao.present) {
map['nome_instituicao'] = Variable<String>(nomeInstituicao.value);}
if (logotipoUrl.present) {
map['logotipo_url'] = Variable<String>(logotipoUrl.value);}
if (morada.present) {
map['morada'] = Variable<String>(morada.value);}
if (telefone.present) {
map['telefone'] = Variable<String>(telefone.value);}
if (email.present) {
map['email'] = Variable<String>(email.value);}
if (nif.present) {
map['nif'] = Variable<String>(nif.value);}
if (moedaPadrao.present) {
map['moeda_padrao'] = Variable<String>(moedaPadrao.value);}
if (textoRodapeRelatorio.present) {
map['texto_rodape_relatorio'] = Variable<String>(textoRodapeRelatorio.value);}
if (reciboPrefixo.present) {
map['recibo_prefixo'] = Variable<String>(reciboPrefixo.value);}
return map; 
}
@override
String toString() {return (StringBuffer('ConfiguracoesCompanion(')..write('id: $id, ')..write('createdAt: $createdAt, ')..write('updatedAt: $updatedAt, ')..write('syncStatus: $syncStatus, ')..write('createdBy: $createdBy, ')..write('updatedBy: $updatedBy, ')..write('isDeleted: $isDeleted, ')..write('localId: $localId, ')..write('nomeInstituicao: $nomeInstituicao, ')..write('logotipoUrl: $logotipoUrl, ')..write('morada: $morada, ')..write('telefone: $telefone, ')..write('email: $email, ')..write('nif: $nif, ')..write('moedaPadrao: $moedaPadrao, ')..write('textoRodapeRelatorio: $textoRodapeRelatorio, ')..write('reciboPrefixo: $reciboPrefixo')..write(')')).toString();}
}
class $EvidenciaPagamentosTable extends EvidenciaPagamentos with TableInfo<$EvidenciaPagamentosTable, EvidenciaPagamentoData>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$EvidenciaPagamentosTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _localIdMeta = const VerificationMeta('localId');
@override
late final GeneratedColumn<int> localId = GeneratedColumn<int>('local_id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
static const VerificationMeta _tipoArquivoMeta = const VerificationMeta('tipoArquivo');
@override
late final GeneratedColumn<String> tipoArquivo = GeneratedColumn<String>('tipo_arquivo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _nomeArquivoMeta = const VerificationMeta('nomeArquivo');
@override
late final GeneratedColumn<String> nomeArquivo = GeneratedColumn<String>('nome_arquivo', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _urlRemotaMeta = const VerificationMeta('urlRemota');
@override
late final GeneratedColumn<String> urlRemota = GeneratedColumn<String>('url_remota', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _caminhoLocalMeta = const VerificationMeta('caminhoLocal');
@override
late final GeneratedColumn<String> caminhoLocal = GeneratedColumn<String>('caminho_local', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _tamanhoBytesMeta = const VerificationMeta('tamanhoBytes');
@override
late final GeneratedColumn<int> tamanhoBytes = GeneratedColumn<int>('tamanho_bytes', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
static const VerificationMeta _mimeTypeMeta = const VerificationMeta('mimeType');
@override
late final GeneratedColumn<String> mimeType = GeneratedColumn<String>('mime_type', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _syncStatusMeta = const VerificationMeta('syncStatus');
@override
late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus = GeneratedColumn<int>('sync_status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true).withConverter<SyncStatus>($EvidenciaPagamentosTable.$convertersyncStatus);
@override
List<GeneratedColumn> get $columns => [localId, id, tipoArquivo, nomeArquivo, urlRemota, caminhoLocal, tamanhoBytes, mimeType, createdAt, syncStatus];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'evidencia_pagamentos';
@override
VerificationContext validateIntegrity(Insertable<EvidenciaPagamentoData> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('local_id')) {
context.handle(_localIdMeta, localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));}if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('tipo_arquivo')) {
context.handle(_tipoArquivoMeta, tipoArquivo.isAcceptableOrUnknown(data['tipo_arquivo']!, _tipoArquivoMeta));} else if (isInserting) {
context.missing(_tipoArquivoMeta);
}
if (data.containsKey('nome_arquivo')) {
context.handle(_nomeArquivoMeta, nomeArquivo.isAcceptableOrUnknown(data['nome_arquivo']!, _nomeArquivoMeta));} else if (isInserting) {
context.missing(_nomeArquivoMeta);
}
if (data.containsKey('url_remota')) {
context.handle(_urlRemotaMeta, urlRemota.isAcceptableOrUnknown(data['url_remota']!, _urlRemotaMeta));}if (data.containsKey('caminho_local')) {
context.handle(_caminhoLocalMeta, caminhoLocal.isAcceptableOrUnknown(data['caminho_local']!, _caminhoLocalMeta));} else if (isInserting) {
context.missing(_caminhoLocalMeta);
}
if (data.containsKey('tamanho_bytes')) {
context.handle(_tamanhoBytesMeta, tamanhoBytes.isAcceptableOrUnknown(data['tamanho_bytes']!, _tamanhoBytesMeta));} else if (isInserting) {
context.missing(_tamanhoBytesMeta);
}
if (data.containsKey('mime_type')) {
context.handle(_mimeTypeMeta, mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));} else if (isInserting) {
context.missing(_mimeTypeMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));} else if (isInserting) {
context.missing(_createdAtMeta);
}
context.handle(_syncStatusMeta, const VerificationResult.success());return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {localId};
@override EvidenciaPagamentoData map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return EvidenciaPagamentoData(localId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}local_id'])!, id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, tipoArquivo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}tipo_arquivo'])!, nomeArquivo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}nome_arquivo'])!, urlRemota: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url_remota']), caminhoLocal: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}caminho_local'])!, tamanhoBytes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}tamanho_bytes'])!, mimeType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}mime_type'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, syncStatus: $EvidenciaPagamentosTable.$convertersyncStatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!), );
}
@override
$EvidenciaPagamentosTable createAlias(String alias) {
return $EvidenciaPagamentosTable(attachedDatabase, alias);}static JsonTypeConverter2<SyncStatus,int,int> $convertersyncStatus = const EnumIndexConverter<SyncStatus>(SyncStatus.values);}class EvidenciaPagamentoData extends DataClass implements Insertable<EvidenciaPagamentoData> 
{
final int localId;
final String id;
final String tipoArquivo;
final String nomeArquivo;
final String? urlRemota;
final String caminhoLocal;
final int tamanhoBytes;
final String mimeType;
final DateTime createdAt;
final SyncStatus syncStatus;
const EvidenciaPagamentoData({required this.localId, required this.id, required this.tipoArquivo, required this.nomeArquivo, this.urlRemota, required this.caminhoLocal, required this.tamanhoBytes, required this.mimeType, required this.createdAt, required this.syncStatus});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['local_id'] = Variable<int>(localId);
map['id'] = Variable<String>(id);
map['tipo_arquivo'] = Variable<String>(tipoArquivo);
map['nome_arquivo'] = Variable<String>(nomeArquivo);
if (!nullToAbsent || urlRemota != null){map['url_remota'] = Variable<String>(urlRemota);
}map['caminho_local'] = Variable<String>(caminhoLocal);
map['tamanho_bytes'] = Variable<int>(tamanhoBytes);
map['mime_type'] = Variable<String>(mimeType);
map['created_at'] = Variable<DateTime>(createdAt);
{map['sync_status'] = Variable<int>($EvidenciaPagamentosTable.$convertersyncStatus.toSql(syncStatus));
}return map; 
}
EvidenciaPagamentosCompanion toCompanion(bool nullToAbsent) {
return EvidenciaPagamentosCompanion(localId: Value(localId),id: Value(id),tipoArquivo: Value(tipoArquivo),nomeArquivo: Value(nomeArquivo),urlRemota: urlRemota == null && nullToAbsent ? const Value.absent() : Value(urlRemota),caminhoLocal: Value(caminhoLocal),tamanhoBytes: Value(tamanhoBytes),mimeType: Value(mimeType),createdAt: Value(createdAt),syncStatus: Value(syncStatus),);
}
factory EvidenciaPagamentoData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return EvidenciaPagamentoData(localId: serializer.fromJson<int>(json['localId']),id: serializer.fromJson<String>(json['id']),tipoArquivo: serializer.fromJson<String>(json['tipoArquivo']),nomeArquivo: serializer.fromJson<String>(json['nomeArquivo']),urlRemota: serializer.fromJson<String?>(json['urlRemota']),caminhoLocal: serializer.fromJson<String>(json['caminhoLocal']),tamanhoBytes: serializer.fromJson<int>(json['tamanhoBytes']),mimeType: serializer.fromJson<String>(json['mimeType']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),syncStatus: $EvidenciaPagamentosTable.$convertersyncStatus.fromJson(serializer.fromJson<int>(json['syncStatus'])),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'localId': serializer.toJson<int>(localId),'id': serializer.toJson<String>(id),'tipoArquivo': serializer.toJson<String>(tipoArquivo),'nomeArquivo': serializer.toJson<String>(nomeArquivo),'urlRemota': serializer.toJson<String?>(urlRemota),'caminhoLocal': serializer.toJson<String>(caminhoLocal),'tamanhoBytes': serializer.toJson<int>(tamanhoBytes),'mimeType': serializer.toJson<String>(mimeType),'createdAt': serializer.toJson<DateTime>(createdAt),'syncStatus': serializer.toJson<int>($EvidenciaPagamentosTable.$convertersyncStatus.toJson(syncStatus)),};}EvidenciaPagamentoData copyWith({int? localId,String? id,String? tipoArquivo,String? nomeArquivo,Value<String?> urlRemota = const Value.absent(),String? caminhoLocal,int? tamanhoBytes,String? mimeType,DateTime? createdAt,SyncStatus? syncStatus}) => EvidenciaPagamentoData(localId: localId ?? this.localId,id: id ?? this.id,tipoArquivo: tipoArquivo ?? this.tipoArquivo,nomeArquivo: nomeArquivo ?? this.nomeArquivo,urlRemota: urlRemota.present ? urlRemota.value : this.urlRemota,caminhoLocal: caminhoLocal ?? this.caminhoLocal,tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,mimeType: mimeType ?? this.mimeType,createdAt: createdAt ?? this.createdAt,syncStatus: syncStatus ?? this.syncStatus,);EvidenciaPagamentoData copyWithCompanion(EvidenciaPagamentosCompanion data) {
return EvidenciaPagamentoData(
localId: data.localId.present ? data.localId.value : this.localId,id: data.id.present ? data.id.value : this.id,tipoArquivo: data.tipoArquivo.present ? data.tipoArquivo.value : this.tipoArquivo,nomeArquivo: data.nomeArquivo.present ? data.nomeArquivo.value : this.nomeArquivo,urlRemota: data.urlRemota.present ? data.urlRemota.value : this.urlRemota,caminhoLocal: data.caminhoLocal.present ? data.caminhoLocal.value : this.caminhoLocal,tamanhoBytes: data.tamanhoBytes.present ? data.tamanhoBytes.value : this.tamanhoBytes,mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,syncStatus: data.syncStatus.present ? data.syncStatus.value : this.syncStatus,);
}
@override
String toString() {return (StringBuffer('EvidenciaPagamentoData(')..write('localId: $localId, ')..write('id: $id, ')..write('tipoArquivo: $tipoArquivo, ')..write('nomeArquivo: $nomeArquivo, ')..write('urlRemota: $urlRemota, ')..write('caminhoLocal: $caminhoLocal, ')..write('tamanhoBytes: $tamanhoBytes, ')..write('mimeType: $mimeType, ')..write('createdAt: $createdAt, ')..write('syncStatus: $syncStatus')..write(')')).toString();}
@override
 int get hashCode => Object.hash(localId, id, tipoArquivo, nomeArquivo, urlRemota, caminhoLocal, tamanhoBytes, mimeType, createdAt, syncStatus);@override
bool operator ==(Object other) => identical(this, other) || (other is EvidenciaPagamentoData && other.localId == this.localId && other.id == this.id && other.tipoArquivo == this.tipoArquivo && other.nomeArquivo == this.nomeArquivo && other.urlRemota == this.urlRemota && other.caminhoLocal == this.caminhoLocal && other.tamanhoBytes == this.tamanhoBytes && other.mimeType == this.mimeType && other.createdAt == this.createdAt && other.syncStatus == this.syncStatus);
}class EvidenciaPagamentosCompanion extends UpdateCompanion<EvidenciaPagamentoData> {
final Value<int> localId;
final Value<String> id;
final Value<String> tipoArquivo;
final Value<String> nomeArquivo;
final Value<String?> urlRemota;
final Value<String> caminhoLocal;
final Value<int> tamanhoBytes;
final Value<String> mimeType;
final Value<DateTime> createdAt;
final Value<SyncStatus> syncStatus;
const EvidenciaPagamentosCompanion({this.localId = const Value.absent(),this.id = const Value.absent(),this.tipoArquivo = const Value.absent(),this.nomeArquivo = const Value.absent(),this.urlRemota = const Value.absent(),this.caminhoLocal = const Value.absent(),this.tamanhoBytes = const Value.absent(),this.mimeType = const Value.absent(),this.createdAt = const Value.absent(),this.syncStatus = const Value.absent(),});
EvidenciaPagamentosCompanion.insert({this.localId = const Value.absent(),required String id,required String tipoArquivo,required String nomeArquivo,this.urlRemota = const Value.absent(),required String caminhoLocal,required int tamanhoBytes,required String mimeType,required DateTime createdAt,required SyncStatus syncStatus,}): id = Value(id), tipoArquivo = Value(tipoArquivo), nomeArquivo = Value(nomeArquivo), caminhoLocal = Value(caminhoLocal), tamanhoBytes = Value(tamanhoBytes), mimeType = Value(mimeType), createdAt = Value(createdAt), syncStatus = Value(syncStatus);
static Insertable<EvidenciaPagamentoData> custom({Expression<int>? localId, 
Expression<String>? id, 
Expression<String>? tipoArquivo, 
Expression<String>? nomeArquivo, 
Expression<String>? urlRemota, 
Expression<String>? caminhoLocal, 
Expression<int>? tamanhoBytes, 
Expression<String>? mimeType, 
Expression<DateTime>? createdAt, 
Expression<int>? syncStatus, 
}) {
return RawValuesInsertable({if (localId != null)'local_id': localId,if (id != null)'id': id,if (tipoArquivo != null)'tipo_arquivo': tipoArquivo,if (nomeArquivo != null)'nome_arquivo': nomeArquivo,if (urlRemota != null)'url_remota': urlRemota,if (caminhoLocal != null)'caminho_local': caminhoLocal,if (tamanhoBytes != null)'tamanho_bytes': tamanhoBytes,if (mimeType != null)'mime_type': mimeType,if (createdAt != null)'created_at': createdAt,if (syncStatus != null)'sync_status': syncStatus,});
}EvidenciaPagamentosCompanion copyWith({Value<int>? localId, Value<String>? id, Value<String>? tipoArquivo, Value<String>? nomeArquivo, Value<String?>? urlRemota, Value<String>? caminhoLocal, Value<int>? tamanhoBytes, Value<String>? mimeType, Value<DateTime>? createdAt, Value<SyncStatus>? syncStatus}) {
return EvidenciaPagamentosCompanion(localId: localId ?? this.localId,id: id ?? this.id,tipoArquivo: tipoArquivo ?? this.tipoArquivo,nomeArquivo: nomeArquivo ?? this.nomeArquivo,urlRemota: urlRemota ?? this.urlRemota,caminhoLocal: caminhoLocal ?? this.caminhoLocal,tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,mimeType: mimeType ?? this.mimeType,createdAt: createdAt ?? this.createdAt,syncStatus: syncStatus ?? this.syncStatus,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (localId.present) {
map['local_id'] = Variable<int>(localId.value);}
if (id.present) {
map['id'] = Variable<String>(id.value);}
if (tipoArquivo.present) {
map['tipo_arquivo'] = Variable<String>(tipoArquivo.value);}
if (nomeArquivo.present) {
map['nome_arquivo'] = Variable<String>(nomeArquivo.value);}
if (urlRemota.present) {
map['url_remota'] = Variable<String>(urlRemota.value);}
if (caminhoLocal.present) {
map['caminho_local'] = Variable<String>(caminhoLocal.value);}
if (tamanhoBytes.present) {
map['tamanho_bytes'] = Variable<int>(tamanhoBytes.value);}
if (mimeType.present) {
map['mime_type'] = Variable<String>(mimeType.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (syncStatus.present) {
map['sync_status'] = Variable<int>($EvidenciaPagamentosTable.$convertersyncStatus.toSql(syncStatus.value));}
return map; 
}
@override
String toString() {return (StringBuffer('EvidenciaPagamentosCompanion(')..write('localId: $localId, ')..write('id: $id, ')..write('tipoArquivo: $tipoArquivo, ')..write('nomeArquivo: $nomeArquivo, ')..write('urlRemota: $urlRemota, ')..write('caminhoLocal: $caminhoLocal, ')..write('tamanhoBytes: $tamanhoBytes, ')..write('mimeType: $mimeType, ')..write('createdAt: $createdAt, ')..write('syncStatus: $syncStatus')..write(')')).toString();}
}
abstract class _$AppDatabase extends GeneratedDatabase{
_$AppDatabase(QueryExecutor e): super(e);
$AppDatabaseManager get managers => $AppDatabaseManager(this);
late final $AlunosTable alunos = $AlunosTable(this);
late final $CustosMensaisTable custosMensais = $CustosMensaisTable(this);
late final $TurmasTable turmas = $TurmasTable(this);
late final $AnosLectivosTable anosLectivos = $AnosLectivosTable(this);
late final $MatriculasTable matriculas = $MatriculasTable(this);
late final $PagamentosTable pagamentos = $PagamentosTable(this);
late final $AuditoriasTable auditorias = $AuditoriasTable(this);
late final $NotificacoesInternasTable notificacoesInternas = $NotificacoesInternasTable(this);
late final $MensalidadesTable mensalidades = $MensalidadesTable(this);
late final $ConfiguracoesTable configuracoes = $ConfiguracoesTable(this);
late final $EvidenciaPagamentosTable evidenciaPagamentos = $EvidenciaPagamentosTable(this);
@override
Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
@override
List<DatabaseSchemaEntity> get allSchemaEntities => [alunos, custosMensais, turmas, anosLectivos, matriculas, pagamentos, auditorias, notificacoesInternas, mensalidades, configuracoes, evidenciaPagamentos];
}
typedef $$AlunosTableCreateCompanionBuilder = AlunosCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String numeroAluno,required String nomeCompleto,required DateTime dataNascimento,required String sexo,required String morada,required String escolaQueFrequenta,required String anoEscolaridade,required bool possuiCondicaoMedica,Value<String?> descricaoCondicaoMedica,required String nomeEncarregado,required String telefonePrincipal,Value<String?> telefoneAlternativo,Value<String?> email,Value<String?> comoConheceuInstituicao,required DateTime dataInscricao,Value<String?> observacoes,required double valorPagamentoInscricao,required bool isentoPagamento,Value<String?> comprovativoInscricaoUrl,Value<String?> comprovativoInscricaoLocal,required AlunoStatus status,});
typedef $$AlunosTableUpdateCompanionBuilder = AlunosCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> numeroAluno,Value<String> nomeCompleto,Value<DateTime> dataNascimento,Value<String> sexo,Value<String> morada,Value<String> escolaQueFrequenta,Value<String> anoEscolaridade,Value<bool> possuiCondicaoMedica,Value<String?> descricaoCondicaoMedica,Value<String> nomeEncarregado,Value<String> telefonePrincipal,Value<String?> telefoneAlternativo,Value<String?> email,Value<String?> comoConheceuInstituicao,Value<DateTime> dataInscricao,Value<String?> observacoes,Value<double> valorPagamentoInscricao,Value<bool> isentoPagamento,Value<String?> comprovativoInscricaoUrl,Value<String?> comprovativoInscricaoLocal,Value<AlunoStatus> status,});
class $$AlunosTableFilterComposer extends Composer<
        _$AppDatabase,
        $AlunosTable> {
        $$AlunosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get numeroAluno => $composableBuilder(
      column: $table.numeroAluno,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get nomeCompleto => $composableBuilder(
      column: $table.nomeCompleto,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get sexo => $composableBuilder(
      column: $table.sexo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get morada => $composableBuilder(
      column: $table.morada,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get escolaQueFrequenta => $composableBuilder(
      column: $table.escolaQueFrequenta,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get anoEscolaridade => $composableBuilder(
      column: $table.anoEscolaridade,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get possuiCondicaoMedica => $composableBuilder(
      column: $table.possuiCondicaoMedica,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get descricaoCondicaoMedica => $composableBuilder(
      column: $table.descricaoCondicaoMedica,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get nomeEncarregado => $composableBuilder(
      column: $table.nomeEncarregado,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get telefonePrincipal => $composableBuilder(
      column: $table.telefonePrincipal,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get telefoneAlternativo => $composableBuilder(
      column: $table.telefoneAlternativo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get email => $composableBuilder(
      column: $table.email,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get comoConheceuInstituicao => $composableBuilder(
      column: $table.comoConheceuInstituicao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataInscricao => $composableBuilder(
      column: $table.dataInscricao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get observacoes => $composableBuilder(
      column: $table.observacoes,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get valorPagamentoInscricao => $composableBuilder(
      column: $table.valorPagamentoInscricao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isentoPagamento => $composableBuilder(
      column: $table.isentoPagamento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get comprovativoInscricaoUrl => $composableBuilder(
      column: $table.comprovativoInscricaoUrl,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get comprovativoInscricaoLocal => $composableBuilder(
      column: $table.comprovativoInscricaoLocal,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<AlunoStatus,AlunoStatus,int> get status => $composableBuilder(
      column: $table.status,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
        }
      class $$AlunosTableOrderingComposer extends Composer<
        _$AppDatabase,
        $AlunosTable> {
        $$AlunosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get numeroAluno => $composableBuilder(
      column: $table.numeroAluno,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get nomeCompleto => $composableBuilder(
      column: $table.nomeCompleto,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get sexo => $composableBuilder(
      column: $table.sexo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get morada => $composableBuilder(
      column: $table.morada,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get escolaQueFrequenta => $composableBuilder(
      column: $table.escolaQueFrequenta,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get anoEscolaridade => $composableBuilder(
      column: $table.anoEscolaridade,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get possuiCondicaoMedica => $composableBuilder(
      column: $table.possuiCondicaoMedica,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get descricaoCondicaoMedica => $composableBuilder(
      column: $table.descricaoCondicaoMedica,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get nomeEncarregado => $composableBuilder(
      column: $table.nomeEncarregado,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get telefonePrincipal => $composableBuilder(
      column: $table.telefonePrincipal,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get telefoneAlternativo => $composableBuilder(
      column: $table.telefoneAlternativo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get comoConheceuInstituicao => $composableBuilder(
      column: $table.comoConheceuInstituicao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataInscricao => $composableBuilder(
      column: $table.dataInscricao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get observacoes => $composableBuilder(
      column: $table.observacoes,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get valorPagamentoInscricao => $composableBuilder(
      column: $table.valorPagamentoInscricao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isentoPagamento => $composableBuilder(
      column: $table.isentoPagamento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get comprovativoInscricaoUrl => $composableBuilder(
      column: $table.comprovativoInscricaoUrl,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get comprovativoInscricaoLocal => $composableBuilder(
      column: $table.comprovativoInscricaoLocal,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$AlunosTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $AlunosTable> {
        $$AlunosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get numeroAluno => $composableBuilder(
      column: $table.numeroAluno,
      builder: (column) => column);
      
GeneratedColumn<String> get nomeCompleto => $composableBuilder(
      column: $table.nomeCompleto,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => column);
      
GeneratedColumn<String> get sexo => $composableBuilder(
      column: $table.sexo,
      builder: (column) => column);
      
GeneratedColumn<String> get morada => $composableBuilder(
      column: $table.morada,
      builder: (column) => column);
      
GeneratedColumn<String> get escolaQueFrequenta => $composableBuilder(
      column: $table.escolaQueFrequenta,
      builder: (column) => column);
      
GeneratedColumn<String> get anoEscolaridade => $composableBuilder(
      column: $table.anoEscolaridade,
      builder: (column) => column);
      
GeneratedColumn<bool> get possuiCondicaoMedica => $composableBuilder(
      column: $table.possuiCondicaoMedica,
      builder: (column) => column);
      
GeneratedColumn<String> get descricaoCondicaoMedica => $composableBuilder(
      column: $table.descricaoCondicaoMedica,
      builder: (column) => column);
      
GeneratedColumn<String> get nomeEncarregado => $composableBuilder(
      column: $table.nomeEncarregado,
      builder: (column) => column);
      
GeneratedColumn<String> get telefonePrincipal => $composableBuilder(
      column: $table.telefonePrincipal,
      builder: (column) => column);
      
GeneratedColumn<String> get telefoneAlternativo => $composableBuilder(
      column: $table.telefoneAlternativo,
      builder: (column) => column);
      
GeneratedColumn<String> get email => $composableBuilder(
      column: $table.email,
      builder: (column) => column);
      
GeneratedColumn<String> get comoConheceuInstituicao => $composableBuilder(
      column: $table.comoConheceuInstituicao,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataInscricao => $composableBuilder(
      column: $table.dataInscricao,
      builder: (column) => column);
      
GeneratedColumn<String> get observacoes => $composableBuilder(
      column: $table.observacoes,
      builder: (column) => column);
      
GeneratedColumn<double> get valorPagamentoInscricao => $composableBuilder(
      column: $table.valorPagamentoInscricao,
      builder: (column) => column);
      
GeneratedColumn<bool> get isentoPagamento => $composableBuilder(
      column: $table.isentoPagamento,
      builder: (column) => column);
      
GeneratedColumn<String> get comprovativoInscricaoUrl => $composableBuilder(
      column: $table.comprovativoInscricaoUrl,
      builder: (column) => column);
      
GeneratedColumn<String> get comprovativoInscricaoLocal => $composableBuilder(
      column: $table.comprovativoInscricaoLocal,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<AlunoStatus,int> get status => $composableBuilder(
      column: $table.status,
      builder: (column) => column);
      
        }
      class $$AlunosTableTableManager extends RootTableManager    <_$AppDatabase,
    $AlunosTable,
    AlunoData,
    $$AlunosTableFilterComposer,
    $$AlunosTableOrderingComposer,
    $$AlunosTableAnnotationComposer,
    $$AlunosTableCreateCompanionBuilder,
    $$AlunosTableUpdateCompanionBuilder,
    (AlunoData,BaseReferences<_$AppDatabase,$AlunosTable,AlunoData>),
    AlunoData,
    PrefetchHooks Function()
    > {
    $$AlunosTableTableManager(_$AppDatabase db, $AlunosTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$AlunosTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$AlunosTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$AlunosTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> numeroAluno = const Value.absent(),Value<String> nomeCompleto = const Value.absent(),Value<DateTime> dataNascimento = const Value.absent(),Value<String> sexo = const Value.absent(),Value<String> morada = const Value.absent(),Value<String> escolaQueFrequenta = const Value.absent(),Value<String> anoEscolaridade = const Value.absent(),Value<bool> possuiCondicaoMedica = const Value.absent(),Value<String?> descricaoCondicaoMedica = const Value.absent(),Value<String> nomeEncarregado = const Value.absent(),Value<String> telefonePrincipal = const Value.absent(),Value<String?> telefoneAlternativo = const Value.absent(),Value<String?> email = const Value.absent(),Value<String?> comoConheceuInstituicao = const Value.absent(),Value<DateTime> dataInscricao = const Value.absent(),Value<String?> observacoes = const Value.absent(),Value<double> valorPagamentoInscricao = const Value.absent(),Value<bool> isentoPagamento = const Value.absent(),Value<String?> comprovativoInscricaoUrl = const Value.absent(),Value<String?> comprovativoInscricaoLocal = const Value.absent(),Value<AlunoStatus> status = const Value.absent(),})=> AlunosCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,numeroAluno: numeroAluno,nomeCompleto: nomeCompleto,dataNascimento: dataNascimento,sexo: sexo,morada: morada,escolaQueFrequenta: escolaQueFrequenta,anoEscolaridade: anoEscolaridade,possuiCondicaoMedica: possuiCondicaoMedica,descricaoCondicaoMedica: descricaoCondicaoMedica,nomeEncarregado: nomeEncarregado,telefonePrincipal: telefonePrincipal,telefoneAlternativo: telefoneAlternativo,email: email,comoConheceuInstituicao: comoConheceuInstituicao,dataInscricao: dataInscricao,observacoes: observacoes,valorPagamentoInscricao: valorPagamentoInscricao,isentoPagamento: isentoPagamento,comprovativoInscricaoUrl: comprovativoInscricaoUrl,comprovativoInscricaoLocal: comprovativoInscricaoLocal,status: status,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String numeroAluno,required String nomeCompleto,required DateTime dataNascimento,required String sexo,required String morada,required String escolaQueFrequenta,required String anoEscolaridade,required bool possuiCondicaoMedica,Value<String?> descricaoCondicaoMedica = const Value.absent(),required String nomeEncarregado,required String telefonePrincipal,Value<String?> telefoneAlternativo = const Value.absent(),Value<String?> email = const Value.absent(),Value<String?> comoConheceuInstituicao = const Value.absent(),required DateTime dataInscricao,Value<String?> observacoes = const Value.absent(),required double valorPagamentoInscricao,required bool isentoPagamento,Value<String?> comprovativoInscricaoUrl = const Value.absent(),Value<String?> comprovativoInscricaoLocal = const Value.absent(),required AlunoStatus status,})=> AlunosCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,numeroAluno: numeroAluno,nomeCompleto: nomeCompleto,dataNascimento: dataNascimento,sexo: sexo,morada: morada,escolaQueFrequenta: escolaQueFrequenta,anoEscolaridade: anoEscolaridade,possuiCondicaoMedica: possuiCondicaoMedica,descricaoCondicaoMedica: descricaoCondicaoMedica,nomeEncarregado: nomeEncarregado,telefonePrincipal: telefonePrincipal,telefoneAlternativo: telefoneAlternativo,email: email,comoConheceuInstituicao: comoConheceuInstituicao,dataInscricao: dataInscricao,observacoes: observacoes,valorPagamentoInscricao: valorPagamentoInscricao,isentoPagamento: isentoPagamento,comprovativoInscricaoUrl: comprovativoInscricaoUrl,comprovativoInscricaoLocal: comprovativoInscricaoLocal,status: status,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$AlunosTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $AlunosTable,
    AlunoData,
    $$AlunosTableFilterComposer,
    $$AlunosTableOrderingComposer,
    $$AlunosTableAnnotationComposer,
    $$AlunosTableCreateCompanionBuilder,
    $$AlunosTableUpdateCompanionBuilder,
    (AlunoData,BaseReferences<_$AppDatabase,$AlunosTable,AlunoData>),
    AlunoData,
    PrefetchHooks Function()
    >;typedef $$CustosMensaisTableCreateCompanionBuilder = CustosMensaisCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String descricao,required String categoria,required double valor,required DateTime data,required String tipo,required int mesReferencia,required int anoReferencia,required String estado,Value<String?> observacao,Value<String?> comprovativoUrl,Value<String?> comprovativoLocal,required String responsavelId,});
typedef $$CustosMensaisTableUpdateCompanionBuilder = CustosMensaisCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> descricao,Value<String> categoria,Value<double> valor,Value<DateTime> data,Value<String> tipo,Value<int> mesReferencia,Value<int> anoReferencia,Value<String> estado,Value<String?> observacao,Value<String?> comprovativoUrl,Value<String?> comprovativoLocal,Value<String> responsavelId,});
class $$CustosMensaisTableFilterComposer extends Composer<
        _$AppDatabase,
        $CustosMensaisTable> {
        $$CustosMensaisTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get descricao => $composableBuilder(
      column: $table.descricao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get categoria => $composableBuilder(
      column: $table.categoria,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get valor => $composableBuilder(
      column: $table.valor,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get data => $composableBuilder(
      column: $table.data,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get mesReferencia => $composableBuilder(
      column: $table.mesReferencia,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get anoReferencia => $composableBuilder(
      column: $table.anoReferencia,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get comprovativoUrl => $composableBuilder(
      column: $table.comprovativoUrl,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get comprovativoLocal => $composableBuilder(
      column: $table.comprovativoLocal,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get responsavelId => $composableBuilder(
      column: $table.responsavelId,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$CustosMensaisTableOrderingComposer extends Composer<
        _$AppDatabase,
        $CustosMensaisTable> {
        $$CustosMensaisTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get descricao => $composableBuilder(
      column: $table.descricao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get categoria => $composableBuilder(
      column: $table.categoria,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get valor => $composableBuilder(
      column: $table.valor,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get data => $composableBuilder(
      column: $table.data,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get mesReferencia => $composableBuilder(
      column: $table.mesReferencia,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get anoReferencia => $composableBuilder(
      column: $table.anoReferencia,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get comprovativoUrl => $composableBuilder(
      column: $table.comprovativoUrl,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get comprovativoLocal => $composableBuilder(
      column: $table.comprovativoLocal,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get responsavelId => $composableBuilder(
      column: $table.responsavelId,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$CustosMensaisTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $CustosMensaisTable> {
        $$CustosMensaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get descricao => $composableBuilder(
      column: $table.descricao,
      builder: (column) => column);
      
GeneratedColumn<String> get categoria => $composableBuilder(
      column: $table.categoria,
      builder: (column) => column);
      
GeneratedColumn<double> get valor => $composableBuilder(
      column: $table.valor,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get data => $composableBuilder(
      column: $table.data,
      builder: (column) => column);
      
GeneratedColumn<String> get tipo => $composableBuilder(
      column: $table.tipo,
      builder: (column) => column);
      
GeneratedColumn<int> get mesReferencia => $composableBuilder(
      column: $table.mesReferencia,
      builder: (column) => column);
      
GeneratedColumn<int> get anoReferencia => $composableBuilder(
      column: $table.anoReferencia,
      builder: (column) => column);
      
GeneratedColumn<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => column);
      
GeneratedColumn<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => column);
      
GeneratedColumn<String> get comprovativoUrl => $composableBuilder(
      column: $table.comprovativoUrl,
      builder: (column) => column);
      
GeneratedColumn<String> get comprovativoLocal => $composableBuilder(
      column: $table.comprovativoLocal,
      builder: (column) => column);
      
GeneratedColumn<String> get responsavelId => $composableBuilder(
      column: $table.responsavelId,
      builder: (column) => column);
      
        }
      class $$CustosMensaisTableTableManager extends RootTableManager    <_$AppDatabase,
    $CustosMensaisTable,
    CustoMensalData,
    $$CustosMensaisTableFilterComposer,
    $$CustosMensaisTableOrderingComposer,
    $$CustosMensaisTableAnnotationComposer,
    $$CustosMensaisTableCreateCompanionBuilder,
    $$CustosMensaisTableUpdateCompanionBuilder,
    (CustoMensalData,BaseReferences<_$AppDatabase,$CustosMensaisTable,CustoMensalData>),
    CustoMensalData,
    PrefetchHooks Function()
    > {
    $$CustosMensaisTableTableManager(_$AppDatabase db, $CustosMensaisTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$CustosMensaisTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$CustosMensaisTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$CustosMensaisTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> descricao = const Value.absent(),Value<String> categoria = const Value.absent(),Value<double> valor = const Value.absent(),Value<DateTime> data = const Value.absent(),Value<String> tipo = const Value.absent(),Value<int> mesReferencia = const Value.absent(),Value<int> anoReferencia = const Value.absent(),Value<String> estado = const Value.absent(),Value<String?> observacao = const Value.absent(),Value<String?> comprovativoUrl = const Value.absent(),Value<String?> comprovativoLocal = const Value.absent(),Value<String> responsavelId = const Value.absent(),})=> CustosMensaisCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,descricao: descricao,categoria: categoria,valor: valor,data: data,tipo: tipo,mesReferencia: mesReferencia,anoReferencia: anoReferencia,estado: estado,observacao: observacao,comprovativoUrl: comprovativoUrl,comprovativoLocal: comprovativoLocal,responsavelId: responsavelId,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String descricao,required String categoria,required double valor,required DateTime data,required String tipo,required int mesReferencia,required int anoReferencia,required String estado,Value<String?> observacao = const Value.absent(),Value<String?> comprovativoUrl = const Value.absent(),Value<String?> comprovativoLocal = const Value.absent(),required String responsavelId,})=> CustosMensaisCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,descricao: descricao,categoria: categoria,valor: valor,data: data,tipo: tipo,mesReferencia: mesReferencia,anoReferencia: anoReferencia,estado: estado,observacao: observacao,comprovativoUrl: comprovativoUrl,comprovativoLocal: comprovativoLocal,responsavelId: responsavelId,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$CustosMensaisTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $CustosMensaisTable,
    CustoMensalData,
    $$CustosMensaisTableFilterComposer,
    $$CustosMensaisTableOrderingComposer,
    $$CustosMensaisTableAnnotationComposer,
    $$CustosMensaisTableCreateCompanionBuilder,
    $$CustosMensaisTableUpdateCompanionBuilder,
    (CustoMensalData,BaseReferences<_$AppDatabase,$CustosMensaisTable,CustoMensalData>),
    CustoMensalData,
    PrefetchHooks Function()
    >;typedef $$TurmasTableCreateCompanionBuilder = TurmasCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String nomeTurma,required int limiteAlunos,required String turno,required String numeroSala,required bool ativa,required String anoLectivoId,});
typedef $$TurmasTableUpdateCompanionBuilder = TurmasCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> nomeTurma,Value<int> limiteAlunos,Value<String> turno,Value<String> numeroSala,Value<bool> ativa,Value<String> anoLectivoId,});
class $$TurmasTableFilterComposer extends Composer<
        _$AppDatabase,
        $TurmasTable> {
        $$TurmasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get nomeTurma => $composableBuilder(
      column: $table.nomeTurma,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get limiteAlunos => $composableBuilder(
      column: $table.limiteAlunos,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get numeroSala => $composableBuilder(
      column: $table.numeroSala,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get ativa => $composableBuilder(
      column: $table.ativa,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get anoLectivoId => $composableBuilder(
      column: $table.anoLectivoId,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$TurmasTableOrderingComposer extends Composer<
        _$AppDatabase,
        $TurmasTable> {
        $$TurmasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get nomeTurma => $composableBuilder(
      column: $table.nomeTurma,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get limiteAlunos => $composableBuilder(
      column: $table.limiteAlunos,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get numeroSala => $composableBuilder(
      column: $table.numeroSala,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get ativa => $composableBuilder(
      column: $table.ativa,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get anoLectivoId => $composableBuilder(
      column: $table.anoLectivoId,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$TurmasTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $TurmasTable> {
        $$TurmasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get nomeTurma => $composableBuilder(
      column: $table.nomeTurma,
      builder: (column) => column);
      
GeneratedColumn<int> get limiteAlunos => $composableBuilder(
      column: $table.limiteAlunos,
      builder: (column) => column);
      
GeneratedColumn<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => column);
      
GeneratedColumn<String> get numeroSala => $composableBuilder(
      column: $table.numeroSala,
      builder: (column) => column);
      
GeneratedColumn<bool> get ativa => $composableBuilder(
      column: $table.ativa,
      builder: (column) => column);
      
GeneratedColumn<String> get anoLectivoId => $composableBuilder(
      column: $table.anoLectivoId,
      builder: (column) => column);
      
        }
      class $$TurmasTableTableManager extends RootTableManager    <_$AppDatabase,
    $TurmasTable,
    TurmaData,
    $$TurmasTableFilterComposer,
    $$TurmasTableOrderingComposer,
    $$TurmasTableAnnotationComposer,
    $$TurmasTableCreateCompanionBuilder,
    $$TurmasTableUpdateCompanionBuilder,
    (TurmaData,BaseReferences<_$AppDatabase,$TurmasTable,TurmaData>),
    TurmaData,
    PrefetchHooks Function()
    > {
    $$TurmasTableTableManager(_$AppDatabase db, $TurmasTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$TurmasTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$TurmasTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$TurmasTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> nomeTurma = const Value.absent(),Value<int> limiteAlunos = const Value.absent(),Value<String> turno = const Value.absent(),Value<String> numeroSala = const Value.absent(),Value<bool> ativa = const Value.absent(),Value<String> anoLectivoId = const Value.absent(),})=> TurmasCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,nomeTurma: nomeTurma,limiteAlunos: limiteAlunos,turno: turno,numeroSala: numeroSala,ativa: ativa,anoLectivoId: anoLectivoId,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String nomeTurma,required int limiteAlunos,required String turno,required String numeroSala,required bool ativa,required String anoLectivoId,})=> TurmasCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,nomeTurma: nomeTurma,limiteAlunos: limiteAlunos,turno: turno,numeroSala: numeroSala,ativa: ativa,anoLectivoId: anoLectivoId,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$TurmasTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $TurmasTable,
    TurmaData,
    $$TurmasTableFilterComposer,
    $$TurmasTableOrderingComposer,
    $$TurmasTableAnnotationComposer,
    $$TurmasTableCreateCompanionBuilder,
    $$TurmasTableUpdateCompanionBuilder,
    (TurmaData,BaseReferences<_$AppDatabase,$TurmasTable,TurmaData>),
    TurmaData,
    PrefetchHooks Function()
    >;typedef $$AnosLectivosTableCreateCompanionBuilder = AnosLectivosCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String ano,required DateTime dataInicio,required DateTime dataFim,required bool isActive,});
typedef $$AnosLectivosTableUpdateCompanionBuilder = AnosLectivosCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> ano,Value<DateTime> dataInicio,Value<DateTime> dataFim,Value<bool> isActive,});
class $$AnosLectivosTableFilterComposer extends Composer<
        _$AppDatabase,
        $AnosLectivosTable> {
        $$AnosLectivosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get ano => $composableBuilder(
      column: $table.ano,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataInicio => $composableBuilder(
      column: $table.dataInicio,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataFim => $composableBuilder(
      column: $table.dataFim,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$AnosLectivosTableOrderingComposer extends Composer<
        _$AppDatabase,
        $AnosLectivosTable> {
        $$AnosLectivosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get ano => $composableBuilder(
      column: $table.ano,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataInicio => $composableBuilder(
      column: $table.dataInicio,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataFim => $composableBuilder(
      column: $table.dataFim,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$AnosLectivosTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $AnosLectivosTable> {
        $$AnosLectivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get ano => $composableBuilder(
      column: $table.ano,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataInicio => $composableBuilder(
      column: $table.dataInicio,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataFim => $composableBuilder(
      column: $table.dataFim,
      builder: (column) => column);
      
GeneratedColumn<bool> get isActive => $composableBuilder(
      column: $table.isActive,
      builder: (column) => column);
      
        }
      class $$AnosLectivosTableTableManager extends RootTableManager    <_$AppDatabase,
    $AnosLectivosTable,
    AnosLectivoData,
    $$AnosLectivosTableFilterComposer,
    $$AnosLectivosTableOrderingComposer,
    $$AnosLectivosTableAnnotationComposer,
    $$AnosLectivosTableCreateCompanionBuilder,
    $$AnosLectivosTableUpdateCompanionBuilder,
    (AnosLectivoData,BaseReferences<_$AppDatabase,$AnosLectivosTable,AnosLectivoData>),
    AnosLectivoData,
    PrefetchHooks Function()
    > {
    $$AnosLectivosTableTableManager(_$AppDatabase db, $AnosLectivosTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$AnosLectivosTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$AnosLectivosTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$AnosLectivosTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> ano = const Value.absent(),Value<DateTime> dataInicio = const Value.absent(),Value<DateTime> dataFim = const Value.absent(),Value<bool> isActive = const Value.absent(),})=> AnosLectivosCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,ano: ano,dataInicio: dataInicio,dataFim: dataFim,isActive: isActive,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String ano,required DateTime dataInicio,required DateTime dataFim,required bool isActive,})=> AnosLectivosCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,ano: ano,dataInicio: dataInicio,dataFim: dataFim,isActive: isActive,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$AnosLectivosTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $AnosLectivosTable,
    AnosLectivoData,
    $$AnosLectivosTableFilterComposer,
    $$AnosLectivosTableOrderingComposer,
    $$AnosLectivosTableAnnotationComposer,
    $$AnosLectivosTableCreateCompanionBuilder,
    $$AnosLectivosTableUpdateCompanionBuilder,
    (AnosLectivoData,BaseReferences<_$AppDatabase,$AnosLectivosTable,AnosLectivoData>),
    AnosLectivoData,
    PrefetchHooks Function()
    >;typedef $$MatriculasTableCreateCompanionBuilder = MatriculasCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String numeroMatricula,required String alunoId,required String turmaId,required String turno,required String anoLectivo,required DateTime dataMatricula,required String estado,required double valorMensalidade,required int diaVencimento,});
typedef $$MatriculasTableUpdateCompanionBuilder = MatriculasCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> numeroMatricula,Value<String> alunoId,Value<String> turmaId,Value<String> turno,Value<String> anoLectivo,Value<DateTime> dataMatricula,Value<String> estado,Value<double> valorMensalidade,Value<int> diaVencimento,});
class $$MatriculasTableFilterComposer extends Composer<
        _$AppDatabase,
        $MatriculasTable> {
        $$MatriculasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get numeroMatricula => $composableBuilder(
      column: $table.numeroMatricula,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get alunoId => $composableBuilder(
      column: $table.alunoId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get turmaId => $composableBuilder(
      column: $table.turmaId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get anoLectivo => $composableBuilder(
      column: $table.anoLectivo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataMatricula => $composableBuilder(
      column: $table.dataMatricula,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get valorMensalidade => $composableBuilder(
      column: $table.valorMensalidade,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get diaVencimento => $composableBuilder(
      column: $table.diaVencimento,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$MatriculasTableOrderingComposer extends Composer<
        _$AppDatabase,
        $MatriculasTable> {
        $$MatriculasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get numeroMatricula => $composableBuilder(
      column: $table.numeroMatricula,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get alunoId => $composableBuilder(
      column: $table.alunoId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get turmaId => $composableBuilder(
      column: $table.turmaId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get anoLectivo => $composableBuilder(
      column: $table.anoLectivo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataMatricula => $composableBuilder(
      column: $table.dataMatricula,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get valorMensalidade => $composableBuilder(
      column: $table.valorMensalidade,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get diaVencimento => $composableBuilder(
      column: $table.diaVencimento,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$MatriculasTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $MatriculasTable> {
        $$MatriculasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get numeroMatricula => $composableBuilder(
      column: $table.numeroMatricula,
      builder: (column) => column);
      
GeneratedColumn<String> get alunoId => $composableBuilder(
      column: $table.alunoId,
      builder: (column) => column);
      
GeneratedColumn<String> get turmaId => $composableBuilder(
      column: $table.turmaId,
      builder: (column) => column);
      
GeneratedColumn<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => column);
      
GeneratedColumn<String> get anoLectivo => $composableBuilder(
      column: $table.anoLectivo,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataMatricula => $composableBuilder(
      column: $table.dataMatricula,
      builder: (column) => column);
      
GeneratedColumn<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => column);
      
GeneratedColumn<double> get valorMensalidade => $composableBuilder(
      column: $table.valorMensalidade,
      builder: (column) => column);
      
GeneratedColumn<int> get diaVencimento => $composableBuilder(
      column: $table.diaVencimento,
      builder: (column) => column);
      
        }
      class $$MatriculasTableTableManager extends RootTableManager    <_$AppDatabase,
    $MatriculasTable,
    MatriculaData,
    $$MatriculasTableFilterComposer,
    $$MatriculasTableOrderingComposer,
    $$MatriculasTableAnnotationComposer,
    $$MatriculasTableCreateCompanionBuilder,
    $$MatriculasTableUpdateCompanionBuilder,
    (MatriculaData,BaseReferences<_$AppDatabase,$MatriculasTable,MatriculaData>),
    MatriculaData,
    PrefetchHooks Function()
    > {
    $$MatriculasTableTableManager(_$AppDatabase db, $MatriculasTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$MatriculasTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$MatriculasTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$MatriculasTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> numeroMatricula = const Value.absent(),Value<String> alunoId = const Value.absent(),Value<String> turmaId = const Value.absent(),Value<String> turno = const Value.absent(),Value<String> anoLectivo = const Value.absent(),Value<DateTime> dataMatricula = const Value.absent(),Value<String> estado = const Value.absent(),Value<double> valorMensalidade = const Value.absent(),Value<int> diaVencimento = const Value.absent(),})=> MatriculasCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,numeroMatricula: numeroMatricula,alunoId: alunoId,turmaId: turmaId,turno: turno,anoLectivo: anoLectivo,dataMatricula: dataMatricula,estado: estado,valorMensalidade: valorMensalidade,diaVencimento: diaVencimento,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String numeroMatricula,required String alunoId,required String turmaId,required String turno,required String anoLectivo,required DateTime dataMatricula,required String estado,required double valorMensalidade,required int diaVencimento,})=> MatriculasCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,numeroMatricula: numeroMatricula,alunoId: alunoId,turmaId: turmaId,turno: turno,anoLectivo: anoLectivo,dataMatricula: dataMatricula,estado: estado,valorMensalidade: valorMensalidade,diaVencimento: diaVencimento,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$MatriculasTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $MatriculasTable,
    MatriculaData,
    $$MatriculasTableFilterComposer,
    $$MatriculasTableOrderingComposer,
    $$MatriculasTableAnnotationComposer,
    $$MatriculasTableCreateCompanionBuilder,
    $$MatriculasTableUpdateCompanionBuilder,
    (MatriculaData,BaseReferences<_$AppDatabase,$MatriculasTable,MatriculaData>),
    MatriculaData,
    PrefetchHooks Function()
    >;typedef $$PagamentosTableCreateCompanionBuilder = PagamentosCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String mensalidadeId,required double valorPago,required DateTime dataPagamento,required String formaPagamento,Value<String?> observacao,Value<String?> evidenciaId,required String numeroRecibo,required String confirmadoPor,});
typedef $$PagamentosTableUpdateCompanionBuilder = PagamentosCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> mensalidadeId,Value<double> valorPago,Value<DateTime> dataPagamento,Value<String> formaPagamento,Value<String?> observacao,Value<String?> evidenciaId,Value<String> numeroRecibo,Value<String> confirmadoPor,});
class $$PagamentosTableFilterComposer extends Composer<
        _$AppDatabase,
        $PagamentosTable> {
        $$PagamentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get mensalidadeId => $composableBuilder(
      column: $table.mensalidadeId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get valorPago => $composableBuilder(
      column: $table.valorPago,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataPagamento => $composableBuilder(
      column: $table.dataPagamento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get formaPagamento => $composableBuilder(
      column: $table.formaPagamento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get evidenciaId => $composableBuilder(
      column: $table.evidenciaId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get numeroRecibo => $composableBuilder(
      column: $table.numeroRecibo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get confirmadoPor => $composableBuilder(
      column: $table.confirmadoPor,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$PagamentosTableOrderingComposer extends Composer<
        _$AppDatabase,
        $PagamentosTable> {
        $$PagamentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get mensalidadeId => $composableBuilder(
      column: $table.mensalidadeId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get valorPago => $composableBuilder(
      column: $table.valorPago,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataPagamento => $composableBuilder(
      column: $table.dataPagamento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get formaPagamento => $composableBuilder(
      column: $table.formaPagamento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get evidenciaId => $composableBuilder(
      column: $table.evidenciaId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get numeroRecibo => $composableBuilder(
      column: $table.numeroRecibo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get confirmadoPor => $composableBuilder(
      column: $table.confirmadoPor,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$PagamentosTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $PagamentosTable> {
        $$PagamentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get mensalidadeId => $composableBuilder(
      column: $table.mensalidadeId,
      builder: (column) => column);
      
GeneratedColumn<double> get valorPago => $composableBuilder(
      column: $table.valorPago,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataPagamento => $composableBuilder(
      column: $table.dataPagamento,
      builder: (column) => column);
      
GeneratedColumn<String> get formaPagamento => $composableBuilder(
      column: $table.formaPagamento,
      builder: (column) => column);
      
GeneratedColumn<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => column);
      
GeneratedColumn<String> get evidenciaId => $composableBuilder(
      column: $table.evidenciaId,
      builder: (column) => column);
      
GeneratedColumn<String> get numeroRecibo => $composableBuilder(
      column: $table.numeroRecibo,
      builder: (column) => column);
      
GeneratedColumn<String> get confirmadoPor => $composableBuilder(
      column: $table.confirmadoPor,
      builder: (column) => column);
      
        }
      class $$PagamentosTableTableManager extends RootTableManager    <_$AppDatabase,
    $PagamentosTable,
    PagamentoData,
    $$PagamentosTableFilterComposer,
    $$PagamentosTableOrderingComposer,
    $$PagamentosTableAnnotationComposer,
    $$PagamentosTableCreateCompanionBuilder,
    $$PagamentosTableUpdateCompanionBuilder,
    (PagamentoData,BaseReferences<_$AppDatabase,$PagamentosTable,PagamentoData>),
    PagamentoData,
    PrefetchHooks Function()
    > {
    $$PagamentosTableTableManager(_$AppDatabase db, $PagamentosTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$PagamentosTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$PagamentosTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$PagamentosTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> mensalidadeId = const Value.absent(),Value<double> valorPago = const Value.absent(),Value<DateTime> dataPagamento = const Value.absent(),Value<String> formaPagamento = const Value.absent(),Value<String?> observacao = const Value.absent(),Value<String?> evidenciaId = const Value.absent(),Value<String> numeroRecibo = const Value.absent(),Value<String> confirmadoPor = const Value.absent(),})=> PagamentosCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,mensalidadeId: mensalidadeId,valorPago: valorPago,dataPagamento: dataPagamento,formaPagamento: formaPagamento,observacao: observacao,evidenciaId: evidenciaId,numeroRecibo: numeroRecibo,confirmadoPor: confirmadoPor,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String mensalidadeId,required double valorPago,required DateTime dataPagamento,required String formaPagamento,Value<String?> observacao = const Value.absent(),Value<String?> evidenciaId = const Value.absent(),required String numeroRecibo,required String confirmadoPor,})=> PagamentosCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,mensalidadeId: mensalidadeId,valorPago: valorPago,dataPagamento: dataPagamento,formaPagamento: formaPagamento,observacao: observacao,evidenciaId: evidenciaId,numeroRecibo: numeroRecibo,confirmadoPor: confirmadoPor,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$PagamentosTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $PagamentosTable,
    PagamentoData,
    $$PagamentosTableFilterComposer,
    $$PagamentosTableOrderingComposer,
    $$PagamentosTableAnnotationComposer,
    $$PagamentosTableCreateCompanionBuilder,
    $$PagamentosTableUpdateCompanionBuilder,
    (PagamentoData,BaseReferences<_$AppDatabase,$PagamentosTable,PagamentoData>),
    PagamentoData,
    PrefetchHooks Function()
    >;typedef $$AuditoriasTableCreateCompanionBuilder = AuditoriasCompanion Function({Value<int> localId,required String id,required String entidade,required String entidadeId,required String acao,Value<String?> valorAnteriorJson,Value<String?> valorNovoJson,required String utilizadorId,required DateTime dataHora,});
typedef $$AuditoriasTableUpdateCompanionBuilder = AuditoriasCompanion Function({Value<int> localId,Value<String> id,Value<String> entidade,Value<String> entidadeId,Value<String> acao,Value<String?> valorAnteriorJson,Value<String?> valorNovoJson,Value<String> utilizadorId,Value<DateTime> dataHora,});
class $$AuditoriasTableFilterComposer extends Composer<
        _$AppDatabase,
        $AuditoriasTable> {
        $$AuditoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get entidade => $composableBuilder(
      column: $table.entidade,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get entidadeId => $composableBuilder(
      column: $table.entidadeId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get acao => $composableBuilder(
      column: $table.acao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get valorAnteriorJson => $composableBuilder(
      column: $table.valorAnteriorJson,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get valorNovoJson => $composableBuilder(
      column: $table.valorNovoJson,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get utilizadorId => $composableBuilder(
      column: $table.utilizadorId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataHora => $composableBuilder(
      column: $table.dataHora,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$AuditoriasTableOrderingComposer extends Composer<
        _$AppDatabase,
        $AuditoriasTable> {
        $$AuditoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get entidade => $composableBuilder(
      column: $table.entidade,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get entidadeId => $composableBuilder(
      column: $table.entidadeId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get acao => $composableBuilder(
      column: $table.acao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get valorAnteriorJson => $composableBuilder(
      column: $table.valorAnteriorJson,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get valorNovoJson => $composableBuilder(
      column: $table.valorNovoJson,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get utilizadorId => $composableBuilder(
      column: $table.utilizadorId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataHora => $composableBuilder(
      column: $table.dataHora,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$AuditoriasTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $AuditoriasTable> {
        $$AuditoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get entidade => $composableBuilder(
      column: $table.entidade,
      builder: (column) => column);
      
GeneratedColumn<String> get entidadeId => $composableBuilder(
      column: $table.entidadeId,
      builder: (column) => column);
      
GeneratedColumn<String> get acao => $composableBuilder(
      column: $table.acao,
      builder: (column) => column);
      
GeneratedColumn<String> get valorAnteriorJson => $composableBuilder(
      column: $table.valorAnteriorJson,
      builder: (column) => column);
      
GeneratedColumn<String> get valorNovoJson => $composableBuilder(
      column: $table.valorNovoJson,
      builder: (column) => column);
      
GeneratedColumn<String> get utilizadorId => $composableBuilder(
      column: $table.utilizadorId,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataHora => $composableBuilder(
      column: $table.dataHora,
      builder: (column) => column);
      
        }
      class $$AuditoriasTableTableManager extends RootTableManager    <_$AppDatabase,
    $AuditoriasTable,
    AuditoriaData,
    $$AuditoriasTableFilterComposer,
    $$AuditoriasTableOrderingComposer,
    $$AuditoriasTableAnnotationComposer,
    $$AuditoriasTableCreateCompanionBuilder,
    $$AuditoriasTableUpdateCompanionBuilder,
    (AuditoriaData,BaseReferences<_$AppDatabase,$AuditoriasTable,AuditoriaData>),
    AuditoriaData,
    PrefetchHooks Function()
    > {
    $$AuditoriasTableTableManager(_$AppDatabase db, $AuditoriasTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$AuditoriasTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$AuditoriasTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$AuditoriasTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> localId = const Value.absent(),Value<String> id = const Value.absent(),Value<String> entidade = const Value.absent(),Value<String> entidadeId = const Value.absent(),Value<String> acao = const Value.absent(),Value<String?> valorAnteriorJson = const Value.absent(),Value<String?> valorNovoJson = const Value.absent(),Value<String> utilizadorId = const Value.absent(),Value<DateTime> dataHora = const Value.absent(),})=> AuditoriasCompanion(localId: localId,id: id,entidade: entidade,entidadeId: entidadeId,acao: acao,valorAnteriorJson: valorAnteriorJson,valorNovoJson: valorNovoJson,utilizadorId: utilizadorId,dataHora: dataHora,),
        createCompanionCallback: ({Value<int> localId = const Value.absent(),required String id,required String entidade,required String entidadeId,required String acao,Value<String?> valorAnteriorJson = const Value.absent(),Value<String?> valorNovoJson = const Value.absent(),required String utilizadorId,required DateTime dataHora,})=> AuditoriasCompanion.insert(localId: localId,id: id,entidade: entidade,entidadeId: entidadeId,acao: acao,valorAnteriorJson: valorAnteriorJson,valorNovoJson: valorNovoJson,utilizadorId: utilizadorId,dataHora: dataHora,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$AuditoriasTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $AuditoriasTable,
    AuditoriaData,
    $$AuditoriasTableFilterComposer,
    $$AuditoriasTableOrderingComposer,
    $$AuditoriasTableAnnotationComposer,
    $$AuditoriasTableCreateCompanionBuilder,
    $$AuditoriasTableUpdateCompanionBuilder,
    (AuditoriaData,BaseReferences<_$AppDatabase,$AuditoriasTable,AuditoriaData>),
    AuditoriaData,
    PrefetchHooks Function()
    >;typedef $$NotificacoesInternasTableCreateCompanionBuilder = NotificacoesInternasCompanion Function({Value<int> localId,required String id,required String titulo,required String mensagem,required String tipo,Value<String?> entidadeRelacionada,Value<String?> entidadeId,Value<bool> lida,required DateTime createdAt,});
typedef $$NotificacoesInternasTableUpdateCompanionBuilder = NotificacoesInternasCompanion Function({Value<int> localId,Value<String> id,Value<String> titulo,Value<String> mensagem,Value<String> tipo,Value<String?> entidadeRelacionada,Value<String?> entidadeId,Value<bool> lida,Value<DateTime> createdAt,});
class $$NotificacoesInternasTableFilterComposer extends Composer<
        _$AppDatabase,
        $NotificacoesInternasTable> {
        $$NotificacoesInternasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get titulo => $composableBuilder(
      column: $table.titulo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get mensagem => $composableBuilder(
      column: $table.mensagem,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get entidadeRelacionada => $composableBuilder(
      column: $table.entidadeRelacionada,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get entidadeId => $composableBuilder(
      column: $table.entidadeId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get lida => $composableBuilder(
      column: $table.lida,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$NotificacoesInternasTableOrderingComposer extends Composer<
        _$AppDatabase,
        $NotificacoesInternasTable> {
        $$NotificacoesInternasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get titulo => $composableBuilder(
      column: $table.titulo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get mensagem => $composableBuilder(
      column: $table.mensagem,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get entidadeRelacionada => $composableBuilder(
      column: $table.entidadeRelacionada,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get entidadeId => $composableBuilder(
      column: $table.entidadeId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get lida => $composableBuilder(
      column: $table.lida,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$NotificacoesInternasTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $NotificacoesInternasTable> {
        $$NotificacoesInternasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get titulo => $composableBuilder(
      column: $table.titulo,
      builder: (column) => column);
      
GeneratedColumn<String> get mensagem => $composableBuilder(
      column: $table.mensagem,
      builder: (column) => column);
      
GeneratedColumn<String> get tipo => $composableBuilder(
      column: $table.tipo,
      builder: (column) => column);
      
GeneratedColumn<String> get entidadeRelacionada => $composableBuilder(
      column: $table.entidadeRelacionada,
      builder: (column) => column);
      
GeneratedColumn<String> get entidadeId => $composableBuilder(
      column: $table.entidadeId,
      builder: (column) => column);
      
GeneratedColumn<bool> get lida => $composableBuilder(
      column: $table.lida,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
        }
      class $$NotificacoesInternasTableTableManager extends RootTableManager    <_$AppDatabase,
    $NotificacoesInternasTable,
    NotificacoesInternaData,
    $$NotificacoesInternasTableFilterComposer,
    $$NotificacoesInternasTableOrderingComposer,
    $$NotificacoesInternasTableAnnotationComposer,
    $$NotificacoesInternasTableCreateCompanionBuilder,
    $$NotificacoesInternasTableUpdateCompanionBuilder,
    (NotificacoesInternaData,BaseReferences<_$AppDatabase,$NotificacoesInternasTable,NotificacoesInternaData>),
    NotificacoesInternaData,
    PrefetchHooks Function()
    > {
    $$NotificacoesInternasTableTableManager(_$AppDatabase db, $NotificacoesInternasTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$NotificacoesInternasTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$NotificacoesInternasTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$NotificacoesInternasTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> localId = const Value.absent(),Value<String> id = const Value.absent(),Value<String> titulo = const Value.absent(),Value<String> mensagem = const Value.absent(),Value<String> tipo = const Value.absent(),Value<String?> entidadeRelacionada = const Value.absent(),Value<String?> entidadeId = const Value.absent(),Value<bool> lida = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),})=> NotificacoesInternasCompanion(localId: localId,id: id,titulo: titulo,mensagem: mensagem,tipo: tipo,entidadeRelacionada: entidadeRelacionada,entidadeId: entidadeId,lida: lida,createdAt: createdAt,),
        createCompanionCallback: ({Value<int> localId = const Value.absent(),required String id,required String titulo,required String mensagem,required String tipo,Value<String?> entidadeRelacionada = const Value.absent(),Value<String?> entidadeId = const Value.absent(),Value<bool> lida = const Value.absent(),required DateTime createdAt,})=> NotificacoesInternasCompanion.insert(localId: localId,id: id,titulo: titulo,mensagem: mensagem,tipo: tipo,entidadeRelacionada: entidadeRelacionada,entidadeId: entidadeId,lida: lida,createdAt: createdAt,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$NotificacoesInternasTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $NotificacoesInternasTable,
    NotificacoesInternaData,
    $$NotificacoesInternasTableFilterComposer,
    $$NotificacoesInternasTableOrderingComposer,
    $$NotificacoesInternasTableAnnotationComposer,
    $$NotificacoesInternasTableCreateCompanionBuilder,
    $$NotificacoesInternasTableUpdateCompanionBuilder,
    (NotificacoesInternaData,BaseReferences<_$AppDatabase,$NotificacoesInternasTable,NotificacoesInternaData>),
    NotificacoesInternaData,
    PrefetchHooks Function()
    >;typedef $$MensalidadesTableCreateCompanionBuilder = MensalidadesCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String matriculaId,required String alunoId,required String turmaId,required String turno,required int mesReferencia,required int anoReferencia,required double valor,required DateTime dataVencimento,required String estado,Value<DateTime?> dataPagamento,Value<String?> observacao,});
typedef $$MensalidadesTableUpdateCompanionBuilder = MensalidadesCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> matriculaId,Value<String> alunoId,Value<String> turmaId,Value<String> turno,Value<int> mesReferencia,Value<int> anoReferencia,Value<double> valor,Value<DateTime> dataVencimento,Value<String> estado,Value<DateTime?> dataPagamento,Value<String?> observacao,});
class $$MensalidadesTableFilterComposer extends Composer<
        _$AppDatabase,
        $MensalidadesTable> {
        $$MensalidadesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get matriculaId => $composableBuilder(
      column: $table.matriculaId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get alunoId => $composableBuilder(
      column: $table.alunoId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get turmaId => $composableBuilder(
      column: $table.turmaId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get mesReferencia => $composableBuilder(
      column: $table.mesReferencia,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get anoReferencia => $composableBuilder(
      column: $table.anoReferencia,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get valor => $composableBuilder(
      column: $table.valor,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataVencimento => $composableBuilder(
      column: $table.dataVencimento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get dataPagamento => $composableBuilder(
      column: $table.dataPagamento,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$MensalidadesTableOrderingComposer extends Composer<
        _$AppDatabase,
        $MensalidadesTable> {
        $$MensalidadesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get matriculaId => $composableBuilder(
      column: $table.matriculaId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get alunoId => $composableBuilder(
      column: $table.alunoId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get turmaId => $composableBuilder(
      column: $table.turmaId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get mesReferencia => $composableBuilder(
      column: $table.mesReferencia,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get anoReferencia => $composableBuilder(
      column: $table.anoReferencia,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get valor => $composableBuilder(
      column: $table.valor,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataVencimento => $composableBuilder(
      column: $table.dataVencimento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get dataPagamento => $composableBuilder(
      column: $table.dataPagamento,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$MensalidadesTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $MensalidadesTable> {
        $$MensalidadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get matriculaId => $composableBuilder(
      column: $table.matriculaId,
      builder: (column) => column);
      
GeneratedColumn<String> get alunoId => $composableBuilder(
      column: $table.alunoId,
      builder: (column) => column);
      
GeneratedColumn<String> get turmaId => $composableBuilder(
      column: $table.turmaId,
      builder: (column) => column);
      
GeneratedColumn<String> get turno => $composableBuilder(
      column: $table.turno,
      builder: (column) => column);
      
GeneratedColumn<int> get mesReferencia => $composableBuilder(
      column: $table.mesReferencia,
      builder: (column) => column);
      
GeneratedColumn<int> get anoReferencia => $composableBuilder(
      column: $table.anoReferencia,
      builder: (column) => column);
      
GeneratedColumn<double> get valor => $composableBuilder(
      column: $table.valor,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataVencimento => $composableBuilder(
      column: $table.dataVencimento,
      builder: (column) => column);
      
GeneratedColumn<String> get estado => $composableBuilder(
      column: $table.estado,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get dataPagamento => $composableBuilder(
      column: $table.dataPagamento,
      builder: (column) => column);
      
GeneratedColumn<String> get observacao => $composableBuilder(
      column: $table.observacao,
      builder: (column) => column);
      
        }
      class $$MensalidadesTableTableManager extends RootTableManager    <_$AppDatabase,
    $MensalidadesTable,
    MensalidadeData,
    $$MensalidadesTableFilterComposer,
    $$MensalidadesTableOrderingComposer,
    $$MensalidadesTableAnnotationComposer,
    $$MensalidadesTableCreateCompanionBuilder,
    $$MensalidadesTableUpdateCompanionBuilder,
    (MensalidadeData,BaseReferences<_$AppDatabase,$MensalidadesTable,MensalidadeData>),
    MensalidadeData,
    PrefetchHooks Function()
    > {
    $$MensalidadesTableTableManager(_$AppDatabase db, $MensalidadesTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$MensalidadesTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$MensalidadesTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$MensalidadesTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> matriculaId = const Value.absent(),Value<String> alunoId = const Value.absent(),Value<String> turmaId = const Value.absent(),Value<String> turno = const Value.absent(),Value<int> mesReferencia = const Value.absent(),Value<int> anoReferencia = const Value.absent(),Value<double> valor = const Value.absent(),Value<DateTime> dataVencimento = const Value.absent(),Value<String> estado = const Value.absent(),Value<DateTime?> dataPagamento = const Value.absent(),Value<String?> observacao = const Value.absent(),})=> MensalidadesCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,matriculaId: matriculaId,alunoId: alunoId,turmaId: turmaId,turno: turno,mesReferencia: mesReferencia,anoReferencia: anoReferencia,valor: valor,dataVencimento: dataVencimento,estado: estado,dataPagamento: dataPagamento,observacao: observacao,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String matriculaId,required String alunoId,required String turmaId,required String turno,required int mesReferencia,required int anoReferencia,required double valor,required DateTime dataVencimento,required String estado,Value<DateTime?> dataPagamento = const Value.absent(),Value<String?> observacao = const Value.absent(),})=> MensalidadesCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,matriculaId: matriculaId,alunoId: alunoId,turmaId: turmaId,turno: turno,mesReferencia: mesReferencia,anoReferencia: anoReferencia,valor: valor,dataVencimento: dataVencimento,estado: estado,dataPagamento: dataPagamento,observacao: observacao,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$MensalidadesTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $MensalidadesTable,
    MensalidadeData,
    $$MensalidadesTableFilterComposer,
    $$MensalidadesTableOrderingComposer,
    $$MensalidadesTableAnnotationComposer,
    $$MensalidadesTableCreateCompanionBuilder,
    $$MensalidadesTableUpdateCompanionBuilder,
    (MensalidadeData,BaseReferences<_$AppDatabase,$MensalidadesTable,MensalidadeData>),
    MensalidadeData,
    PrefetchHooks Function()
    >;typedef $$ConfiguracoesTableCreateCompanionBuilder = ConfiguracoesCompanion Function({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,required String nomeInstituicao,Value<String?> logotipoUrl,required String morada,required String telefone,required String email,required String nif,required String moedaPadrao,required String textoRodapeRelatorio,required String reciboPrefixo,});
typedef $$ConfiguracoesTableUpdateCompanionBuilder = ConfiguracoesCompanion Function({Value<String> id,Value<DateTime> createdAt,Value<DateTime> updatedAt,Value<SyncStatus> syncStatus,Value<String?> createdBy,Value<String?> updatedBy,Value<bool> isDeleted,Value<int> localId,Value<String> nomeInstituicao,Value<String?> logotipoUrl,Value<String> morada,Value<String> telefone,Value<String> email,Value<String> nif,Value<String> moedaPadrao,Value<String> textoRodapeRelatorio,Value<String> reciboPrefixo,});
class $$ConfiguracoesTableFilterComposer extends Composer<
        _$AppDatabase,
        $ConfiguracoesTable> {
        $$ConfiguracoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get nomeInstituicao => $composableBuilder(
      column: $table.nomeInstituicao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get logotipoUrl => $composableBuilder(
      column: $table.logotipoUrl,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get morada => $composableBuilder(
      column: $table.morada,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get telefone => $composableBuilder(
      column: $table.telefone,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get email => $composableBuilder(
      column: $table.email,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get nif => $composableBuilder(
      column: $table.nif,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get moedaPadrao => $composableBuilder(
      column: $table.moedaPadrao,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get textoRodapeRelatorio => $composableBuilder(
      column: $table.textoRodapeRelatorio,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get reciboPrefixo => $composableBuilder(
      column: $table.reciboPrefixo,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$ConfiguracoesTableOrderingComposer extends Composer<
        _$AppDatabase,
        $ConfiguracoesTable> {
        $$ConfiguracoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get nomeInstituicao => $composableBuilder(
      column: $table.nomeInstituicao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get logotipoUrl => $composableBuilder(
      column: $table.logotipoUrl,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get morada => $composableBuilder(
      column: $table.morada,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get telefone => $composableBuilder(
      column: $table.telefone,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get nif => $composableBuilder(
      column: $table.nif,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get moedaPadrao => $composableBuilder(
      column: $table.moedaPadrao,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get textoRodapeRelatorio => $composableBuilder(
      column: $table.textoRodapeRelatorio,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get reciboPrefixo => $composableBuilder(
      column: $table.reciboPrefixo,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$ConfiguracoesTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $ConfiguracoesTable> {
        $$ConfiguracoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
GeneratedColumn<String> get createdBy => $composableBuilder(
      column: $table.createdBy,
      builder: (column) => column);
      
GeneratedColumn<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy,
      builder: (column) => column);
      
GeneratedColumn<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted,
      builder: (column) => column);
      
GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get nomeInstituicao => $composableBuilder(
      column: $table.nomeInstituicao,
      builder: (column) => column);
      
GeneratedColumn<String> get logotipoUrl => $composableBuilder(
      column: $table.logotipoUrl,
      builder: (column) => column);
      
GeneratedColumn<String> get morada => $composableBuilder(
      column: $table.morada,
      builder: (column) => column);
      
GeneratedColumn<String> get telefone => $composableBuilder(
      column: $table.telefone,
      builder: (column) => column);
      
GeneratedColumn<String> get email => $composableBuilder(
      column: $table.email,
      builder: (column) => column);
      
GeneratedColumn<String> get nif => $composableBuilder(
      column: $table.nif,
      builder: (column) => column);
      
GeneratedColumn<String> get moedaPadrao => $composableBuilder(
      column: $table.moedaPadrao,
      builder: (column) => column);
      
GeneratedColumn<String> get textoRodapeRelatorio => $composableBuilder(
      column: $table.textoRodapeRelatorio,
      builder: (column) => column);
      
GeneratedColumn<String> get reciboPrefixo => $composableBuilder(
      column: $table.reciboPrefixo,
      builder: (column) => column);
      
        }
      class $$ConfiguracoesTableTableManager extends RootTableManager    <_$AppDatabase,
    $ConfiguracoesTable,
    ConfiguracaoData,
    $$ConfiguracoesTableFilterComposer,
    $$ConfiguracoesTableOrderingComposer,
    $$ConfiguracoesTableAnnotationComposer,
    $$ConfiguracoesTableCreateCompanionBuilder,
    $$ConfiguracoesTableUpdateCompanionBuilder,
    (ConfiguracaoData,BaseReferences<_$AppDatabase,$ConfiguracoesTable,ConfiguracaoData>),
    ConfiguracaoData,
    PrefetchHooks Function()
    > {
    $$ConfiguracoesTableTableManager(_$AppDatabase db, $ConfiguracoesTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$ConfiguracoesTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$ConfiguracoesTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$ConfiguracoesTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<DateTime> updatedAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),Value<String> nomeInstituicao = const Value.absent(),Value<String?> logotipoUrl = const Value.absent(),Value<String> morada = const Value.absent(),Value<String> telefone = const Value.absent(),Value<String> email = const Value.absent(),Value<String> nif = const Value.absent(),Value<String> moedaPadrao = const Value.absent(),Value<String> textoRodapeRelatorio = const Value.absent(),Value<String> reciboPrefixo = const Value.absent(),})=> ConfiguracoesCompanion(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,nomeInstituicao: nomeInstituicao,logotipoUrl: logotipoUrl,morada: morada,telefone: telefone,email: email,nif: nif,moedaPadrao: moedaPadrao,textoRodapeRelatorio: textoRodapeRelatorio,reciboPrefixo: reciboPrefixo,),
        createCompanionCallback: ({required String id,required DateTime createdAt,required DateTime updatedAt,required SyncStatus syncStatus,Value<String?> createdBy = const Value.absent(),Value<String?> updatedBy = const Value.absent(),Value<bool> isDeleted = const Value.absent(),Value<int> localId = const Value.absent(),required String nomeInstituicao,Value<String?> logotipoUrl = const Value.absent(),required String morada,required String telefone,required String email,required String nif,required String moedaPadrao,required String textoRodapeRelatorio,required String reciboPrefixo,})=> ConfiguracoesCompanion.insert(id: id,createdAt: createdAt,updatedAt: updatedAt,syncStatus: syncStatus,createdBy: createdBy,updatedBy: updatedBy,isDeleted: isDeleted,localId: localId,nomeInstituicao: nomeInstituicao,logotipoUrl: logotipoUrl,morada: morada,telefone: telefone,email: email,nif: nif,moedaPadrao: moedaPadrao,textoRodapeRelatorio: textoRodapeRelatorio,reciboPrefixo: reciboPrefixo,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$ConfiguracoesTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $ConfiguracoesTable,
    ConfiguracaoData,
    $$ConfiguracoesTableFilterComposer,
    $$ConfiguracoesTableOrderingComposer,
    $$ConfiguracoesTableAnnotationComposer,
    $$ConfiguracoesTableCreateCompanionBuilder,
    $$ConfiguracoesTableUpdateCompanionBuilder,
    (ConfiguracaoData,BaseReferences<_$AppDatabase,$ConfiguracoesTable,ConfiguracaoData>),
    ConfiguracaoData,
    PrefetchHooks Function()
    >;typedef $$EvidenciaPagamentosTableCreateCompanionBuilder = EvidenciaPagamentosCompanion Function({Value<int> localId,required String id,required String tipoArquivo,required String nomeArquivo,Value<String?> urlRemota,required String caminhoLocal,required int tamanhoBytes,required String mimeType,required DateTime createdAt,required SyncStatus syncStatus,});
typedef $$EvidenciaPagamentosTableUpdateCompanionBuilder = EvidenciaPagamentosCompanion Function({Value<int> localId,Value<String> id,Value<String> tipoArquivo,Value<String> nomeArquivo,Value<String?> urlRemota,Value<String> caminhoLocal,Value<int> tamanhoBytes,Value<String> mimeType,Value<DateTime> createdAt,Value<SyncStatus> syncStatus,});
class $$EvidenciaPagamentosTableFilterComposer extends Composer<
        _$AppDatabase,
        $EvidenciaPagamentosTable> {
        $$EvidenciaPagamentosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get tipoArquivo => $composableBuilder(
      column: $table.tipoArquivo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get nomeArquivo => $composableBuilder(
      column: $table.nomeArquivo,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get urlRemota => $composableBuilder(
      column: $table.urlRemota,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get caminhoLocal => $composableBuilder(
      column: $table.caminhoLocal,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get tamanhoBytes => $composableBuilder(
      column: $table.tamanhoBytes,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<SyncStatus,SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
        }
      class $$EvidenciaPagamentosTableOrderingComposer extends Composer<
        _$AppDatabase,
        $EvidenciaPagamentosTable> {
        $$EvidenciaPagamentosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get tipoArquivo => $composableBuilder(
      column: $table.tipoArquivo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get nomeArquivo => $composableBuilder(
      column: $table.nomeArquivo,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get urlRemota => $composableBuilder(
      column: $table.urlRemota,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get caminhoLocal => $composableBuilder(
      column: $table.caminhoLocal,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get tamanhoBytes => $composableBuilder(
      column: $table.tamanhoBytes,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$EvidenciaPagamentosTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $EvidenciaPagamentosTable> {
        $$EvidenciaPagamentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get localId => $composableBuilder(
      column: $table.localId,
      builder: (column) => column);
      
GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get tipoArquivo => $composableBuilder(
      column: $table.tipoArquivo,
      builder: (column) => column);
      
GeneratedColumn<String> get nomeArquivo => $composableBuilder(
      column: $table.nomeArquivo,
      builder: (column) => column);
      
GeneratedColumn<String> get urlRemota => $composableBuilder(
      column: $table.urlRemota,
      builder: (column) => column);
      
GeneratedColumn<String> get caminhoLocal => $composableBuilder(
      column: $table.caminhoLocal,
      builder: (column) => column);
      
GeneratedColumn<int> get tamanhoBytes => $composableBuilder(
      column: $table.tamanhoBytes,
      builder: (column) => column);
      
GeneratedColumn<String> get mimeType => $composableBuilder(
      column: $table.mimeType,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<SyncStatus,int> get syncStatus => $composableBuilder(
      column: $table.syncStatus,
      builder: (column) => column);
      
        }
      class $$EvidenciaPagamentosTableTableManager extends RootTableManager    <_$AppDatabase,
    $EvidenciaPagamentosTable,
    EvidenciaPagamentoData,
    $$EvidenciaPagamentosTableFilterComposer,
    $$EvidenciaPagamentosTableOrderingComposer,
    $$EvidenciaPagamentosTableAnnotationComposer,
    $$EvidenciaPagamentosTableCreateCompanionBuilder,
    $$EvidenciaPagamentosTableUpdateCompanionBuilder,
    (EvidenciaPagamentoData,BaseReferences<_$AppDatabase,$EvidenciaPagamentosTable,EvidenciaPagamentoData>),
    EvidenciaPagamentoData,
    PrefetchHooks Function()
    > {
    $$EvidenciaPagamentosTableTableManager(_$AppDatabase db, $EvidenciaPagamentosTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$EvidenciaPagamentosTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$EvidenciaPagamentosTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$EvidenciaPagamentosTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> localId = const Value.absent(),Value<String> id = const Value.absent(),Value<String> tipoArquivo = const Value.absent(),Value<String> nomeArquivo = const Value.absent(),Value<String?> urlRemota = const Value.absent(),Value<String> caminhoLocal = const Value.absent(),Value<int> tamanhoBytes = const Value.absent(),Value<String> mimeType = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<SyncStatus> syncStatus = const Value.absent(),})=> EvidenciaPagamentosCompanion(localId: localId,id: id,tipoArquivo: tipoArquivo,nomeArquivo: nomeArquivo,urlRemota: urlRemota,caminhoLocal: caminhoLocal,tamanhoBytes: tamanhoBytes,mimeType: mimeType,createdAt: createdAt,syncStatus: syncStatus,),
        createCompanionCallback: ({Value<int> localId = const Value.absent(),required String id,required String tipoArquivo,required String nomeArquivo,Value<String?> urlRemota = const Value.absent(),required String caminhoLocal,required int tamanhoBytes,required String mimeType,required DateTime createdAt,required SyncStatus syncStatus,})=> EvidenciaPagamentosCompanion.insert(localId: localId,id: id,tipoArquivo: tipoArquivo,nomeArquivo: nomeArquivo,urlRemota: urlRemota,caminhoLocal: caminhoLocal,tamanhoBytes: tamanhoBytes,mimeType: mimeType,createdAt: createdAt,syncStatus: syncStatus,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$EvidenciaPagamentosTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $EvidenciaPagamentosTable,
    EvidenciaPagamentoData,
    $$EvidenciaPagamentosTableFilterComposer,
    $$EvidenciaPagamentosTableOrderingComposer,
    $$EvidenciaPagamentosTableAnnotationComposer,
    $$EvidenciaPagamentosTableCreateCompanionBuilder,
    $$EvidenciaPagamentosTableUpdateCompanionBuilder,
    (EvidenciaPagamentoData,BaseReferences<_$AppDatabase,$EvidenciaPagamentosTable,EvidenciaPagamentoData>),
    EvidenciaPagamentoData,
    PrefetchHooks Function()
    >;class $AppDatabaseManager {
final _$AppDatabase _db;
$AppDatabaseManager(this._db);
$$AlunosTableTableManager get alunos => $$AlunosTableTableManager(_db, _db.alunos);
$$CustosMensaisTableTableManager get custosMensais => $$CustosMensaisTableTableManager(_db, _db.custosMensais);
$$TurmasTableTableManager get turmas => $$TurmasTableTableManager(_db, _db.turmas);
$$AnosLectivosTableTableManager get anosLectivos => $$AnosLectivosTableTableManager(_db, _db.anosLectivos);
$$MatriculasTableTableManager get matriculas => $$MatriculasTableTableManager(_db, _db.matriculas);
$$PagamentosTableTableManager get pagamentos => $$PagamentosTableTableManager(_db, _db.pagamentos);
$$AuditoriasTableTableManager get auditorias => $$AuditoriasTableTableManager(_db, _db.auditorias);
$$NotificacoesInternasTableTableManager get notificacoesInternas => $$NotificacoesInternasTableTableManager(_db, _db.notificacoesInternas);
$$MensalidadesTableTableManager get mensalidades => $$MensalidadesTableTableManager(_db, _db.mensalidades);
$$ConfiguracoesTableTableManager get configuracoes => $$ConfiguracoesTableTableManager(_db, _db.configuracoes);
$$EvidenciaPagamentosTableTableManager get evidenciaPagamentos => $$EvidenciaPagamentosTableTableManager(_db, _db.evidenciaPagamentos);
}
