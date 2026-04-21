import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_tokens.dart';
import 'data/sync/sync_service.dart';
import 'state/session.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Força a sincronização inicial caso o utilizador já esteja logado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialSetup();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _checkInitialSetup() {
    final session = ref.read(sessionProvider);
    if (session.isAuthenticated && isInitialCloudPullSupported) {
      _setupSync();
    }
  }

  /// Ativa a sincronização e os listeners
  void _setupSync() {
    if (!isInitialCloudPullSupported && !isAutomaticCloudSyncSupported) {
      return;
    }

    final syncService = ref.read(syncServiceProvider);
    
    // Dispara o PULL total inicial (Cloud -> local)
    syncService.syncAll();
    
    // Ativa a escuta em tempo real para atualizações multi-utilizador
    if (isAutomaticCloudSyncSupported) {
      syncService.startRealtimeListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isAutomaticCloudSyncSupported) {
      // Tenta sincronizar alterações locais ao voltar para a app
      ref.read(syncServiceProvider).syncLocalToCloud();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    // Listener reativo para detetar mudanças de estado de login durante o uso
    ref.listen(sessionProvider, (previous, next) {
      if (
        isInitialCloudPullSupported &&
        next.isAuthenticated &&
        previous?.isAuthenticated != true
      ) {
        _setupSync();
      }
    });

    return MaterialApp.router(
      title: 'EduGestão',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppTokens.background,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          surface: Colors.white,
        ),
      ),
      routerConfig: router,
    );
  }
}
