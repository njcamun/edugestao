import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'src/app.dart';
import 'src/core/firebase/firebase_bootstrap.dart';

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

    try {
      await bootstrapFirebase();
    } catch (e, st) {
      debugPrint('MAIN: Falha ao inicializar Firebase: $e\n$st');
    }

    // Captura erros não tratados em Release e impede crash silencioso
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
    };

    runApp(const ProviderScope(child: App()));
  }, (error, stack) => debugPrint('ERRO NAO TRATADO: $error\n$stack'));
}
