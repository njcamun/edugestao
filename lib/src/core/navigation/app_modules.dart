import 'package:flutter/material.dart';
import '../../domain/entities/utilizador.dart';

enum AppModuleStatus { available, comingSoon }

class AppModule {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final AppModuleStatus status;
  final bool Function(Utilizador? user)? visible;

  const AppModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.status = AppModuleStatus.available,
    this.visible,
  });

  bool isVisibleFor(Utilizador? user) => visible?.call(user) ?? true;
}

/// Definição central dos módulos EDUCLASS.
class AppModules {
  static const dashboard = AppModule(
    id: 'dashboard',
    title: 'Painel',
    subtitle: 'Visão geral da escola',
    icon: Icons.dashboard_outlined,
    route: '/',
  );

  static const alunos = AppModule(
    id: 'alunos',
    title: 'Alunos',
    subtitle: 'Cadastro e histórico',
    icon: Icons.people_outline_rounded,
    route: '/alunos',
  );

  static const matriculas = AppModule(
    id: 'matriculas',
    title: 'Matrículas',
    subtitle: 'Inscrições e renovações',
    icon: Icons.how_to_reg_outlined,
    route: '/alunos',
  );

  static const turmas = AppModule(
    id: 'turmas',
    title: 'Turmas e classes',
    subtitle: 'Salas, turnos e capacidade',
    icon: Icons.class_outlined,
    route: '/alunos',
  );

  static const funcionarios = AppModule(
    id: 'funcionarios',
    title: 'Funcionários',
    subtitle: 'Cadastro e presença',
    icon: Icons.badge_outlined,
    route: '/funcionarios',
  );

  static const propinas = AppModule(
    id: 'propinas',
    title: 'Propinas',
    subtitle: 'Pagamentos e recibos',
    icon: Icons.account_balance_wallet_outlined,
    route: '/financeiro',
    visible: _canFinance,
  );

  static const salarios = AppModule(
    id: 'salarios',
    title: 'Salários',
    subtitle: 'Processamento mensal',
    icon: Icons.payments_outlined,
    route: '/salarios',
    visible: _canFinance,
  );

  static const financas = AppModule(
    id: 'financas',
    title: 'Finanças',
    subtitle: 'Entradas, saídas e caixa',
    icon: Icons.show_chart_outlined,
    route: '/financeiro',
    visible: _canFinance,
  );

  static const inventario = AppModule(
    id: 'inventario',
    title: 'Inventário',
    subtitle: 'Activos e manutenção',
    icon: Icons.inventory_2_outlined,
    route: '/inventario',
  );

  static const relatorios = AppModule(
    id: 'relatorios',
    title: 'Relatórios',
    subtitle: 'PDF, Excel e impressão',
    icon: Icons.assessment_outlined,
    route: '/relatorios',
    visible: _canReports,
  );

  static const configuracoes = AppModule(
    id: 'configuracoes',
    title: 'Definições',
    subtitle: 'Instituição e utilizadores',
    icon: Icons.settings_outlined,
    route: '/configuracoes',
  );

  static const horarios = AppModule(
    id: 'horarios',
    title: 'Horários',
    subtitle: 'Grade horária por turma',
    icon: Icons.schedule_outlined,
    route: '/horarios',
  );

  static const notas = AppModule(
    id: 'notas',
    title: 'Notas e avaliações',
    subtitle: 'Consulta e lançamento',
    icon: Icons.grade_outlined,
    route: '/notas',
  );

  static const notificacoes = AppModule(
    id: 'notificacoes',
    title: 'Notificações',
    subtitle: 'Avisos internos da escola',
    icon: Icons.notifications_outlined,
    route: '/notificacoes',
  );

  static bool _canFinance(Utilizador? u) => u?.canViewFinance ?? false;
  static bool _canReports(Utilizador? u) => u?.canViewReports ?? false;

  static const List<AppModule> _available = [
    dashboard,
    alunos,
    matriculas,
    turmas,
    funcionarios,
    propinas,
    salarios,
    financas,
    inventario,
    relatorios,
    configuracoes,
    horarios,
    notas,
    notificacoes,
  ];

  static const List<AppModule> _comingSoon = [];

  static List<AppModule> all(Utilizador? user) =>
      _available.where((m) => m.isVisibleFor(user)).toList();

  /// Catálogo completo para o hub de módulos (exclui painel).
  static List<AppModule> catalog(Utilizador? user) => [
        ...all(user).where((m) => m.id != 'dashboard'),
        ..._comingSoon.where((m) => m.isVisibleFor(user)),
      ];

  /// Itens principais da sidebar / navegação rápida.
  static List<AppModule> primaryNav(Utilizador? user) => [
        dashboard,
        alunos,
        horarios,
        notas,
        funcionarios,
        if (_canFinance(user)) salarios,
        if (_canFinance(user)) financas,
        inventario,
        if (_canReports(user)) relatorios,
        notificacoes,
      ];

  static AppModule? findById(String id) {
    try {
      return [..._available, ..._comingSoon].firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  static String sectionTitleFor(String location) {
    if (location == '/') return 'Painel principal';
    if (location.startsWith('/alunos')) return 'Secretaria académica';
    if (location == '/funcionarios') return 'Funcionários';
    if (location == '/salarios') return 'Salários';
    if (location == '/inventario') return 'Inventário';
    if (location == '/financeiro') return 'Gestão financeira';
    if (location == '/relatorios') return 'Relatórios';
    if (location == '/configuracoes') return 'Definições';
    if (location == '/notificacoes') return 'Notificações';
    if (location == '/horarios') return 'Horários';
    if (location == '/notas') return 'Notas e avaliações';
    if (location == '/modulos') return 'Todos os módulos';
    if (location.startsWith('/modulos/')) {
      final id = location.replaceFirst('/modulos/', '');
      return findById(id)?.title ?? 'Módulo';
    }
    return 'EDUCLASS';
  }

  static String sectionSubtitleFor(String location) {
    if (location == '/') return 'Visão geral da escola';
    if (location.startsWith('/alunos')) return 'Alunos, turmas e matrículas';
    if (location == '/funcionarios') return 'Equipa, cargos e presença';
    if (location == '/salarios') return 'Processamento e pagamentos';
    if (location == '/inventario') return 'Activos, estado e manutenção';
    if (location == '/financeiro') return 'Propinas, custos e fluxo de caixa';
    if (location == '/relatorios') return 'Exportação e análise';
    if (location == '/configuracoes') return 'Dados da instituição';
    if (location == '/notificacoes') return 'Avisos e alertas do sistema';
    if (location == '/horarios') return 'Organização de aulas por turma';
    if (location == '/notas') return 'Acompanhamento académico';
    if (location == '/modulos') return 'Acesso a todas as áreas';
    return 'Gestão escolar';
  }
}
