import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_tokens.dart';
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

    // Sync inicial e listeners são geridos em App._setupSync() (evita syncAll duplicado).
    if (isInitialCloudPullSupported && isCloudFirestoreSupported) {
      try {
        await ref.read(syncServiceProvider).seedAnoLectivo(
          id: 'ano-2025-2026',
          ano: '2025/2026',
          dataInicio: DateTime(2025, 9, 1),
          dataFim: DateTime(2026, 7, 31),
          isActive: true,
        );
      } catch (e) {
        debugPrint('Erro ao preparar ano lectivo: $e');
      }
    }

    // Geração de custos fixos locais (sempre executa pois deve funcionar offline)
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
      backgroundColor: AppTokens.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(logoPath),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(height: 24),
            Text(
              settings?.nomeInstituicao ?? 'A carregar EDUCLASS...',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTokens.primaryDark,
                  ),
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
