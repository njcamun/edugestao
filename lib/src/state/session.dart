import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import '../shared/firebase_service.dart';
import '../domain/entities/utilizador.dart';

bool get isCloudProfileLookupSupported {
  if (kIsWeb) return true;
  return defaultTargetPlatform != TargetPlatform.windows;
}

bool get isAuthStateStreamSupported {
  if (kIsWeb) return true;
  return defaultTargetPlatform != TargetPlatform.windows;
}

@immutable
class SessionState {
  final User? firebaseUser;
  final Utilizador? perfil;
  final bool isLoading;
  final String? googleDebugLog;

  const SessionState({
    this.firebaseUser,
    this.perfil,
    this.isLoading = false,
    this.googleDebugLog,
  });

  bool get isAuthenticated => firebaseUser != null || perfil != null;
  bool get hasPerfil => perfil != null;
  bool get isAnonymous => firebaseUser?.isAnonymous ?? false;
}

class SessionNotifier extends StateNotifier<SessionState> {
  final FirebaseService _firebaseService;
  static const String _bootstrapAdminEmail = String.fromEnvironment(
    'BOOTSTRAP_ADMIN_EMAIL',
    defaultValue: '',
  );

  SessionNotifier(this._firebaseService) : super(const SessionState()) {
    _init();
  }

  void _init() {
    if (!isAuthStateStreamSupported) {
      state = const SessionState(isLoading: false);
      return;
    }

    _firebaseService.authStateChanges.listen((user) async {
      if (user == null) {
        state = SessionState(isLoading: false, googleDebugLog: state.googleDebugLog);
      } else {
        if (state.perfil == null || state.firebaseUser?.uid != user.uid) {
          state = SessionState(
            firebaseUser: user,
            isLoading: true,
            googleDebugLog: state.googleDebugLog,
          );
          final perfil = await _loadOrCreatePerfil(user);
          state = SessionState(
            firebaseUser: user,
            perfil: perfil,
            isLoading: false,
            googleDebugLog: state.googleDebugLog,
          );
        }
      }
    });
  }

  Future<Utilizador?> _loadOrCreatePerfil(User user) async {
    if (user.isAnonymous) {
      return Utilizador(
        id: user.uid,
        nome: 'Convidado',
        email: '',
        perfil: Perfil.user,
      );
    }

    if (!isCloudProfileLookupSupported || !isCloudFirestoreSupported) {
      final perfilInicial = _resolveInitialPerfil(user.email);
      return Utilizador(
        id: user.uid,
        nome: user.displayName ?? 'Utilizador',
        email: user.email ?? '',
        fotoUrl: user.photoURL,
        perfil: perfilInicial,
      );
    }

    try {
      final doc = await _firebaseService.db.collection('utilizadores').doc(user.uid).get();
      if (doc.exists) {
        return Utilizador.fromFirestore(doc.data()!, doc.id);
      } else {
        final perfilInicial = _resolveInitialPerfil(user.email);

        final novoUtilizador = Utilizador(
          id: user.uid,
          nome: user.displayName ?? 'Utilizador',
          email: user.email ?? '',
          fotoUrl: user.photoURL,
          perfil: perfilInicial,
        );

        await _firebaseService.db.collection('utilizadores').doc(user.uid).set(novoUtilizador.toFirestore());
        return novoUtilizador;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> loginWithGoogle() async {
    if (state.isLoading) return;

    state = SessionState(
      firebaseUser: state.firebaseUser,
      perfil: state.perfil,
      isLoading: true,
      googleDebugLog: 'Google: iniciando autenticacao...',
    );
    try {
      if (!isAuthStateStreamSupported) {
        state = SessionState(
          firebaseUser: state.firebaseUser,
          perfil: state.perfil,
          isLoading: true,
          googleDebugLog: 'Google: fluxo desktop (OAuth direto) iniciado.',
        );

        final desktopProfile = await _firebaseService.signInWithGoogleDesktopProfile();
        if (desktopProfile == null) {
          state = SessionState(
            firebaseUser: state.firebaseUser,
            perfil: state.perfil,
            isLoading: false,
            googleDebugLog: 'Google: login cancelado pelo utilizador.',
          );
          return;
        }

        final perfilInicial = _resolveInitialPerfil(desktopProfile.email);

        final perfil = Utilizador(
          id: desktopProfile.uid,
          nome: desktopProfile.displayName,
          email: desktopProfile.email,
          fotoUrl: desktopProfile.photoUrl,
          perfil: perfilInicial,
        );

        state = SessionState(
          firebaseUser: null,
          perfil: perfil,
          isLoading: false,
          googleDebugLog: 'Google: login concluido via ${desktopProfile.authSource}.',
        );
        return;
      }

      state = SessionState(
        firebaseUser: state.firebaseUser,
        perfil: state.perfil,
        isLoading: true,
        googleDebugLog: 'Google: aguardando credenciais Firebase Auth...',
      );
      final credential = await _firebaseService.signInWithGoogle();
      if (credential == null) {
        state = SessionState(
          firebaseUser: state.firebaseUser,
          perfil: state.perfil,
          isLoading: false,
          googleDebugLog: 'Google: login cancelado pelo utilizador.',
        );
        return;
      }

      state = SessionState(
        firebaseUser: state.firebaseUser,
        perfil: state.perfil,
        isLoading: false,
        googleDebugLog: 'Google: credencial Firebase recebida com sucesso.',
      );
    } catch (e) {
      state = SessionState(
        firebaseUser: state.firebaseUser,
        perfil: state.perfil,
        isLoading: false,
        googleDebugLog: 'Google: falha -> $e',
      );
      rethrow;
    }
  }

  Future<void> loginAnonymously() async {
    if (state.isLoading) return;
    state = SessionState(
      firebaseUser: state.firebaseUser,
      perfil: state.perfil,
      isLoading: true,
      googleDebugLog: state.googleDebugLog,
    );
    try {
      final credential = await _firebaseService.signInAnonymously();

      if (!isAuthStateStreamSupported) {
        final user = credential.user;
        if (user == null) {
          state = SessionState(
            firebaseUser: state.firebaseUser,
            perfil: state.perfil,
            isLoading: false,
            googleDebugLog: state.googleDebugLog,
          );
          return;
        }

        final perfil = await _loadOrCreatePerfil(user);
        state = SessionState(
          firebaseUser: user,
          perfil: perfil,
          isLoading: false,
          googleDebugLog: state.googleDebugLog,
        );
      }
    } catch (e) {
      state = SessionState(
        firebaseUser: state.firebaseUser,
        perfil: state.perfil,
        isLoading: false,
        googleDebugLog: state.googleDebugLog,
      );
      rethrow;
    }
  }

  Future<void> loginWithUsernameAndPassword(String usernameOrEmail, String password) async {
    if (state.isLoading) return;

    state = SessionState(
      firebaseUser: state.firebaseUser,
      perfil: state.perfil,
      isLoading: true,
      googleDebugLog: state.googleDebugLog,
    );
    try {
      await _firebaseService.signInWithUsernameAndPassword(usernameOrEmail, password);
    } catch (e) {
      state = SessionState(
        firebaseUser: state.firebaseUser,
        perfil: state.perfil,
        isLoading: false,
        googleDebugLog: state.googleDebugLog,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = SessionState(isLoading: true, googleDebugLog: state.googleDebugLog);
    await _firebaseService.signOut();
    state = const SessionState(isLoading: false);
  }

  Perfil _resolveInitialPerfil(String? email) {
    if (_bootstrapAdminEmail.isEmpty || email == null) {
      return Perfil.user;
    }
    return email.toLowerCase().trim() == _bootstrapAdminEmail.toLowerCase().trim()
        ? Perfil.admin
        : Perfil.user;
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  final firebase = ref.watch(firebaseServiceProvider);
  return SessionNotifier(firebase);
});
