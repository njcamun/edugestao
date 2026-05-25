import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_logo.dart';
import '../../shared/widgets/edu_primary_button.dart';
import '../../state/session.dart';

String _mapLoginError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'network-request-failed':
        return 'Sem acesso à internet. Verifique a sua ligação.';
      case 'popup-closed-by-user':
      case 'user-cancelled':
      case 'user-cancelled-login':
        return 'Login cancelado.';
      case 'account-exists-with-different-credential':
        return 'Já existe uma conta com outro método de login.';
      case 'invalid-credential':
        return 'Não foi possível validar o login Google. Tente novamente.';
      case 'wrong-password':
      case 'user-not-found':
        return 'Utilizador ou palavra-passe inválidos.';
      case 'invalid-email':
        return 'Utilizador inválido.';
      case 'user-disabled':
        return 'Utilizador desativado. Contacte o administrador.';
      case 'missing-credentials':
        return 'Preencha utilizador e palavra-passe.';
      case 'firebase-auth-unsupported':
        return 'Login Google indisponível nesta plataforma.';
      case 'google-oauth-config-missing':
        return 'Configure as credenciais Google OAuth no desktop.';
      case 'desktop-google-flow-disabled':
        return 'Esta versão deve usar o fluxo Google OAuth desktop no Windows.';
      default:
        return 'Falha no login: ${error.message ?? error.code}';
    }
  }

  final raw = error.toString().toLowerCase();
  if (raw.contains('network') || raw.contains('internet') || raw.contains('socket')) {
    return 'Sem acesso à internet. Verifique a sua ligação.';
  }
  return 'Não foi possível iniciar sessão. Tente novamente.';
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
      _showError(_mapLoginError(e));
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      await ref.read(sessionProvider.notifier).loginWithGoogle();
    } catch (e) {
      _showError(_mapLoginError(e));
    }
  }

  void _showError(String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 720;

    return Scaffold(
      backgroundColor: AppTokens.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 420 : double.infinity),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              decoration: BoxDecoration(
                color: AppTokens.surface,
                borderRadius: BorderRadius.circular(AppTokens.radiusXL),
                boxShadow: AppTokens.elevatedShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EduLogo(height: 80, showTagline: true),
                  const SizedBox(height: 32),
                  Text(
                    'Bem-vindo(a)!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTokens.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inicie sessão para aceder à gestão escolar',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 36),
                  if (session.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    )
                  else ...[
                    EduPrimaryButton(
                      label: 'Entrar com Google',
                      icon: Icons.login_rounded,
                      onPressed: _loginWithGoogle,
                    ),
                    const SizedBox(height: 12),
                    EduPrimaryButton(
                      label: 'Entrar como convidado',
                      icon: Icons.person_outline_rounded,
                      outlined: true,
                      onPressed: _loginAnonymously,
                    ),
                    if (session.googleDebugLog != null && session.googleDebugLog!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTokens.background,
                          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                          border: Border.all(color: AppTokens.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SelectableText(
                                session.googleDebugLog!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copiar',
                              icon: const Icon(Icons.copy_rounded, size: 18),
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: session.googleDebugLog!));
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Mensagem copiada.')),
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
      ),
    );
  }
}
