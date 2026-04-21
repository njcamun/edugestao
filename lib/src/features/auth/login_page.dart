import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_tokens.dart';
import '../../state/session.dart';

String _mapLoginError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'network-request-failed':
        return 'SEM ACESSO A INTERNET. VERIFIQUE A SUA LIGACAO.';
      case 'popup-closed-by-user':
      case 'user-cancelled':
      case 'user-cancelled-login':
        return 'LOGIN CANCELADO PELO UTILIZADOR.';
      case 'account-exists-with-different-credential':
        return 'JA EXISTE UMA CONTA COM OUTRO METODO DE LOGIN.';
      case 'invalid-credential':
        return 'NAO FOI POSSIVEL VALIDAR O LOGIN GOOGLE. TENTE NOVAMENTE.';
      case 'wrong-password':
      case 'user-not-found':
        return 'UTILIZADOR OU PALAVRA-PASSE INVALIDOS.';
      case 'invalid-email':
        return 'UTILIZADOR INVALIDO. USE EMAIL OU NOME REGISTADO.';
      case 'user-disabled':
        return 'UTILIZADOR DESATIVADO. CONTACTE O ADMINISTRADOR.';
      case 'missing-credentials':
        return 'PREENCHA UTILIZADOR E PALAVRA-PASSE.';
      case 'firebase-auth-unsupported':
        return 'LOGIN GOOGLE INDISPONIVEL NESTA PLATAFORMA NO MODO ATUAL.';
      case 'google-oauth-config-missing':
        return 'CONFIGURE GOOGLE_OAUTH_CLIENT_ID E GOOGLE_OAUTH_CLIENT_SECRET NO DESKTOP.';
      case 'missing-id-token':
        return 'NAO FOI POSSIVEL VALIDAR O LOGIN GOOGLE. TENTE NOVAMENTE.';
      case 'missing-google-token':
        return 'NAO FOI POSSIVEL OBTER TOKEN DE LOGIN GOOGLE. TENTE NOVAMENTE.';
      case 'google-userinfo-failed':
        return 'NAO FOI POSSIVEL OBTER O PERFIL GOOGLE. VERIFIQUE INTERNET E TENTE NOVAMENTE.';
      default:
        return 'FALHA NO LOGIN: ${(error.message ?? error.code)}'.toUpperCase();
    }
  }

  final raw = error.toString().toLowerCase();
  if (raw.contains('network') || raw.contains('internet') || raw.contains('socket')) {
    return 'SEM ACESSO A INTERNET. VERIFIQUE A SUA LIGACAO.';
  }
  return 'NAO FOI POSSIVEL INICIAR SESSAO. TENTE NOVAMENTE.';
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  Future<void> _loginAnonymously() async {
    try {
      await ref.read(sessionProvider.notifier).loginAnonymously();
    } catch (e) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            _mapLoginError(e),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      await ref.read(sessionProvider.notifier).loginWithGoogle();
    } catch (e) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            _mapLoginError(e),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 64),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTokens.radiusLG),
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(8, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'EDUGESTAO',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SISTEMA DE GESTAO ESCOLAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 64),
                if (session.isLoading)
                  const CircularProgressIndicator(color: Colors.black, strokeWidth: 4)
                else ...[
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _loginWithGoogle,
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login_rounded, color: Colors.black),
                            SizedBox(width: 16),
                            Text(
                              'ENTRAR COM GOOGLE',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _loginAnonymously,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                          border: Border.all(color: Colors.black45, width: 1.5),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline_rounded, color: Colors.black54),
                            SizedBox(width: 12),
                            Text(
                              'ENTRAR COMO CONVIDADO',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (session.googleDebugLog != null && session.googleDebugLog!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SelectableText(
                              session.googleDebugLog!,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Copiar mensagem',
                            icon: const Icon(Icons.copy_rounded, size: 16, color: Colors.black87),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: session.googleDebugLog!));
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mensagem copiada para a area de transferencia.')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
