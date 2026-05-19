import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, debugPrint, defaultTargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Entities
import 'package:edugestao/src/domain/entities/aluno.dart';
import 'package:edugestao/src/domain/entities/ano_lectivo.dart';
import 'package:edugestao/src/domain/entities/turma.dart';
import 'package:edugestao/src/domain/entities/matricula.dart';
import 'package:edugestao/src/domain/entities/mensalidade.dart';
import 'package:edugestao/src/domain/entities/custo.dart';
import 'package:edugestao/src/domain/entities/configuracao.dart';
import 'package:edugestao/src/domain/entities/funcionario.dart';
import 'package:edugestao/src/domain/entities/salario.dart';
import 'package:edugestao/src/domain/entities/ativo_inventario.dart';
import 'package:edugestao/src/domain/entities/nota_avaliacao.dart';
import 'package:edugestao/src/domain/entities/horario_aula.dart';
import 'package:edugestao/src/domain/entities/sync_entity.dart';

// Data Layer
import 'package:edugestao/src/data/local/drift/app_database.dart';
import 'package:edugestao/src/data/local/drift/mappers/aluno_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/ano_lectivo_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/turma_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/matricula_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/mensalidade_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/custo_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/config_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/funcionario_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/salario_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/ativo_inventario_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/nota_avaliacao_mapper.dart';
import 'package:edugestao/src/data/local/drift/mappers/horario_aula_mapper.dart';

// Providers & Services
import 'package:edugestao/src/core/providers/database_provider.dart';
import 'package:edugestao/src/shared/firebase_service.dart';
import 'package:edugestao/src/state/session.dart';

final isSyncingProvider = StateProvider<bool>((ref) => false);

/// Verifica se o Cloud Firestore está disponível nesta plataforma.
bool get isAutomaticCloudSyncSupported {
  if (!isCloudFirestoreSupported) return false;
  if (kIsWeb) return true;
  return defaultTargetPlatform != TargetPlatform.windows;
}

bool get isConnectivitySyncSupported {
  if (kIsWeb) return true;
  return true;
}

bool get isInitialCloudPullSupported {
  if (!isCloudFirestoreSupported) return false;
  if (kIsWeb) return true;
  return defaultTargetPlatform != TargetPlatform.windows;
}

class SyncService {
  final Ref _ref;
  StreamSubscription? _connectivitySubscription;
  final List<StreamSubscription> _realtimeSubscriptions = [];
  bool _syncAllInProgress = false;
  bool _pullAlunosInProgress = false;

  SyncService(this._ref) {
    _init();
  }

  AppDatabase get _db => _ref.read(databaseProvider);
  FirebaseService get _firebaseService => _ref.read(firebaseServiceProvider);
  
  // Guardamos o acesso ao Firestore para evitar erros em plataformas não suportadas
  FirebaseFirestore get _firestore {
    if (!isCloudFirestoreSupported) {
      throw StateError('Cloud Firestore não está disponível nesta plataforma.');
    }
    return _firebaseService.db;
  }

  void _init() {
    if (!isConnectivitySyncSupported) {
      return;
    }

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        syncLocalToCloud();
      }
    });
  }

  void startRealtimeListeners() {
    if (!isAutomaticCloudSyncSupported) {
      return;
    }

    _stopRealtimeListeners();
    final collections = [
      'alunos',
      'turmas',
      'mensalidades',
      'custos',
      'configuracoes',
      'anosLectivos',
      'funcionarios',
      'salarios',
      'ativosInventario',
      'presencasFuncionarios',
      'manutencoesAtivo',
      'notasAvaliacao',
      'horariosAula',
      'notificacoesInternas',
    ];
    
    for (var coll in collections) {
      _realtimeSubscriptions.add(
        _firestore.collection(coll).snapshots().listen((snapshot) async {
          if (_syncAllInProgress) return;
          if (snapshot.docChanges.isEmpty) return;
          _ref.read(isSyncingProvider.notifier).state = true;
          try {
            await _pullCollection(coll);
          } finally {
            _ref.read(isSyncingProvider.notifier).state = false;
          }
        }, onError: (e) => debugPrint('Erro Realtime ($coll): $e')),
      );
    }
  }

  Future<void> _pullCollection(String coll) async {
    switch (coll) {
      case 'alunos': await pullAlunos(); break;
      case 'turmas': await pullTurmas(); break;
      case 'mensalidades': await pullMensalidades(); break;
      case 'custos': await pullCustos(); break;
      case 'configuracoes': await pullConfig(); break;
      case 'anosLectivos': await pullAnosLectivos(); break;
      case 'funcionarios': await pullFuncionarios(); break;
      case 'salarios': await pullSalarios(); break;
      case 'ativosInventario': await pullAtivosInventario(); break;
      case 'presencasFuncionarios': await pullPresencasFuncionarios(); break;
      case 'manutencoesAtivo': await pullManutencoesAtivo(); break;
      case 'notasAvaliacao': await pullNotasAvaliacao(); break;
      case 'horariosAula': await pullHorariosAula(); break;
      case 'notificacoesInternas': await pullNotificacoesInternas(); break;
    }
  }

  /// Procura aluno local por número (exacto ou TRIM para dados legados).
  Future<AlunoData?> _findLocalAlunoByNumero(String numero) async {
    final exact =
        await (_db.select(_db.alunos)..where((t) => t.numeroAluno.equals(numero))).get();
    if (exact.isNotEmpty) return exact.first;

    final trimmed = await _db.customSelect(
      'SELECT local_id FROM alunos WHERE TRIM(numero_aluno) = ? LIMIT 1',
      variables: [Variable<String>(numero)],
      readsFrom: {_db.alunos},
    ).getSingleOrNull();
    if (trimmed == null) return null;

    final localId = trimmed.read<int>('local_id');
    return await (_db.select(_db.alunos)..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
  }

  /// Upsert de aluno vindo da nuvem: `numero_aluno` é a chave de negócio; evita UNIQUE em pull.
  Future<void> _upsertAlunoFromPull(Aluno entity) async {
    var numero = entity.numeroAluno.trim();
    if (numero.isEmpty) {
      final suffix = entity.id.replaceAll('-', '');
      numero = 'CLD-${suffix.substring(0, suffix.length.clamp(0, 8))}';
    }
    entity.numeroAluno = numero;

    final existingById =
        await (_db.select(_db.alunos)..where((t) => t.id.equals(entity.id))).getSingleOrNull();
    final existingByNumero = await _findLocalAlunoByNumero(numero);

    if (existingByNumero != null &&
        existingById != null &&
        existingByNumero.localId != existingById.localId) {
      await (_db.update(_db.alunos)..where((t) => t.localId.equals(existingById.localId))).write(
        AlunosCompanion(
          isDeleted: const Value(true),
          syncStatus: const Value(SyncStatus.synced),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    final target = existingByNumero ?? existingById;
    final companion = entity.toCompanion();

    if (target != null) {
      await (_db.update(_db.alunos)..where((t) => t.localId.equals(target.localId))).write(
        companion.copyWith(localId: Value(target.localId)),
      );
      return;
    }

    await _db.into(_db.alunos).insert(
      companion,
      onConflict: DoUpdate(
        (_) => companion,
        target: [_db.alunos.numeroAluno],
      ),
    );
  }

  void _stopRealtimeListeners() {
    for (var sub in _realtimeSubscriptions) { sub.cancel(); }
    _realtimeSubscriptions.clear();
  }

  Future<void> syncAll() async {
    if (_syncAllInProgress) {
      debugPrint('SyncService: syncAll já em execução, ignorando chamada duplicada.');
      return;
    }
    _syncAllInProgress = true;

    debugPrint('SyncService: Iniciando syncAll...');
    if (!isInitialCloudPullSupported) {
      debugPrint('SyncService: SyncAll ignorado: Firestore não disponível nesta plataforma.');
      try {
        await syncLocalToCloud();
      } finally {
        _syncAllInProgress = false;
      }
      return;
    }

    final session = _ref.read(sessionProvider);
    if (!session.isAuthenticated) {
      debugPrint('SyncService: SyncAll abortado: Usuário não autenticado.');
      _syncAllInProgress = false;
      return;
    }

    _ref.read(isSyncingProvider.notifier).state = true;
    try {
      await pullAnosLectivos();
      await pullAlunos();
      await pullTurmas();
      await pullMatriculas();
      await pullMensalidades();
      await pullCustos();
      await pullConfig();
      await pullFuncionarios();
      await pullSalarios();
      await pullAtivosInventario();
      await pullPresencasFuncionarios();
      await pullManutencoesAtivo();
      await pullNotasAvaliacao();
      await pullHorariosAula();
      await pullNotificacoesInternas();
      await syncLocalToCloud();
    } catch (e) {
      debugPrint('Erro no syncAll: $e');
    } finally {
      _syncAllInProgress = false;
      _ref.read(isSyncingProvider.notifier).state = false;
    }
  }

  Future<String> syncManualSafe() async {
    if (!isCloudFirestoreSupported) {
      return 'Sincronização em nuvem não disponível nesta plataforma.';
    }

    if (defaultTargetPlatform == TargetPlatform.windows) {
      await syncLocalToCloud();
      return 'Upload de dados locais concluído.';
    }

    await syncAll();
    return 'Sincronização manual concluída.';
  }

  Future<void> seedAnoLectivo({
    required String id,
    required String ano,
    required DateTime dataInicio,
    required DateTime dataFim,
    bool isActive = true,
  }) async {
    if (!isAutomaticCloudSyncSupported) return;

    try {
      final ref = _firestore.collection('anosLectivos').doc(id);
      final doc = await ref.get();
      if (doc.exists) return;

      final now = DateTime.now();
      await ref.set({
        'id': id,
        'ano': ano,
        'dataInicio': dataInicio.toIso8601String(),
        'dataFim': dataFim.toIso8601String(),
        'isActive': isActive,
        'isDeleted': false,
        'createdAt': now,
        'updatedAt': now,
      });

      await pullAnosLectivos();
    } catch (e) {
      debugPrint('Erro Seed Ano Lectivo: $e');
    }
  }

  // --- PULL METHODS ---

  Future<void> pullAnosLectivos() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('anosLectivos').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = AnoLectivo()
          ..id = doc.id
          ..ano = data['ano'] ?? ''
          ..dataInicio = (data['dataInicio'] is Timestamp)
              ? (data['dataInicio'] as Timestamp).toDate()
              : DateTime.tryParse(data['dataInicio'] ?? '') ?? DateTime.now()
          ..dataFim = (data['dataFim'] is Timestamp)
              ? (data['dataFim'] as Timestamp).toDate()
              : DateTime.tryParse(data['dataFim'] ?? '') ?? DateTime.now()
          ..isActive = data['isActive'] ?? false
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..updatedAt = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.anosLectivos)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
            ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
            : entity.toCompanion();

        await _db.into(_db.anosLectivos).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Anos Lectivos: $e');
    }
  }

  Future<void> pullAlunos() async {
    if (!isInitialCloudPullSupported) return;
    if (_pullAlunosInProgress) {
      debugPrint('SyncService: pullAlunos já em execução, ignorando.');
      return;
    }
    _pullAlunosInProgress = true;
    try {
      final snap = await _firestore.collection('alunos').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = Aluno()
          ..id = doc.id
          ..nomeCompleto = data['nomeCompleto'] ?? ''
          ..numeroAluno = data['numeroAluno'] ?? ''
          ..dataNascimento = DateTime.parse(data['dataNascimento'] ?? DateTime.now().toIso8601String())
          ..sexo = data['sexo'] ?? 'M'
          ..morada = data['morada'] ?? ''
          ..escolaQueFrequenta = data['escolaQueFrequenta'] ?? ''
          ..anoEscolaridade = data['anoEscolaridade'] ?? ''
          ..possuiCondicaoMedica = data['possuiCondicaoMedica'] ?? false
          ..descricaoCondicaoMedica = data['descricaoCondicaoMedica']
          ..nomeEncarregado = data['nomeEncarregado'] ?? ''
          ..telefonePrincipal = data['telefonePrincipal'] ?? ''
          ..telefoneAlternativo = data['telefoneAlternativo']
          ..email = data['email']
          ..status = AlunoStatus.values.byName(data['status'] ?? 'ativo')
          ..dataInscricao = DateTime.parse(data['dataInscricao'] ?? DateTime.now().toIso8601String())
          ..observacoes = data['observacoes']
          ..valorPagamentoInscricao = (data['valorPagamentoInscricao'] ?? 0).toDouble()
          ..isentoPagamento = data['isentoPagamento'] ?? false
          ..comprovativoInscricaoUrl = data['comprovativoInscricaoUrl']
          ..comprovativoInscricaoLocal = data['comprovativoInscricaoLocal']
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..updatedAt = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..syncStatus = SyncStatus.synced;

        try {
          await _upsertAlunoFromPull(entity);
        } catch (e, st) {
          debugPrint('Erro Pull Aluno ${doc.id}: $e\n$st');
        }
      }
    } catch (e) {
      debugPrint('Erro Pull Alunos: $e');
    } finally {
      _pullAlunosInProgress = false;
    }
  }

  Future<void> pullTurmas() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('turmas').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = Turma()
          ..id = doc.id
          ..nomeTurma = data['nomeTurma'] ?? ''
          ..limiteAlunos = data['limiteAlunos'] ?? 15
          ..turno = data['turno'] ?? 'Manhã'
          ..numeroSala = data['numeroSala'] ?? ''
          ..ativa = data['ativa'] ?? true
          ..anoLectivoId = data['anoLectivoId'] ?? ''
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..updatedAt = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.turmas)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
          ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
          : entity.toCompanion();

        await _db.into(_db.turmas).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Turmas: $e');
    }
  }

  Future<void> pullMatriculas() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('matriculas').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = Matricula()
          ..id = doc.id
          ..numeroMatricula = data['numeroMatricula'] ?? ''
          ..alunoId = data['alunoId'] ?? ''
          ..turmaId = data['turmaId'] ?? ''
          ..turno = data['turno'] ?? ''
          ..anoLectivo = data['anoLectivo'] ?? ''
          ..valorMensalidade = (data['valorMensalidade'] ?? 0).toDouble()
          ..diaVencimento = data['diaVencimento'] ?? 10
          ..dataMatricula = DateTime.parse(data['dataMatricula'] ?? DateTime.now().toIso8601String())
          ..estado = data['estado'] ?? 'ativa'
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..updatedAt = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.matriculas)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
          ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
          : entity.toCompanion();

        await _db.into(_db.matriculas).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Matriculas: $e');
    }
  }

  Future<void> pullMensalidades() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('mensalidades').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = Mensalidade()
          ..id = doc.id
          ..matriculaId = data['matriculaId'] ?? ''
          ..alunoId = data['alunoId'] ?? ''
          ..turmaId = data['turmaId'] ?? ''
          ..turno = data['turno'] ?? ''
          ..mesReferencia = data['mesReferencia'] ?? 1
          ..anoReferencia = data['anoReferencia'] ?? 2024
          ..valor = (data['valor'] ?? 0).toDouble()
          ..dataVencimento = (data['dataVencimento'] as Timestamp).toDate()
          ..estado = data['estado'] ?? 'pendente'
          ..dataPagamento = (data['dataPagamento'] as Timestamp?)?.toDate()
          ..observacao = data['observacao']
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..updatedAt = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.mensalidades)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
          ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
          : entity.toCompanion();

        await _db.into(_db.mensalidades).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Mensalidades: $e');
    }
  }

  Future<void> pullCustos() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('custos').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = CustoMensal()
          ..id = doc.id
          ..descricao = data['descricao'] ?? ''
          ..categoria = data['categoria'] ?? ''
          ..valor = (data['valor'] ?? 0).toDouble()
          ..data = DateTime.parse(data['data'] ?? DateTime.now().toIso8601String())
          ..tipo = data['tipo'] ?? 'VARIAVEL'
          ..mesReferencia = data['mesReferencia'] ?? 1
          ..anoReferencia = data['anoReferencia'] ?? 2024
          ..estado = data['estado'] ?? 'PENDENTE'
          ..responsavelId = data['responsavelId'] ?? ''
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..updatedAt = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.custosMensais)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
          ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
          : entity.toCompanion();

        await _db.into(_db.custosMensais).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Custos: $e');
    }
  }

  Future<void> pullConfig() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('configuracoes').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = ConfiguracaoInstitucional()
          ..id = doc.id
          ..nomeInstituicao = data['nomeInstituicao'] ?? ''
          ..logotipoUrl = data['logotipoUrl']
          ..morada = data['morada'] ?? ''
          ..telefone = data['telefone'] ?? ''
          ..email = data['email'] ?? ''
          ..nif = data['nif'] ?? ''
          ..moedaPadrao = data['moedaPadrao'] ?? 'Kz'
          ..textoRodapeRelatorio = data['textoRodapeRelatorio'] ?? ''
          ..reciboPrefixo = data['reciboPrefixo'] ?? 'REC-'
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..updatedAt = (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now()
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.configuracoes)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
          ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
          : entity.toCompanion();

        await _db.into(_db.configuracoes).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Config: $e');
    }
  }

  // --- PUSH METHODS ---

  Future<void> syncLocalToCloud() async {
    if (!isAutomaticCloudSyncSupported) return;

    final session = _ref.read(sessionProvider);
    if (!session.isAuthenticated) return;
    final userId = session.firebaseUser!.uid;

    _ref.read(isSyncingProvider.notifier).state = true;
    try {
      await _syncAnosLectivos(userId);
      await _syncAlunos(userId);
      await _syncTurmas(userId);
      await _syncMatriculas(userId);
      await _syncMensalidades(userId);
      await _syncCustos(userId);
      await _syncConfig(userId);
      await _syncFuncionarios(userId);
      await _syncSalarios(userId);
      await _syncAtivosInventario(userId);
      await _syncNotasAvaliacao(userId);
      await _syncHorariosAula(userId);
      await _syncNotificacoesInternas(userId);
    } catch (e) {
      debugPrint('Erro Sync Local to Cloud: $e');
    } finally {
      _ref.read(isSyncingProvider.notifier).state = false;
    }
  }

  Future<void> _syncAnosLectivos(String userId) async {
    final query = _db.select(_db.anosLectivos)..where((t) => t.syncStatus.equals(SyncStatus.pendingSync.index));
    final rows = await query.get();
    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('anosLectivos').doc(entity.id).set({
          'id': entity.id,
          'ano': entity.ano,
          'dataInicio': entity.dataInicio.toIso8601String(),
          'dataFim': entity.dataFim.toIso8601String(),
          'isActive': entity.isActive,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));
        await _db.update(_db.anosLectivos).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push AnoLectivo: $e');
      }
    }
  }

  Future<void> _syncAlunos(String userId) async {
    final query = _db.select(_db.alunos)..where((t) => t.syncStatus.equals(SyncStatus.pendingSync.index));
    final rows = await query.get();

    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('alunos').doc(entity.id).set({
          'id': entity.id,
          'nomeCompleto': entity.nomeCompleto,
          'numeroAluno': entity.numeroAluno,
          'dataNascimento': entity.dataNascimento.toIso8601String(),
          'sexo': entity.sexo,
          'morada': entity.morada,
          'escolaQueFrequenta': entity.escolaQueFrequenta,
          'anoEscolaridade': entity.anoEscolaridade,
          'possuiCondicaoMedica': entity.possuiCondicaoMedica,
          'descricaoCondicaoMedica': entity.descricaoCondicaoMedica,
          'nomeEncarregado': entity.nomeEncarregado,
          'telefonePrincipal': entity.telefonePrincipal,
          'telefoneAlternativo': entity.telefoneAlternativo,
          'email': entity.email,
          'status': entity.status.name,
          'dataInscricao': entity.dataInscricao.toIso8601String(),
          'observacoes': entity.observacoes,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));

        await _db.update(_db.alunos).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Aluno: $e');
      }
    }
  }

  Future<void> _syncTurmas(String userId) async {
    final query = _db.select(_db.turmas)..where((t) => t.syncStatus.equals(SyncStatus.pendingSync.index));
    final rows = await query.get();

    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('turmas').doc(entity.id).set({
          'id': entity.id,
          'nomeTurma': entity.nomeTurma,
          'limiteAlunos': entity.limiteAlunos,
          'turno': entity.turno,
          'numeroSala': entity.numeroSala,
          'ativa': entity.ativa,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));

        await _db.update(_db.turmas).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Turma: $e');
      }
    }
  }

  Future<void> _syncMatriculas(String userId) async {
    final query = _db.select(_db.matriculas)..where((t) => t.syncStatus.equals(SyncStatus.pendingSync.index));
    final rows = await query.get();

    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('matriculas').doc(entity.id).set({
          'id': entity.id,
          'numeroMatricula': entity.numeroMatricula,
          'alunoId': entity.alunoId,
          'turmaId': entity.turmaId,
          'turno': entity.turno,
          'anoLectivo': entity.anoLectivo,
          'valorMensalidade': entity.valorMensalidade,
          'diaVencimento': entity.diaVencimento,
          'dataMatricula': entity.dataMatricula.toIso8601String(),
          'estado': entity.estado,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));

        await _db.update(_db.matriculas).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Matrícula: $e');
      }
    }
  }

  Future<void> _syncMensalidades(String userId) async {
    final query = _db.select(_db.mensalidades)..where((t) => t.syncStatus.equals(SyncStatus.pendingSync.index));
    final rows = await query.get();

    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('mensalidades').doc(entity.id).set({
          'id': entity.id,
          'matriculaId': entity.matriculaId,
          'alunoId': entity.alunoId,
          'turmaId': entity.turmaId,
          'turno': entity.turno,
          'mesReferencia': entity.mesReferencia,
          'anoReferencia': entity.anoReferencia,
          'valor': entity.valor,
          'dataVencimento': Timestamp.fromDate(entity.dataVencimento),
          'estado': entity.estado,
          'dataPagamento': entity.dataPagamento != null ? Timestamp.fromDate(entity.dataPagamento!) : null,
          'observacao': entity.observacao,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));

        await _db.update(_db.mensalidades).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Mensalidade: $e');
      }
    }
  }

  Future<void> _syncCustos(String userId) async {
    final query = _db.select(_db.custosMensais)..where((t) => t.syncStatus.equals(SyncStatus.pendingSync.index));
    final rows = await query.get();

    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('custos').doc(entity.id).set({
          'id': entity.id,
          'descricao': entity.descricao,
          'categoria': entity.categoria,
          'valor': entity.valor,
          'data': entity.data.toIso8601String(),
          'tipo': entity.tipo,
          'mesReferencia': entity.mesReferencia,
          'anoReferencia': entity.anoReferencia,
          'estado': entity.estado,
          'responsavelId': entity.responsavelId,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));

        await _db.update(_db.custosMensais).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Custo: $e');
      }
    }
  }

  Future<void> _syncConfig(String userId) async {
    final query = _db.select(_db.configuracoes)..where((t) => t.syncStatus.equals(SyncStatus.pendingSync.index));
    final rows = await query.get();

    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('configuracoes').doc(entity.id).set({
          'id': entity.id,
          'nomeInstituicao': entity.nomeInstituicao,
          'logotipoUrl': entity.logotipoUrl,
          'morada': entity.morada,
          'telefone': entity.telefone,
          'email': entity.email,
          'nif': entity.nif,
          'moedaPadrao': entity.moedaPadrao,
          'textoRodapeRelatorio': entity.textoRodapeRelatorio,
          'reciboPrefixo': entity.reciboPrefixo,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));

        await _db.update(_db.configuracoes).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Config: $e');
      }
    }
  }

  Future<void> pullFuncionarios() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('funcionarios').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = Funcionario()
          ..id = doc.id
          ..numeroFuncionario = data['numeroFuncionario'] ?? ''
          ..nomeCompleto = data['nomeCompleto'] ?? ''
          ..cargo = data['cargo'] ?? ''
          ..email = data['email']
          ..telefone = data['telefone'] ?? ''
          ..documentoIdentidade = data['documentoIdentidade']
          ..dataAdmissao = _parseDate(data['dataAdmissao'])
          ..salarioBase = (data['salarioBase'] ?? 0).toDouble()
          ..status = FuncionarioStatus.values.firstWhere(
            (e) => e.name == (data['status'] ?? 'ativo'),
            orElse: () => FuncionarioStatus.ativo,
          )
          ..ultimaPresenca = data['ultimaPresenca'] != null ? _parseDate(data['ultimaPresenca']) : null
          ..observacoes = data['observacoes']
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = _parseDate(data['createdAt'])
          ..updatedAt = _parseDate(data['updatedAt'])
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.funcionarios)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
            ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
            : entity.toCompanion();
        await _db.into(_db.funcionarios).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Funcionarios: $e');
    }
  }

  Future<void> pullSalarios() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('salarios').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = Salario()
          ..id = doc.id
          ..funcionarioId = data['funcionarioId'] ?? ''
          ..funcionarioNome = data['funcionarioNome'] ?? ''
          ..mesReferencia = data['mesReferencia'] ?? 1
          ..anoReferencia = data['anoReferencia'] ?? DateTime.now().year
          ..valorBase = (data['valorBase'] ?? 0).toDouble()
          ..descontos = (data['descontos'] ?? 0).toDouble()
          ..bonus = (data['bonus'] ?? 0).toDouble()
          ..valorLiquido = (data['valorLiquido'] ?? 0).toDouble()
          ..estado = SalarioEstado.values.firstWhere(
            (e) => e.name == (data['estado'] ?? 'pendente'),
            orElse: () => SalarioEstado.pendente,
          )
          ..dataPagamento = data['dataPagamento'] != null ? _parseDate(data['dataPagamento']) : null
          ..observacao = data['observacao']
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = _parseDate(data['createdAt'])
          ..updatedAt = _parseDate(data['updatedAt'])
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.salarios)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
            ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
            : entity.toCompanion();
        await _db.into(_db.salarios).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Salarios: $e');
    }
  }

  Future<void> pullAtivosInventario() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('ativosInventario').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = AtivoInventario()
          ..id = doc.id
          ..codigo = data['codigo'] ?? ''
          ..nome = data['nome'] ?? ''
          ..categoria = data['categoria'] ?? ''
          ..localizacao = data['localizacao'] ?? ''
          ..estado = AtivoEstado.values.firstWhere(
            (e) => e.name == (data['estado'] ?? 'bom'),
            orElse: () => AtivoEstado.bom,
          )
          ..valorAquisicao = (data['valorAquisicao'] ?? 0).toDouble()
          ..dataAquisicao = _parseDate(data['dataAquisicao'])
          ..ultimaManutencao = data['ultimaManutencao'] != null ? _parseDate(data['ultimaManutencao']) : null
          ..observacoes = data['observacoes']
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = _parseDate(data['createdAt'])
          ..updatedAt = _parseDate(data['updatedAt'])
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.ativosInventario)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
            ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
            : entity.toCompanion();
        await _db.into(_db.ativosInventario).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Ativos: $e');
    }
  }

  Future<void> pullPresencasFuncionarios() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snapshot = await _firestore.collection('presencasFuncionarios').get();
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final id = doc.id;
        final companion = PresencasFuncionariosCompanion(
          id: Value(id),
          funcionarioId: Value(data['funcionarioId']?.toString() ?? ''),
          data: Value(_parseDate(data['data'])),
          presente: Value(data['presente'] == true),
          observacao: Value(data['observacao']?.toString()),
        );
        final existing = await (_db.select(_db.presencasFuncionarios)..where((t) => t.id.equals(id))).get();
        if (existing.isNotEmpty) {
          await (_db.update(_db.presencasFuncionarios)..where((t) => t.localId.equals(existing.first.localId)))
              .write(companion);
        } else {
          await _db.into(_db.presencasFuncionarios).insert(
            PresencasFuncionariosCompanion.insert(
              id: id,
              funcionarioId: data['funcionarioId']?.toString() ?? '',
              data: _parseDate(data['data']),
              presente: data['presente'] == true,
              observacao: Value(data['observacao']?.toString()),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro Pull Presencas: $e');
    }
  }

  Future<void> pullManutencoesAtivo() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snapshot = await _firestore.collection('manutencoesAtivo').get();
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final id = doc.id;
        final companion = ManutencoesAtivoCompanion(
          id: Value(id),
          ativoId: Value(data['ativoId']?.toString() ?? ''),
          data: Value(_parseDate(data['data'])),
          descricao: Value(data['descricao']?.toString() ?? ''),
          custo: Value((data['custo'] ?? 0).toDouble()),
          realizadoPor: Value(data['realizadoPor']?.toString()),
        );
        final existing = await (_db.select(_db.manutencoesAtivo)..where((t) => t.id.equals(id))).get();
        if (existing.isNotEmpty) {
          await (_db.update(_db.manutencoesAtivo)..where((t) => t.localId.equals(existing.first.localId)))
              .write(companion);
        } else {
          await _db.into(_db.manutencoesAtivo).insert(
            ManutencoesAtivoCompanion.insert(
              id: id,
              ativoId: data['ativoId']?.toString() ?? '',
              data: _parseDate(data['data']),
              descricao: data['descricao']?.toString() ?? '',
              custo: (data['custo'] ?? 0).toDouble(),
              realizadoPor: Value(data['realizadoPor']?.toString()),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro Pull Manutencoes: $e');
    }
  }

  Future<void> pullNotasAvaliacao() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('notasAvaliacao').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = NotaAvaliacao()
          ..id = doc.id
          ..alunoId = data['alunoId'] ?? ''
          ..disciplina = data['disciplina'] ?? ''
          ..trimestre = data['trimestre'] ?? 1
          ..anoLectivo = data['anoLectivo'] ?? ''
          ..valor = (data['valor'] ?? 0).toDouble()
          ..observacao = data['observacao']
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = _parseDate(data['createdAt'])
          ..updatedAt = _parseDate(data['updatedAt'])
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.notasAvaliacao)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
            ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
            : entity.toCompanion();
        await _db.into(_db.notasAvaliacao).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Notas: $e');
    }
  }

  Future<void> pullHorariosAula() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('horariosAula').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final entity = HorarioAula()
          ..id = doc.id
          ..turmaId = data['turmaId'] ?? ''
          ..diaSemana = data['diaSemana'] ?? 1
          ..horaInicio = data['horaInicio'] ?? ''
          ..horaFim = data['horaFim'] ?? ''
          ..disciplina = data['disciplina'] ?? ''
          ..professor = data['professor']
          ..isDeleted = data['isDeleted'] ?? false
          ..createdAt = _parseDate(data['createdAt'])
          ..updatedAt = _parseDate(data['updatedAt'])
          ..syncStatus = SyncStatus.synced;

        final existing = await (_db.select(_db.horariosAula)..where((t) => t.id.equals(entity.id))).get();
        final companion = existing.isNotEmpty
            ? entity.toCompanion().copyWith(localId: Value(existing.first.localId))
            : entity.toCompanion();
        await _db.into(_db.horariosAula).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Horarios: $e');
    }
  }

  DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }

  Future<void> _syncFuncionarios(String userId) async {
    final query = _db.select(_db.funcionarios)
      ..where((t) =>
          t.syncStatus.equals(SyncStatus.pendingSync.index) |
          t.syncStatus.equals(SyncStatus.localOnly.index));
    final rows = await query.get();
    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('funcionarios').doc(entity.id).set({
          'id': entity.id,
          'numeroFuncionario': entity.numeroFuncionario,
          'nomeCompleto': entity.nomeCompleto,
          'cargo': entity.cargo,
          'email': entity.email,
          'telefone': entity.telefone,
          'documentoIdentidade': entity.documentoIdentidade,
          'dataAdmissao': entity.dataAdmissao.toIso8601String(),
          'salarioBase': entity.salarioBase,
          'status': entity.status.name,
          'ultimaPresenca': entity.ultimaPresenca?.toIso8601String(),
          'observacoes': entity.observacoes,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));
        await _db.update(_db.funcionarios).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Funcionario: $e');
      }
    }
  }

  Future<void> _syncSalarios(String userId) async {
    final query = _db.select(_db.salarios)
      ..where((t) =>
          t.syncStatus.equals(SyncStatus.pendingSync.index) |
          t.syncStatus.equals(SyncStatus.localOnly.index));
    final rows = await query.get();
    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('salarios').doc(entity.id).set({
          'id': entity.id,
          'funcionarioId': entity.funcionarioId,
          'funcionarioNome': entity.funcionarioNome,
          'mesReferencia': entity.mesReferencia,
          'anoReferencia': entity.anoReferencia,
          'valorBase': entity.valorBase,
          'descontos': entity.descontos,
          'bonus': entity.bonus,
          'valorLiquido': entity.valorLiquido,
          'estado': entity.estado.name,
          'dataPagamento': entity.dataPagamento?.toIso8601String(),
          'observacao': entity.observacao,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));
        await _db.update(_db.salarios).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Salario: $e');
      }
    }
  }

  Future<void> _syncAtivosInventario(String userId) async {
    final query = _db.select(_db.ativosInventario)
      ..where((t) =>
          t.syncStatus.equals(SyncStatus.pendingSync.index) |
          t.syncStatus.equals(SyncStatus.localOnly.index));
    final rows = await query.get();
    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('ativosInventario').doc(entity.id).set({
          'id': entity.id,
          'codigo': entity.codigo,
          'nome': entity.nome,
          'categoria': entity.categoria,
          'localizacao': entity.localizacao,
          'estado': entity.estado.name,
          'valorAquisicao': entity.valorAquisicao,
          'dataAquisicao': entity.dataAquisicao.toIso8601String(),
          'ultimaManutencao': entity.ultimaManutencao?.toIso8601String(),
          'observacoes': entity.observacoes,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));
        await _db.update(_db.ativosInventario).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Ativo: $e');
      }
    }
  }

  Future<void> pullNotificacoesInternas() async {
    if (!isInitialCloudPullSupported) return;
    try {
      final snap = await _firestore.collection('notificacoesInternas').get();
      for (var doc in snap.docs) {
        final data = doc.data();
        final id = doc.id;
        final existing = await (_db.select(_db.notificacoesInternas)..where((t) => t.id.equals(id))).get();
        if (existing.isNotEmpty) {
          await (_db.update(_db.notificacoesInternas)..where((t) => t.localId.equals(existing.first.localId))).write(
            NotificacoesInternasCompanion(
              titulo: Value(data['titulo']?.toString() ?? ''),
              mensagem: Value(data['mensagem']?.toString() ?? ''),
              tipo: Value(data['tipo']?.toString() ?? 'info'),
              entidadeRelacionada: Value(data['entidadeRelacionada']?.toString()),
              entidadeId: Value(data['entidadeId']?.toString()),
              lida: Value(data['lida'] == true),
            ),
          );
        } else {
          await _db.into(_db.notificacoesInternas).insert(
            NotificacoesInternasCompanion.insert(
              id: id,
              titulo: data['titulo']?.toString() ?? '',
              mensagem: data['mensagem']?.toString() ?? '',
              tipo: data['tipo']?.toString() ?? 'info',
              entidadeRelacionada: Value(data['entidadeRelacionada']?.toString()),
              entidadeId: Value(data['entidadeId']?.toString()),
              lida: Value(data['lida'] == true),
              createdAt: _parseDate(data['createdAt']),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro Pull Notificacoes: $e');
    }
  }

  Future<void> _syncNotificacoesInternas(String userId) async {
    final rows = await _db.select(_db.notificacoesInternas).get();
    for (final row in rows) {
      try {
        await _firestore.collection('notificacoesInternas').doc(row.id).set({
          'id': row.id,
          'titulo': row.titulo,
          'mensagem': row.mensagem,
          'tipo': row.tipo,
          'entidadeRelacionada': row.entidadeRelacionada,
          'entidadeId': row.entidadeId,
          'lida': row.lida,
          'createdAt': row.createdAt.toIso8601String(),
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': userId,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Erro Push Notificacao: $e');
      }
    }
  }

  Future<void> _syncNotasAvaliacao(String userId) async {
    final query = _db.select(_db.notasAvaliacao)
      ..where((t) =>
          t.syncStatus.equals(SyncStatus.pendingSync.index) |
          t.syncStatus.equals(SyncStatus.localOnly.index));
    final rows = await query.get();
    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('notasAvaliacao').doc(entity.id).set({
          'id': entity.id,
          'alunoId': entity.alunoId,
          'disciplina': entity.disciplina,
          'trimestre': entity.trimestre,
          'anoLectivo': entity.anoLectivo,
          'valor': entity.valor,
          'observacao': entity.observacao,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));
        await _db.update(_db.notasAvaliacao).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Nota: $e');
      }
    }
  }

  Future<void> _syncHorariosAula(String userId) async {
    final query = _db.select(_db.horariosAula)
      ..where((t) =>
          t.syncStatus.equals(SyncStatus.pendingSync.index) |
          t.syncStatus.equals(SyncStatus.localOnly.index));
    final rows = await query.get();
    for (final row in rows) {
      final entity = row.toEntity();
      try {
        await _firestore.collection('horariosAula').doc(entity.id).set({
          'id': entity.id,
          'turmaId': entity.turmaId,
          'diaSemana': entity.diaSemana,
          'horaInicio': entity.horaInicio,
          'horaFim': entity.horaFim,
          'disciplina': entity.disciplina,
          'professor': entity.professor,
          'isDeleted': entity.isDeleted,
          'createdAt': entity.createdAt,
          'updatedAt': FieldValue.serverTimestamp(),
          'createdBy': entity.createdBy ?? userId,
        }, SetOptions(merge: true));
        await _db.update(_db.horariosAula).replace(
          entity.toCompanion().copyWith(
            localId: Value(row.localId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } catch (e) {
        debugPrint('Erro Push Horario: $e');
      }
    }
  }

  Future<void> pushPresencaFuncionario({
    required String id,
    required String funcionarioId,
    required DateTime data,
    required bool presente,
    String? observacao,
  }) async {
    if (!isAutomaticCloudSyncSupported) return;
    try {
      await _firestore.collection('presencasFuncionarios').doc(id).set({
        'id': id,
        'funcionarioId': funcionarioId,
        'data': data.toIso8601String(),
        'presente': presente,
        'observacao': observacao,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro Push Presenca: $e');
    }
  }

  Future<void> pushManutencaoAtivo({
    required String id,
    required String ativoId,
    required DateTime data,
    required String descricao,
    required double custo,
    String? realizadoPor,
  }) async {
    if (!isAutomaticCloudSyncSupported) return;
    try {
      await _firestore.collection('manutencoesAtivo').doc(id).set({
        'id': id,
        'ativoId': ativoId,
        'data': data.toIso8601String(),
        'descricao': descricao,
        'custo': custo,
        'realizadoPor': realizadoPor,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erro Push Manutencao: $e');
    }
  }

  Future<void> deleteFromCloud(String collection, String id) async {
    if (!isAutomaticCloudSyncSupported) return;
    try {
      await _firestore.collection(collection).doc(id).delete();
      debugPrint('SyncService: Documento $id removido da colecao $collection na nuvem.');
    } catch (e) {
      debugPrint('Erro ao remover documento da nuvem: $e');
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _stopRealtimeListeners();
  }
}

final syncServiceProvider = Provider((ref) => SyncService(ref));
