import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/splash_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/students/gestao_alunos_page.dart';
import '../../features/students/student_details_page.dart';
import '../../features/finance/gestao_financeira_page.dart';
import '../../features/reports/reports_page.dart';
import '../../features/settings/settings_page.dart';
import '../../presentation/layouts/responsive_layout.dart';
import '../../state/session.dart';

// Chave Global para notificações de sistema
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final routerProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => ResponsiveLayout(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/alunos',
            builder: (context, state) => const GestaoAlunosPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return StudentDetailsPage(alunoId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/financeiro',
            builder: (context, state) => const GestaoFinanceiraPage(),
          ),
          GoRoute(
            path: '/relatorios',
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(
            path: '/configuracoes',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});
