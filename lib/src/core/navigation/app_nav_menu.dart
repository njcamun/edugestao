import 'package:flutter/material.dart';
import '../../domain/entities/utilizador.dart';

class AppNavItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final bool Function(Utilizador? user)? visible;

  const AppNavItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.visible,
  });

  bool isVisibleFor(Utilizador? user) => visible?.call(user) ?? true;
}

class AppNavSection {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<AppNavItem> items;

  const AppNavSection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
  });

  List<AppNavItem> visibleItems(Utilizador? user) =>
      items.where((i) => i.isVisibleFor(user)).toList();
}

/// Estrutura completa da barra lateral (secções + submenus).
class AppNavMenu {
  /// Largura máxima de referência; o layout ajusta conforme o ecrã.
  static const double sidebarWidth = 260;

  static bool isRouteActive(String location, String route) {
    if (route == '/') return location == '/';
    return location == route || location.startsWith('$route/');
  }

  static bool sectionHasActiveRoute(String location, AppNavSection section, Utilizador? user) {
    return section.visibleItems(user).any((i) => isRouteActive(location, i.route));
  }

  static List<AppNavSection> sections(Utilizador? user) {
    final all = <AppNavSection>[
      const AppNavSection(
        id: 'principal',
        title: 'Principal',
        subtitle: 'Visão geral',
        icon: Icons.home_outlined,
        items: [
          AppNavItem(
            id: 'dashboard',
            title: 'Painel',
            subtitle: 'Resumo da escola',
            icon: Icons.dashboard_outlined,
            route: '/',
          ),
        ],
      ),
      const AppNavSection(
        id: 'secretaria',
        title: 'Secretaria',
        subtitle: 'Alunos e turmas',
        icon: Icons.school_outlined,
        items: [
          AppNavItem(
            id: 'alunos',
            title: 'Alunos',
            subtitle: 'Cadastro e fichas',
            icon: Icons.people_outline_rounded,
            route: '/alunos',
          ),
          AppNavItem(
            id: 'turmas',
            title: 'Turmas',
            subtitle: 'Salas e turnos',
            icon: Icons.class_outlined,
            route: '/turmas',
          ),
          AppNavItem(
            id: 'matriculas',
            title: 'Matrículas',
            subtitle: 'Inscrições activas',
            icon: Icons.how_to_reg_outlined,
            route: '/matriculas',
          ),
        ],
      ),
      const AppNavSection(
        id: 'academico',
        title: 'Académico',
        subtitle: 'Aulas e avaliações',
        icon: Icons.menu_book_outlined,
        items: [
          AppNavItem(
            id: 'horarios',
            title: 'Horários',
            subtitle: 'Grade por turma',
            icon: Icons.schedule_outlined,
            route: '/horarios',
          ),
          AppNavItem(
            id: 'notas',
            title: 'Notas',
            subtitle: 'Lançamento e consulta',
            icon: Icons.grade_outlined,
            route: '/notas',
          ),
        ],
      ),
      const AppNavSection(
        id: 'equipa',
        title: 'Equipa',
        subtitle: 'Pessoal da escola',
        icon: Icons.groups_outlined,
        items: [
          AppNavItem(
            id: 'funcionarios',
            title: 'Funcionários',
            subtitle: 'Cadastro e cargos',
            icon: Icons.badge_outlined,
            route: '/funcionarios',
          ),
          AppNavItem(
            id: 'salarios',
            title: 'Salários',
            subtitle: 'Pagamentos mensais',
            icon: Icons.payments_outlined,
            route: '/salarios',
            visible: _canFinance,
          ),
        ],
      ),
      const AppNavSection(
        id: 'financas',
        title: 'Finanças',
        subtitle: 'Caixa e cobranças',
        icon: Icons.account_balance_wallet_outlined,
        items: [
          AppNavItem(
            id: 'resumo',
            title: 'Resumo',
            subtitle: 'Entradas e saldo',
            icon: Icons.insights_outlined,
            route: '/financeiro/resumo',
            visible: _canFinance,
          ),
          AppNavItem(
            id: 'propinas',
            title: 'Propinas',
            subtitle: 'Mensalidades e recibos',
            icon: Icons.receipt_long_outlined,
            route: '/financeiro/propinas',
            visible: _canFinance,
          ),
          AppNavItem(
            id: 'custos',
            title: 'Custos',
            subtitle: 'Despesas da escola',
            icon: Icons.trending_down_outlined,
            route: '/financeiro/custos',
            visible: _canFinance,
          ),
        ],
      ),
      const AppNavSection(
        id: 'operacoes',
        title: 'Operações',
        subtitle: 'Dia a dia',
        icon: Icons.domain_outlined,
        items: [
          AppNavItem(
            id: 'inventario',
            title: 'Inventário',
            subtitle: 'Material e activos',
            icon: Icons.inventory_2_outlined,
            route: '/inventario',
          ),
          AppNavItem(
            id: 'notificacoes',
            title: 'Notificações',
            subtitle: 'Avisos e alertas',
            icon: Icons.notifications_outlined,
            route: '/notificacoes',
          ),
        ],
      ),
      const AppNavSection(
        id: 'analise',
        title: 'Análise',
        subtitle: 'Relatórios e exportação',
        icon: Icons.assessment_outlined,
        items: [
          AppNavItem(
            id: 'rel_alunos',
            title: 'Rel. alunos',
            subtitle: 'Listagens e estatísticas',
            icon: Icons.people_alt_outlined,
            route: '/relatorios/alunos',
            visible: _canReports,
          ),
          AppNavItem(
            id: 'rel_financeiro',
            title: 'Rel. financeiro',
            subtitle: 'Receitas e despesas',
            icon: Icons.bar_chart_outlined,
            route: '/relatorios/financeiro',
            visible: _canReports,
          ),
          AppNavItem(
            id: 'rel_notas',
            title: 'Rel. notas',
            subtitle: 'Pautas e boletins',
            icon: Icons.school_outlined,
            route: '/relatorios/notas',
            visible: _canReports,
          ),
        ],
      ),
    ];

    return all
        .map((s) {
          final visible = s.visibleItems(user);
          if (visible.isEmpty) return null;
          return AppNavSection(
            id: s.id,
            title: s.title,
            subtitle: s.subtitle,
            icon: s.icon,
            items: visible,
          );
        })
        .whereType<AppNavSection>()
        .toList();
  }

  /// Atalhos da barra inferior (mobile).
  static List<AppNavItem> quickBottomNav(Utilizador? user) {
    final items = <AppNavItem>[
      const AppNavItem(
        id: 'dashboard',
        title: 'Painel',
        subtitle: '',
        icon: Icons.dashboard_outlined,
        route: '/',
      ),
      const AppNavItem(
        id: 'alunos',
        title: 'Alunos',
        subtitle: '',
        icon: Icons.people_outline_rounded,
        route: '/alunos',
      ),
      const AppNavItem(
        id: 'matriculas',
        title: 'Matrículas',
        subtitle: '',
        icon: Icons.how_to_reg_outlined,
        route: '/matriculas',
      ),
      const AppNavItem(
        id: 'propinas',
        title: 'Propinas',
        subtitle: '',
        icon: Icons.receipt_long_outlined,
        route: '/financeiro/propinas',
        visible: _canFinance,
      ),
      const AppNavItem(
        id: 'custos',
        title: 'Custos',
        subtitle: '',
        icon: Icons.trending_down_outlined,
        route: '/financeiro/custos',
        visible: _canFinance,
      ),
    ];
    return items.where((i) => i.isVisibleFor(user)).toList();
  }

  static int quickNavIndex(String location, List<AppNavItem> items) {
    for (var i = 0; i < items.length; i++) {
      if (isRouteActive(location, items[i].route)) return i;
    }
    return 0;
  }

  static const AppNavItem configuracoes = AppNavItem(
    id: 'configuracoes',
    title: 'Definições',
    subtitle: 'Conta e instituição',
    icon: Icons.settings_outlined,
    route: '/configuracoes',
  );

  static bool _canFinance(Utilizador? u) => u?.canViewFinance ?? false;
  static bool _canReports(Utilizador? u) => u?.canViewReports ?? false;
}
