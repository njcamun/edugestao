import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/layout/adaptive.dart';
import '../../core/navigation/app_modules.dart';
import '../../core/theme/app_tokens.dart';
import '../../state/session.dart';
import '../../features/settings/settings_controller.dart';
import '../../data/sync/sync_service.dart';
import '../../domain/entities/utilizador.dart';
import '../../shared/widgets/edu_logo.dart';
import '../../shared/widgets/global_search_dialog.dart';
import '../../features/notifications/notifications_controller.dart';

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
                if (!isMobile) _buildSidebar(context, ref, location, constraints, perfil),
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader(
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
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: verticalPadding,
                              ),
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
          bottomNavigationBar: isMobile
              ? _buildBottomBar(context, location, ref, perfil, isCompactMobile)
              : null,
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    String location,
    String? institutionName,
    String? logoPath,
    Utilizador? perfil,
    bool isSyncing,
    bool isCompactMobile,
  ) {
    final title = AppModules.sectionTitleFor(location);
    final subtitle = AppModules.sectionSubtitleFor(location);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isCompactMobile ? 12 : 20,
        isCompactMobile ? 12 : 16,
        isCompactMobile ? 12 : 20,
        isCompactMobile ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        border: Border(bottom: BorderSide(color: AppTokens.border.withValues(alpha: 0.9))),
        boxShadow: [
          BoxShadow(
            color: AppTokens.primaryDark.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (logoPath != null && logoPath.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(
                          logoPath,
                          height: 36,
                          width: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _institutionIcon(),
                        )
                      : Image.file(
                          File(logoPath),
                          height: 36,
                          width: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _institutionIcon(),
                        ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institutionName ?? AppTokens.appName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTokens.primaryDark,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$title · $subtitle',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTokens.textMuted,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              if (perfil != null && !isCompactMobile) _userChip(perfil),
              if (isSyncing)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.sync_rounded, size: 22),
                tooltip: 'Sincronizar',
                color: AppTokens.textSecondary,
                onPressed: isSyncing ? null : () => _runManualSync(context, ref),
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded, size: 22),
                tooltip: 'Pesquisa global',
                color: AppTokens.textSecondary,
                onPressed: () => _showGlobalSearch(context),
              ),
              if (location != '/configuracoes')
                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 22),
                  tooltip: 'Definições',
                  color: AppTokens.textSecondary,
                  onPressed: () => context.go('/configuracoes'),
                ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, size: 22),
                tooltip: 'Sair',
                color: AppTokens.error.withValues(alpha: 0.85),
                onPressed: () => _showLogoutConfirm(context, ref),
              ),
            ],
          ),
          if (isCompactMobile && perfil != null) ...[
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerLeft, child: _userChip(perfil)),
          ],
          const SizedBox(height: 10),
          _SearchField(onTap: () => _showGlobalSearch(context)),
        ],
      ),
    );
  }

  Widget _institutionIcon() {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: AppTokens.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.school_rounded, color: AppTokens.primary, size: 20),
    );
  }

  Widget _userChip(Utilizador perfil) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTokens.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppTokens.primary,
            child: Text(
              perfil.nome.isNotEmpty ? perfil.nome[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                perfil.nome,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                perfil.perfil.name,
                style: const TextStyle(fontSize: 10, color: AppTokens.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    WidgetRef ref,
    String location,
    BoxConstraints constraints,
    Utilizador? perfil,
  ) {
    final isExtended = constraints.maxWidth >= 1200;
    final navItems = AppModules.primaryNav(perfil);

    return Container(
      width: isExtended ? 248 : 76,
      decoration: const BoxDecoration(
        color: AppTokens.primaryDark,
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(2, 0)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: isExtended ? 24 : 20, horizontal: 12),
            child: isExtended
                ? const Column(
                    children: [
                      EduLogo(height: 48, titleColor: Colors.white),
                    ],
                  )
                : Image.asset(
                    AppTokens.logoAsset,
                    height: 40,
                    errorBuilder: (_, __, ___) => const Icon(Icons.school_rounded, color: Colors.white, size: 32),
                  ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                ...navItems.map((item) {
                  final badge = item.id == 'notificacoes'
                      ? ref.watch(unreadNotificationsCountProvider).valueOrNull
                      : null;
                  return _SidebarNavTile(
                    module: item,
                    isSelected: _isRouteSelected(location, item.route),
                    isExtended: isExtended,
                    badgeCount: badge != null && badge > 0 ? badge : null,
                  );
                }),
                const SizedBox(height: 8),
                _SidebarNavTile(
                  module: const AppModule(
                    id: 'modulos',
                    title: 'Módulos',
                    subtitle: 'Ver todos',
                    icon: Icons.apps_rounded,
                    route: '/modulos',
                  ),
                  isSelected: location == '/modulos' || location.startsWith('/modulos/'),
                  isExtended: isExtended,
                ),
              ],
            ),
          ),
          if (perfil != null && isExtended)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTokens.primary,
                    child: Text(
                      perfil.nome[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          perfil.nome,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          perfil.perfil.name,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          InkWell(
            onTap: () => _showLogoutConfirm(context, ref),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.white.withValues(alpha: 0.85), size: 20),
                  if (isExtended) ...[
                    const SizedBox(width: 12),
                    Text('Sair', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isRouteSelected(String location, String route) {
    if (route == '/') return location == '/';
    return location == route || location.startsWith('$route/');
  }

  Widget _buildBottomBar(
    BuildContext context,
    String location,
    WidgetRef ref,
    Utilizador? perfil,
    bool isCompactMobile,
  ) {
    final destinations = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Início'),
      const NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school_rounded), label: 'Secretaria'),
      const NavigationDestination(icon: Icon(Icons.apps_outlined), selectedIcon: Icon(Icons.apps_rounded), label: 'Módulos'),
      if (perfil?.canViewFinance ?? false)
        const NavigationDestination(icon: Icon(Icons.payments_outlined), selectedIcon: Icon(Icons.payments_rounded), label: 'Finanças'),
      if (perfil?.canViewReports ?? false)
        const NavigationDestination(icon: Icon(Icons.assessment_outlined), selectedIcon: Icon(Icons.assessment_rounded), label: 'Relatórios'),
    ];

    final routes = ['/', '/alunos', '/modulos'];
    if (perfil?.canViewFinance ?? false) routes.add('/financeiro');
    if (perfil?.canViewReports ?? false) routes.add('/relatorios');

    return Container(
      decoration: BoxDecoration(
        color: AppTokens.surface,
        border: Border(top: BorderSide(color: AppTokens.border.withValues(alpha: 0.9))),
        boxShadow: AppTokens.cardShadow,
      ),
      child: NavigationBar(
        height: isCompactMobile ? 60 : 64,
        labelBehavior: isCompactMobile
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _bottomIndex(location, routes),
        onDestinationSelected: (i) {
          if (i < routes.length) context.go(routes[i]);
        },
        destinations: destinations,
      ),
    );
  }

  int _bottomIndex(String location, List<String> routes) {
    for (var i = 0; i < routes.length; i++) {
      final r = routes[i];
      if (r == '/') {
        if (location == '/') return i;
      } else if (location == r || location.startsWith('$r/')) {
        return i;
      }
    }
    return 0;
  }

  Future<void> _runManualSync(BuildContext context, WidgetRef ref) async {
    try {
      final msg = await ref.read(syncServiceProvider).syncManualSafe();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha na sincronização: $e')),
      );
    }
  }

  void _showGlobalSearch(BuildContext context) {
    showDialog(context: context, builder: (_) => const GlobalSearchDialog());
  }

  void _showLogoutConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do sistema'),
        content: const Text('Tem a certeza que deseja encerrar a sua sessão?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(sessionProvider.notifier).logout();
            },
            child: const Text('Sair', style: TextStyle(color: AppTokens.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchField({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTokens.background,
      borderRadius: BorderRadius.circular(AppTokens.radiusMD),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.radiusMD),
            border: Border.all(color: AppTokens.border),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 20, color: AppTokens.textMuted.withValues(alpha: 0.9)),
              const SizedBox(width: 10),
              Text(
                'Pesquisar aluno, turma, funcionário...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTokens.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarNavTile extends StatelessWidget {
  final AppModule module;
  final bool isSelected;
  final bool isExtended;
  final int? badgeCount;

  const _SidebarNavTile({
    required this.module,
    required this.isSelected,
    required this.isExtended,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        child: InkWell(
          onTap: () => context.go(module.route),
          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isExtended ? 14 : 0, vertical: 12),
            child: Row(
              mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (isSelected && isExtended)
                  Container(
                    width: 3,
                    height: 20,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppTokens.accentYellow,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                Icon(
                  module.icon,
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.65),
                  size: 22,
                ),
                if (isExtended) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      module.title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.75),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                if (badgeCount != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTokens.accentYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeCount! > 99 ? '99+' : '$badgeCount',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTokens.primaryDark),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
