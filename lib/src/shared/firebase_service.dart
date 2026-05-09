import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart' as gsiap;
import 'package:flutter/foundation.dart' show TargetPlatform, debugPrint, defaultTargetPlatform, kIsWeb;
import 'package:path/path.dart' as p;

bool get isCloudFirestoreSupported {
  if (kIsWeb) return true;
  if (defaultTargetPlatform == TargetPlatform.windows) return false;
  return true;
}

bool get isCloudAuthSupported {
  if (kIsWeb) return true;
  if (defaultTargetPlatform == TargetPlatform.windows) return false;
  return true;
}

bool get isDesktopPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

const String _googleDesktopClientIdDefine = String.fromEnvironment('GOOGLE_OAUTH_CLIENT_ID');
const String _googleDesktopClientSecretDefine = String.fromEnvironment('GOOGLE_OAUTH_CLIENT_SECRET');

bool _desktopOAuthLoaded = false;
String _googleDesktopClientId = '';
String _googleDesktopClientSecret = '';

void _loadDesktopOAuthIfNeeded() {
  if (_desktopOAuthLoaded) return;
  _desktopOAuthLoaded = true;

  // 1) dart-define has highest precedence.
  _googleDesktopClientId = _googleDesktopClientIdDefine;
  _googleDesktopClientSecret = _googleDesktopClientSecretDefine;
  if (_googleDesktopClientId.isNotEmpty && _googleDesktopClientSecret.isNotEmpty) {
    return;
  }

  // 2) Environment variables as fallback.
  _googleDesktopClientId = Platform.environment['GOOGLE_OAUTH_CLIENT_ID'] ?? _googleDesktopClientId;
  _googleDesktopClientSecret =
      Platform.environment['GOOGLE_OAUTH_CLIENT_SECRET'] ?? _googleDesktopClientSecret;
  if (_googleDesktopClientId.isNotEmpty && _googleDesktopClientSecret.isNotEmpty) {
    return;
  }

  // 3) Local config file used by this workspace launcher.
  final oauthBat = _findFileUpwards('oauth.desktop.local.bat');
  if (oauthBat != null) {
    final parsed = _parseDesktopOAuthBat(oauthBat);
    _googleDesktopClientId = parsed.$1.isNotEmpty ? parsed.$1 : _googleDesktopClientId;
    _googleDesktopClientSecret = parsed.$2.isNotEmpty ? parsed.$2 : _googleDesktopClientSecret;
    if (_googleDesktopClientId.isNotEmpty && _googleDesktopClientSecret.isNotEmpty) {
      return;
    }
  }

  // 4) Fallback to Google client secret JSON when present.
  final clientSecretJson = _findClientSecretJson();
  if (clientSecretJson != null) {
    final parsed = _parseGoogleClientSecretJson(clientSecretJson);
    _googleDesktopClientId = parsed.$1.isNotEmpty ? parsed.$1 : _googleDesktopClientId;
    _googleDesktopClientSecret = parsed.$2.isNotEmpty ? parsed.$2 : _googleDesktopClientSecret;
  }
}

String? _findFileUpwards(String fileName) {
  try {
    var dir = Directory.current;
    for (var i = 0; i < 8; i++) {
      final candidate = File(p.join(dir.path, fileName));
      if (candidate.existsSync()) return candidate.path;
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
  } catch (_) {
    // Ignore lookup errors and continue with next source.
  }
  return null;
}

(String, String) _parseDesktopOAuthBat(String filePath) {
  try {
    final content = File(filePath).readAsStringSync();
    final idMatch = RegExp(r'GOOGLE_OAUTH_CLIENT_ID=([^"\r\n]+)').firstMatch(content);
    final secretMatch = RegExp(r'GOOGLE_OAUTH_CLIENT_SECRET=([^"\r\n]+)').firstMatch(content);
    return (
      idMatch?.group(1)?.trim() ?? '',
      secretMatch?.group(1)?.trim() ?? '',
    );
  } catch (_) {
    return ('', '');
  }
}

String? _findClientSecretJson() {
  try {
    var dir = Directory.current;
    for (var i = 0; i < 8; i++) {
      final entries = dir.listSync();
      for (final entry in entries) {
        if (entry is File) {
          final name = p.basename(entry.path);
          if (name.startsWith('client_secret_') && name.endsWith('.json')) {
            return entry.path;
          }
        }
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
  } catch (_) {
    // Ignore lookup errors and continue.
  }
  return null;
}

(String, String) _parseGoogleClientSecretJson(String filePath) {
  try {
    final raw = File(filePath).readAsStringSync();
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final installed = (data['installed'] as Map?)?.cast<String, dynamic>();
    final id = (installed?['client_id'] as String?)?.trim() ?? '';
    final secret = (installed?['client_secret'] as String?)?.trim() ?? '';
    return (id, secret);
  } catch (_) {
    return ('', '');
  }
}

class GoogleDesktopProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String authSource;

  const GoogleDesktopProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.authSource,
  });
}

class FirebaseService {
  FirebaseAuth? _auth;
  FirebaseFirestore? _db;
  gsiap.GoogleSignIn? _googleSignIn;
  final Dio _dio = Dio();

  FirebaseAuth get _authInstance {
    if (!isCloudAuthSupported) {
      throw FirebaseAuthException(
        code: 'firebase-auth-unsupported',
        message: 'Firebase Auth nao esta disponível (Windows Debug).',
      );
    }
    // No Windows Debug, isCloudAuthSupported é falso, então nunca chegamos aqui.
    return _auth ??= FirebaseAuth.instance;
  }

  FirebaseFirestore get _dbInstance {
    if (!isCloudFirestoreSupported) {
      throw StateError('Cloud Firestore nao esta disponível (Windows Debug).');
    }
    // No Windows Debug, isCloudFirestoreSupported é falso, então nunca chegamos aqui.
    return _db ??= FirebaseFirestore.instance;
  }

  gsiap.GoogleSignIn get _googleSignInInstance {
    if (_googleSignIn != null) return _googleSignIn!;

    _loadDesktopOAuthIfNeeded();

    if (isDesktopPlatform &&
        (_googleDesktopClientId.isEmpty || _googleDesktopClientSecret.isEmpty)) {
      throw FirebaseAuthException(
        code: 'google-oauth-config-missing',
        message: 'Defina GOOGLE_OAUTH_CLIENT_ID e GOOGLE_OAUTH_CLIENT_SECRET para login Google no desktop.',
      );
    }

    _googleSignIn = gsiap.GoogleSignIn(
      params: gsiap.GoogleSignInParams(
        clientId: isDesktopPlatform ? _googleDesktopClientId : null,
        clientSecret: isDesktopPlatform ? _googleDesktopClientSecret : null,
        scopes: const ['openid', 'email', 'profile'],
      ),
    );

    return _googleSignIn!;
  }

  // Stream de estado da autenticação
  Stream<User?> get authStateChanges {
    if (!isCloudAuthSupported) {
      return const Stream<User?>.empty();
    }
    try {
      return _authInstance.authStateChanges();
    } catch (e) {
      debugPrint('Erro ao obter authStateChanges: $e');
      return const Stream<User?>.empty();
    }
  }

  // Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        return await _authInstance.signInWithPopup(googleProvider);
      }

      final credentials = await _googleSignInInstance.signIn();
      if (credentials == null) return null;

      final idToken = credentials.idToken;
      final accessToken = credentials.accessToken;
      final hasIdToken = idToken != null && idToken.isNotEmpty;
      final hasAccessToken = accessToken.isNotEmpty;

      if (!hasIdToken && !hasAccessToken) {
        throw FirebaseAuthException(
          code: 'missing-google-token',
          message: 'Nao foi possivel obter credenciais OAuth do Google.',
        );
      }

      final authCredential = GoogleAuthProvider.credential(
        idToken: hasIdToken ? idToken : null,
        accessToken: hasAccessToken ? accessToken : null,
      );

      return await _authInstance.signInWithCredential(authCredential);
    } catch (e) {
      rethrow;
    }
  }


  Future<GoogleDesktopProfile?> signInWithGoogleDesktopProfile() async {
    final credentials = await _googleSignInInstance.signIn();
    if (credentials == null) return null;

    final idToken = credentials.idToken;
    final accessToken = credentials.accessToken;

    Map<String, dynamic> payload;
    String authSource;
    if (idToken != null && idToken.isNotEmpty) {
      payload = _decodeJwtPayload(idToken);
      authSource = 'idToken';
    } else if (accessToken.isNotEmpty) {
      payload = await _fetchGoogleUserInfo(accessToken);
      authSource = 'accessToken/userinfo';
    } else {
      throw FirebaseAuthException(
        code: 'missing-google-token',
        message: 'Nao foi possivel obter credenciais OAuth do Google no desktop.',
      );
    }

    final uid = (payload['sub'] as String?)?.trim() ?? (payload['id'] as String?)?.trim() ?? '';
    final email = (payload['email'] as String?)?.trim() ?? '';
    final nome = ((payload['name'] as String?)?.trim().isNotEmpty ?? false)
        ? (payload['name'] as String).trim()
        : (email.isNotEmpty ? email.split('@').first : 'Utilizador');
    final foto = (payload['picture'] as String?)?.trim();

    if (uid.isEmpty || email.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Resposta OAuth do Google incompleta para criar sessao.',
      );
    }

    return GoogleDesktopProfile(
      uid: uid,
      email: email,
      displayName: nome,
      photoUrl: (foto == null || foto.isEmpty) ? null : foto,
      authSource: authSource,
    );
  }

  Future<Map<String, dynamic>> _fetchGoogleUserInfo(String accessToken) async {
    try {
      final response = await _dio.get(
        'https://www.googleapis.com/oauth2/v3/userinfo',
        options: Options(
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }

      throw const FormatException('Resposta invalida do userinfo Google.');
    } on DioException catch (e) {
      throw FirebaseAuthException(
        code: 'google-userinfo-failed',
        message: e.message ?? 'Nao foi possivel obter perfil do Google.',
      );
    }
  }

  Map<String, dynamic> _decodeJwtPayload(String jwt) {
    final parts = jwt.split('.');
    if (parts.length < 2) {
      throw const FormatException('JWT invalido.');
    }

    final normalized = base64Url.normalize(parts[1]);
    final payloadBytes = base64Url.decode(normalized);
    final payloadString = utf8.decode(payloadBytes);
    final dynamic decoded = jsonDecode(payloadString);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Payload JWT invalido.');
    }

    return decoded;
  }

  Future<UserCredential> signInAnonymously() => _authInstance.signInAnonymously();

  Future<UserCredential> signInWithUsernameAndPassword(
    String usernameOrEmail,
    String password,
  ) async {
    final raw = usernameOrEmail.trim();
    final normalized = raw.toLowerCase();
    if (raw.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-credentials',
        message: 'Utilizador e palavra-passe sao obrigatorios.',
      );
    }

    String? email;
    Map<String, dynamic>? userDoc;
    if (raw.contains('@')) {
      email = normalized;
      userDoc = await _findUserByIdentifier(raw);
    } else {
      if (!isCloudFirestoreSupported) {
        throw FirebaseAuthException(
          code: 'username-login-unsupported',
          message: 'Login por nome de utilizador nao esta disponivel no Windows.',
        );
      }
      userDoc = await _findUserByIdentifier(raw);
      final candidate = userDoc?['email'] as String?;
      if (candidate != null && candidate.contains('@')) {
        email = candidate.toLowerCase();
      }
    }

    final isActive = (userDoc?['ativo'] as bool?) ?? true;
    if (!isActive) {
      throw FirebaseAuthException(
        code: 'user-disabled',
        message: 'Este utilizador esta desativado.',
      );
    }

    if (email == null) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Nao foi possivel resolver o email do utilizador.',
      );
    }

    return _authInstance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<Map<String, dynamic>?> _findUserByIdentifier(String identifier) async {
    if (!isCloudFirestoreSupported) return null;

    final value = identifier.trim();
    if (value.isEmpty) return null;
    final normalized = value.toLowerCase();
    final users = _dbInstance.collection('utilizadores');

    final byEmail = await users.where('email', isEqualTo: normalized).limit(1).get();
    if (byEmail.docs.isNotEmpty) {
      return byEmail.docs.first.data();
    }

    final byName = await users.where('nome', isEqualTo: value).limit(1).get();
    if (byName.docs.isNotEmpty) {
      return byName.docs.first.data();
    }

    // Fallback para registos legados sem campo normalizado.
    final sample = await users.limit(200).get();
    for (final doc in sample.docs) {
      final data = doc.data();
      final email = ((data['email'] as String?) ?? '').trim().toLowerCase();
      final nome = ((data['nome'] as String?) ?? '').trim().toLowerCase();
      if (email == normalized || nome == normalized) {
        return data;
      }
    }

    return null;
  }

  // Logout
  Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
    if (_googleSignIn != null) {
      await _googleSignIn!.signOut();
    }
  }

  FirebaseFirestore get db {
    if (!isCloudFirestoreSupported) {
      // Retornamos um erro mais descritivo ou poderíamos retornar null se o tipo permitisse
      throw StateError('Firebase nao inicializado: Firestore desativado nesta plataforma.');
    }
    return _dbInstance;
  }

  Stream<int> streamTotalStudents() {
    if (!isCloudFirestoreSupported) return Stream.value(0);
    return _dbInstance.collection('alunos')
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> streamTotalClasses() {
    if (!isCloudFirestoreSupported) return Stream.value(0);
    return _dbInstance.collection('turmas')
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<Map<String, dynamic>> getOperationalStats() async {
    if (!isCloudFirestoreSupported) {
      return {
        'totalStudents': 0,
        'activeEnrollments': 0,
        'inactiveStudents': 0,
        'totalClasses': 0,
        'totalCapacity': 0,
        'avgStudentsPerClass': 0.0,
        'availableSpots': 0,
      };
    }
    try {
      final studentsSnap = await _dbInstance.collection('alunos')
          .where('isDeleted', isEqualTo: false)
          .get();
      final matriculasSnap = await _dbInstance.collection('matriculas')
          .where('isDeleted', isEqualTo: false)
          .where('estado', isEqualTo: 'ativa')
          .get();
      final turmasSnap = await _dbInstance.collection('turmas')
          .where('isDeleted', isEqualTo: false)
          .where('ativa', isEqualTo: true)
          .get();

      int totalStudents = studentsSnap.docs.length;
      int activeEnrollments = matriculasSnap.docs.length;
      int inactiveStudents = totalStudents - activeEnrollments;

      int totalClasses = turmasSnap.docs.length;
      int totalCapacity = 0;
      for (var doc in turmasSnap.docs) {
        totalCapacity += (doc.data()['limiteAlunos'] ?? 0) as int;
      }

      double avgStudents = totalClasses > 0 ? activeEnrollments / totalClasses : 0.0;
      int availableSpots = totalCapacity - activeEnrollments;

      return {
        'totalStudents': totalStudents,
        'activeEnrollments': activeEnrollments,
        'inactiveStudents': inactiveStudents,
        'totalClasses': totalClasses,
        'totalCapacity': totalCapacity,
        'avgStudentsPerClass': avgStudents,
        'availableSpots': availableSpots,
      };
    } catch (e) {
      debugPrint('Erro Operational Stats: $e');
      return {
        'totalStudents': 0,
        'activeEnrollments': 0,
        'inactiveStudents': 0,
        'totalClasses': 0,
        'totalCapacity': 0,
        'avgStudentsPerClass': 0.0,
        'availableSpots': 0,
      };
    }
  }

  Future<Map<String, dynamic>> getFinanceStats() async {
    if (!isCloudFirestoreSupported) {
      return {
        'totalDebt': 0.0,
        'monthlyRevenue': 0.0,
        'monthlyRevenuePaid': 0.0,
        'monthlyRevenuePending': 0.0,
        'monthlyCosts': 0.0,
        'monthlyCostsPaid': 0.0,
        'monthlyCostsPending': 0.0,
        'netBalance': 0.0
      };
    }
    try {
      final agora = DateTime.now();

      // 1. ESTIMATIVA DE RECEITA: Baseado em Matrículas Activas
      final matriculasSnap = await _dbInstance
          .collection('matriculas')
          .where('isDeleted', isEqualTo: false)
          .where('estado', isEqualTo: 'ativa')
          .get();

      double totalExpectedRevenue = 0;
      for (var doc in matriculasSnap.docs) {
        totalExpectedRevenue += (doc.data()['valorMensalidade'] ?? 0).toDouble();
      }

      // 2. RECEITA REALIZADA: Mensalidades pagas no mês actual
      final mensalidadesSnap = await _dbInstance
          .collection('mensalidades')
          .where('isDeleted', isEqualTo: false)
          .where('mesReferencia', isEqualTo: agora.month)
          .where('anoReferencia', isEqualTo: agora.year)
          .get();

      double monthlyRevenuePaid = 0;
      for (var doc in mensalidadesSnap.docs) {
        final data = doc.data();
        final estado = (data['estado'] as String?)?.toLowerCase() ?? 'pendente';
        if (estado == 'pago') {
          monthlyRevenuePaid += (data['valor'] ?? 0).toDouble();
        }
      }

      // 3. CUSTOS: Registados para o mês actual
      final custosSnap = await _dbInstance
          .collection('custos')
          .where('isDeleted', isEqualTo: false)
          .where('mesReferencia', isEqualTo: agora.month)
          .where('anoReferencia', isEqualTo: agora.year)
          .get();

      double monthlyCostsPaid = 0;
      double monthlyCostsTotal = 0;

      for (var doc in custosSnap.docs) {
        final data = doc.data();
        final valor = (data['valor'] ?? 0).toDouble();
        final estado = (data['estado'] as String?)?.toUpperCase() ?? 'PENDENTE';
        
        monthlyCostsTotal += valor;
        if (estado == 'PAGO') {
          monthlyCostsPaid += valor;
        }
      }

      // Cálculo de Pendentes (Estimativas)
      double monthlyRevenuePending = totalExpectedRevenue - monthlyRevenuePaid;
      if (monthlyRevenuePending < 0) monthlyRevenuePending = 0;

      // Para custos, a estimativa pendente é o que foi registado mas não pago
      double monthlyCostsPending = monthlyCostsTotal - monthlyCostsPaid;

      return {
        'totalDebt': 0.0, 
        'monthlyRevenue': totalExpectedRevenue, // Valor Total Esperado
        'monthlyRevenuePaid': monthlyRevenuePaid,
        'monthlyRevenuePending': monthlyRevenuePending,
        'monthlyCosts': monthlyCostsTotal, // Total de custos registados
        'monthlyCostsPaid': monthlyCostsPaid,
        'monthlyCostsPending': monthlyCostsPending,
        'netBalance': monthlyRevenuePaid - monthlyCostsPaid, // Saldo Real em Caixa
      };
    } catch (e) {
      debugPrint('Erro Finance Stats Cloud: $e');
      return {
        'totalDebt': 0.0,
        'monthlyRevenue': 0.0,
        'monthlyRevenuePaid': 0.0,
        'monthlyRevenuePending': 0.0,
        'monthlyCosts': 0.0,
        'monthlyCostsPaid': 0.0,
        'monthlyCostsPending': 0.0,
        'netBalance': 0.0
      };
    }
  }
}

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());
