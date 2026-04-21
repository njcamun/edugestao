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
    final collections = ['alunos', 'turmas', 'mensalidades', 'custos', 'configuracoes', 'anosLectivos'];
    
    for (var coll in collections) {
      _realtimeSubscriptions.add(
        _firestore.collection(coll).snapshots().listen((snapshot) async {
          if (snapshot.docChanges.isNotEmpty) {
            _ref.read(isSyncingProvider.notifier).state = true;
            await _pullCollection(coll);
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
    }
  }

  Future<int?> _findAlunoLocalId(String id, String numeroAluno) async {
    final rowsById = await (_db.select(_db.alunos)..where((t) => t.id.equals(id))).get();
    if (rowsById.isNotEmpty) return rowsById.first.localId;

    final rowsByNumeroAluno = await (_db.select(_db.alunos)..where((t) => t.numeroAluno.equals(numeroAluno))).get();
    return rowsByNumeroAluno.isNotEmpty ? rowsByNumeroAluno.first.localId : null;
  }

  void _stopRealtimeListeners() {
    for (var sub in _realtimeSubscriptions) { sub.cancel(); }
    _realtimeSubscriptions.clear();
  }

  Future<void> syncAll() async {
    debugPrint('SyncService: Iniciando syncAll...');
    if (!isInitialCloudPullSupported) {
      debugPrint('SyncService: SyncAll ignorado: Firestore não disponível nesta plataforma.');
      // Mesmo assim, tentamos o push se houver internet
      await syncLocalToCloud();
      return;
    }

    final session = _ref.read(sessionProvider);
    if (!session.isAuthenticated) {
      debugPrint('SyncService: SyncAll abortado: Usuário não autenticado.');
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
      await syncLocalToCloud();
    } catch (e) {
      debugPrint('Erro no syncAll: $e');
    } finally {
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

        final localId = await _findAlunoLocalId(entity.id, entity.numeroAluno);
        final companion = localId != null
          ? entity.toCompanion().copyWith(localId: Value(localId))
          : entity.toCompanion();

        await _db.into(_db.alunos).insertOnConflictUpdate(companion);
      }
    } catch (e) {
      debugPrint('Erro Pull Alunos: $e');
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
