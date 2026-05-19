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
import '../../features/modules/modules_hub_page.dart';
import '../../features/modules/module_placeholder_page.dart';
import '../../features/notifications/notifications_page.dart';
import '../../features/schedules/schedules_page.dart';
import '../../features/grades/grades_page.dart';
import '../../features/staff/staff_page.dart';
import '../../features/salaries/salaries_page.dart';
import '../../features/inventory/inventory_page.dart';
import '../../core/navigation/app_modules.dart';
import '../../presentation/layouts/responsive_layout.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final routerProvider = Provider<GoRouter>((ref) {
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
            path: '/funcionarios',
            builder: (context, state) => const StaffPage(),
          ),
          GoRoute(
            path: '/salarios',
            builder: (context, state) => const SalariesPage(),
          ),
          GoRoute(
            path: '/inventario',
            builder: (context, state) => const InventoryPage(),
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
          GoRoute(
            path: '/notificacoes',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/horarios',
            builder: (context, state) => const SchedulesPage(),
          ),
          GoRoute(
            path: '/notas',
            builder: (context, state) => const GradesPage(),
          ),
          GoRoute(
            path: '/modulos',
            builder: (context, state) => const ModulesHubPage(),
          ),
          GoRoute(
            path: '/modulos/:moduleId',
            builder: (context, state) {
              final moduleId = state.pathParameters['moduleId']!;
              final module = AppModules.findById(moduleId);
              if (module == null) {
                return const ModulesHubPage();
              }
              return ModulePlaceholderPage(module: module);
            },
          ),
        ],
      ),
    ],
  );
});
