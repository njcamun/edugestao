import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/splash_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/students/students_page.dart';
import '../../features/students/student_details_page.dart';
import '../../features/classes/classes_page.dart';
import '../../features/enrollments/enrollments_page.dart';
import '../../features/finance/finance_summary_page.dart';
import '../../features/finance/finance_page.dart';
import '../../features/finance/costs_page.dart';
import '../../features/reports/report_students_page.dart';
import '../../features/reports/report_finance_page.dart';
import '../../features/reports/report_grades_page.dart';
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
import '../../state/session.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);
  ref.onDispose(refreshListenable.dispose);
  ref.listen(sessionProvider, (_, __) {
    refreshListenable.value++;
  });

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final path = state.matchedLocation;

      if (session.isLoading) {
        if (path == '/login') return null;
      }

      if (!session.isAuthenticated) {
        if (path == '/login' || path == '/splash') return null;
        return '/login';
      }

      if (path == '/login') return '/splash';

      if (path == '/financeiro') return '/financeiro/resumo';
      if (path == '/relatorios') return '/relatorios/alunos';

      return null;
    },
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
            builder: (context, state) => const StudentsPage(),
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
            path: '/turmas',
            builder: (context, state) => const ClassesPage(),
          ),
          GoRoute(
            path: '/matriculas',
            builder: (context, state) => const EnrollmentsPage(),
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
            path: '/financeiro/resumo',
            builder: (context, state) => const FinanceSummaryPage(),
          ),
          GoRoute(
            path: '/financeiro/propinas',
            builder: (context, state) => const FinancePage(),
          ),
          GoRoute(
            path: '/financeiro/custos',
            builder: (context, state) => const CostsPage(),
          ),
          GoRoute(
            path: '/relatorios/alunos',
            builder: (context, state) => const ReportStudentsPage(),
          ),
          GoRoute(
            path: '/relatorios/financeiro',
            builder: (context, state) => const ReportFinancePage(),
          ),
          GoRoute(
            path: '/relatorios/notas',
            builder: (context, state) => const ReportGradesPage(),
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
