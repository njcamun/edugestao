import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/sync/sync_service.dart';
import 'state/session.dart';
import 'state/theme_mode_controller.dart';

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

  void _setupSync() {
    if (!isInitialCloudPullSupported && !isAutomaticCloudSyncSupported) {
      return;
    }

    final syncService = ref.read(syncServiceProvider);
    syncService.syncAll();

    if (isAutomaticCloudSyncSupported) {
      syncService.startRealtimeListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isAutomaticCloudSyncSupported) {
      ref.read(syncServiceProvider).syncLocalToCloud();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

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
      title: 'EDUCLASS – Gestão Escolar',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
