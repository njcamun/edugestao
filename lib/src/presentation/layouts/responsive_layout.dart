import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/layout/adaptive.dart';
import '../../core/theme/app_tokens.dart';
import '../../state/session.dart';
import '../../features/settings/settings_controller.dart';
import '../../data/sync/sync_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../domain/entities/utilizador.dart';

class ResponsiveLayout extends ConsumerWidget {
  final Widget child;
  const ResponsiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final settingsAsync = ref.watch(settingsProvider);
    final session = ref.watch(sessionProvider);
    final perfil = session.perfil;
    final isSyncing = ref.watch(isSyncingProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = context.isMobile;
        final isCompactMobile = context.isCompact;
        final horizontalPadding = context.contentHorizontalPadding();
        final verticalPadding = context.contentVerticalPadding();
        final maxContentWidth = context.maxContentWidth();

        return Scaffold(
          backgroundColor: AppTokens.background,
          body: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (!isMobile) _buildSidebar(context, ref, location, constraints),
                Expanded(
                  child: Column(
                    children: [
                      _buildUnifiedHeader(
                        context,
                        ref,
                        location,
                        settingsAsync.value?.nomeInstituicao,
                        settingsAsync.value?.logotipoUrl,
                        perfil,
                        isSyncing,
                        isCompactMobile,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxContentWidth),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isMobile ? _buildBottomBar(context, location, ref, perfil, isCompactMobile) : null,
        );
      },
    );
  }

  Widget _buildUnifiedHeader(
    BuildContext context,
    WidgetRef ref,
    String location,
    String? institutionName,
    String? logoPath,
    Utilizador? perfil,
    bool isSyncing,
    bool isCompactMobile,
  ) {
    String sectionTitle = 'PAINEL PRINCIPAL';
    String subtitle = 'Visão geral do sistema.';

    if (location.startsWith('/alunos')) {
      sectionTitle = 'SECRETARIA ACADÉMICA';
      subtitle = 'Alunos, Turmas e Matrículas';
    } else if (location == '/financeiro') {
      sectionTitle = 'GESTÃO FINANCEIRA';
      subtitle = 'Propinas e Pagamentos';
    } else if (location == '/relatorios') {
      sectionTitle = 'RELATÓRIOS E ANÁLISE';
      subtitle = 'Estatísticas e Exportação';
    } else if (location == '/configuracoes') {
      sectionTitle = 'DADOS DA INSTITUIÇÃO';
      subtitle = 'Configurações e Identidade';
    }

    final titleFontSize = isCompactMobile ? 14.0 : 18.0;
    final subtitleFontSize = isCompactMobile ? 9.0 : 10.0;
    final headerPadding = isCompactMobile
        ? const EdgeInsets.fromLTRB(12, 12, 12, 10)
        : const EdgeInsets.fromLTRB(24, 24, 24, 16);

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (perfil != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  perfil.nome.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                ),
                Text(
                  perfil.perfil.name.toUpperCase(),
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        if (isSyncing)
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 16,
            height: 16,
            child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
          ),
        IconButton(
          icon: const Icon(Icons.sync_rounded, color: Colors.white, size: 20),
          tooltip: 'Sincronizar agora',
          onPressed: isSyncing ? null : () => _runManualSync(context, ref),
        ),
        if (location != '/configuracoes')
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
            tooltip: 'Definições',
            onPressed: () => context.go('/configuracoes'),
          ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
          tooltip: 'Sair do Sistema',
          onPressed: () => _showLogoutConfirm(context, ref),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: headerPadding,
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (logoPath != null && logoPath.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: kIsWeb
                      ? Image.network(logoPath, height: 40, width: 40, fit: BoxFit.cover)
                      : Image.file(
                          File(logoPath),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, color: Colors.white, size: 32),
                        ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institutionName?.toUpperCase() ?? 'SISTEMA DE GESTÃO',
                      style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$sectionTitle  •  $subtitle',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              !isCompactMobile ? actions : const SizedBox.shrink(),
            ],
          ),
          isCompactMobile
              ? Align(
                  alignment: Alignment.centerRight,
                  child: actions,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Future<void> _runManualSync(BuildContext context, WidgetRef ref) async {
    try {
      final msg = await ref.read(syncServiceProvider).syncManualSafe();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha na sincronizacao manual: $e')),
      );
    }
  }

  void _showLogoutConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: const Text('SAIR DO SISTEMA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: const Text('TEM A CERTEZA QUE DESEJA ENCERRAR A SUA SESSÃO?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(sessionProvider.notifier).logout();
            },
            child: const Text('SAIR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, String location, BoxConstraints constraints) {
    final isExtended = constraints.maxWidth >= 1200;
    return Container(
      width: isExtended ? 260 : 80,
      decoration: const BoxDecoration(color: AppTokens.surface, border: Border(right: BorderSide(color: AppTokens.border, width: 1))),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Icon(Icons.account_balance_rounded, size: 32, color: AppTokens.slate900),
          ),
          Expanded(child: _SidebarMenu(location: location, isExtended: isExtended, perfil: ref.watch(sessionProvider).perfil)),
          const Divider(),
          if (ref.watch(sessionProvider).perfil != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black,
                    child: Text(
                      ref.watch(sessionProvider).perfil!.nome[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (isExtended) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref.watch(sessionProvider).perfil!.nome,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ref.watch(sessionProvider).perfil!.perfil.name.toUpperCase(),
                            style: TextStyle(fontSize: 9, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          InkWell(
            onTap: () => _showLogoutConfirm(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: AppTokens.error, size: 20),
                  if (isExtended) ...[
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text('Sair do Sistema', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTokens.error)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, String location, WidgetRef ref, Utilizador? perfil, bool isCompactMobile) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppTokens.border))),
      child: NavigationBar(
        backgroundColor: AppTokens.surface,
        elevation: 0,
        height: isCompactMobile ? 58 : 64,
        labelBehavior: isCompactMobile
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _getSelectedIndex(location, perfil),
        onDestinationSelected: (index) => _onItemTapped(index, context, perfil),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Início'),
          const NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Secretaria'),
          if (perfil?.canViewFinance ?? false) const NavigationDestination(icon: Icon(Icons.payments_outlined), label: 'Finanças'),
          if (perfil?.canViewReports ?? false) const NavigationDestination(icon: Icon(Icons.assessment_outlined), label: 'Relatórios'),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location, Utilizador? perfil) {
    if (location == '/') return 0;
    if (location.startsWith('/alunos')) return 1;
    if (location == '/financeiro') return 2;
    if (location == '/relatorios') return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, Utilizador? perfil) {
    final routes = ['/', '/alunos'];
    if (perfil?.canViewFinance ?? false) routes.add('/financeiro');
    if (perfil?.canViewReports ?? false) routes.add('/relatorios');
    if (index < routes.length) context.go(routes[index]);
  }
}

class _SidebarMenu extends StatelessWidget {
  final String location;
  final bool isExtended;
  final Utilizador? perfil;
  const _SidebarMenu({required this.location, required this.isExtended, this.perfil});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        _SidebarItem(label: 'DASHBOARD', icon: Icons.dashboard_outlined, route: '/', isSelected: location == '/', isExtended: isExtended),
        _SidebarItem(label: 'SECRETARIA', icon: Icons.school_outlined, route: '/alunos', isSelected: location.startsWith('/alunos'), isExtended: isExtended),
        if (perfil?.canViewFinance ?? false) _SidebarItem(label: 'FINANCEIRO', icon: Icons.payments_outlined, route: '/financeiro', isSelected: location == '/financeiro', isExtended: isExtended),
        if (perfil?.canViewReports ?? false) _SidebarItem(label: 'RELATÓRIOS', icon: Icons.assessment_outlined, route: '/relatorios', isSelected: location == '/relatorios', isExtended: isExtended),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;
  final bool isSelected;
  final bool isExtended;

  const _SidebarItem({required this.label, required this.icon, required this.route, required this.isSelected, required this.isExtended});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isExtended ? 16 : 0, 
          vertical: 12
        ),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.black45, size: 20),
            if (isExtended) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    color: isSelected ? Colors.black : Colors.black87,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
