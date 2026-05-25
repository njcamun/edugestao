import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, debugPrint, defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:edugestao/firebase_options.dart';

/// Token debug (só desenvolvimento): `--dart-define=FIREBASE_APP_CHECK_DEBUG_TOKEN=uuid`
const _appCheckDebugToken = String.fromEnvironment('FIREBASE_APP_CHECK_DEBUG_TOKEN');

/// Teste local de APK release antes da Play Store: `--dart-define=APP_CHECK_USE_DEBUG=true`
const _forceDebugAppCheckInRelease =
    bool.fromEnvironment('APP_CHECK_USE_DEBUG', defaultValue: false);

bool get _useDebugAppCheckProviders => kDebugMode || _forceDebugAppCheckInRelease;

/// Inicializa Firebase Core e App Check (Windows sem App Check).
Future<void> bootstrapFirebase() async {
  debugPrint('MAIN: Tentando inicializar Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('MAIN: Firebase inicializado com sucesso.');

  await _activateAppCheck();
}

Future<void> _activateAppCheck() async {
  if (kIsWeb) {
    debugPrint(
      'MAIN: App Check Web não configurado (falta ReCaptchaV3). Ver docs/FIREBASE_APP_CHECK.md',
    );
    return;
  }

  if (defaultTargetPlatform == TargetPlatform.windows) {
    debugPrint('MAIN: App Check não suportado no Windows; Firebase activo sem App Check.');
    return;
  }

  try {
    final debugToken =
        _appCheckDebugToken.trim().isEmpty ? null : _appCheckDebugToken.trim();

    if (_useDebugAppCheckProviders) {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: AndroidDebugProvider(debugToken: debugToken),
        providerApple: AppleDebugProvider(debugToken: debugToken),
      );
      debugPrint('MAIN: App Check activado (fornecedor DEBUG).');
      _printAppCheckDebugSetupHint(debugTokenProvided: debugToken != null);
      return;
    }

    await FirebaseAppCheck.instance.activate(
      providerAndroid: const AndroidPlayIntegrityProvider(),
      providerApple: const AppleDeviceCheckProvider(),
    );
    debugPrint('MAIN: App Check activado (RELEASE: Play Integrity / DeviceCheck).');
    debugPrint(
      'MAIN: Release requer SHA-1 do keystore de upload no Firebase + app na Play Console '
      '(teste interno). Ver docs/FIREBASE_RELEASE.md',
    );
  } catch (e, st) {
    debugPrint('MAIN: Falha ao activar App Check: $e\n$st');
  }
}

void _printAppCheckDebugSetupHint({required bool debugTokenProvided}) {
  if (debugTokenProvided) {
    debugPrint(
      'MAIN: App Check debug token via --dart-define. '
      'Registe o mesmo UUID no Firebase Console → App Check.',
    );
    return;
  }
  debugPrint(
    'MAIN: App Check DEBUG — registe o UUID do logcat (DebugAppCheckProvider):\n'
    'https://console.firebase.google.com/project/edugestao/appcheck\n'
    'Opcional: --dart-define=FIREBASE_APP_CHECK_DEBUG_TOKEN=<uuid>',
  );
}
