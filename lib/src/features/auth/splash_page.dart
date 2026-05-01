import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/session.dart';
import '../settings/settings_controller.dart';
import '../../data/sync/sync_service.dart';
import '../../shared/firebase_service.dart';
import '../finance/costs_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initApp());
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final session = ref.read(sessionProvider);
    
    if (!session.isAuthenticated) {
      if (mounted) context.go('/login');
      return;
    }

    if (isInitialCloudPullSupported) {
      try {
        final syncService = ref.read(syncServiceProvider);
        
        // No Windows Debug, isInitialCloudPullSupported é falso, mas por garantia:
        if (isCloudFirestoreSupported) {
          await syncService.syncAll();

          // Garante que o ano lectivo 2025/2026 existe no Firestore
          await syncService.seedAnoLectivo(
            id: 'ano-2025-2026',
            ano: '2025/2026',
            dataInicio: DateTime(2025, 9, 1),
            dataFim: DateTime(2026, 7, 31),
            isActive: true,
          );

          if (mounted) syncService.startRealtimeListeners();
        }
      } catch (e) {
        debugPrint('Erro na sincronização inicial: $e');
      }
    }

    // Geracao de custos fixos locais (sempre executa pois deve funcionar offline)
    try {
      await ref.read(costsRepositoryProvider).checkAndGenerateMonthlyCosts();
    } catch (e) {
      debugPrint('Erro ao gerar custos locais: $e');
    }

    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final logoPath = settings?.logotipoUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(logoPath),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
            ),
            const SizedBox(height: 24),
            Text(
              settings?.nomeInstituicao.toUpperCase() ?? 'A CARREGAR SISTEMA...',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 2, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(String? path) {
    if (path == null || path.isEmpty) {
      return Image.asset('assets/icons/logo.png',
          height: 100, width: 100,
          errorBuilder: (c, e, s) =>
              const Icon(Icons.school_rounded, size: 60));
    }

    if (kIsWeb) {
      // No web, path pode ser um URL (blob ou remoto)
      return Image.network(
        path,
        height: 100,
        width: 100,
        fit: BoxFit.contain,
        errorBuilder: (c, e, s) => Image.asset('assets/icons/logo.png',
            height: 100, width: 100,
            errorBuilder: (c, e, s) =>
                const Icon(Icons.school_rounded, size: 60)),
      );
    } else {
      try {
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(file, height: 100, width: 100, fit: BoxFit.contain);
        }
      } catch (e) {
        debugPrint('Erro ao carregar logo do ficheiro: $e');
      }
    }

    return Image.asset('assets/icons/logo.png',
        height: 100, width: 100,
        errorBuilder: (c, e, s) => const Icon(Icons.school_rounded, size: 60));
  }
}
