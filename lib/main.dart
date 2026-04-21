import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'src/app.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    // Garante que o Flutter esteja inicializado na mesma zone do runApp.
    WidgetsFlutterBinding.ensureInitialized();

    // Bloqueia a orientação apenas em dispositivos móveis (portrait)
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (isMobile) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    // Inicializa a formatação de datas
    try {
      await initializeDateFormatting('pt_AO', null);
    } catch (_) {
      await initializeDateFormatting('pt_PT', null);
    }

    // Tentar inicializar o Firebase. No Windows (seja Debug ou Release), o plugin às vezes causa crash nativo.
    // Envolvemos num try-catch muito rigoroso.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      debugPrint('AVISO: Inicialização do Firebase ignorada no Windows para prevenir crashes nativos.');
    } else {
      try {
        debugPrint('MAIN: Tentando inicializar Firebase...');
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint('MAIN: Firebase inicializado com sucesso.');
      } catch (e) {
        debugPrint('MAIN: Falha ao inicializar Firebase: $e');
      }
    }

    // Captura erros não tratados em Release e impede crash silencioso
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };

    runApp(const ProviderScope(child: App()));
  }, (error, stack) => debugPrint('ERRO NAO TRATADO: $error\n$stack'));
}
