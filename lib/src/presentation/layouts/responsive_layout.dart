import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/layout/adaptive.dart';
import '../../core/navigation/app_modules.dart';
import '../../core/navigation/app_nav_menu.dart';
import '../../core/theme/app_tokens.dart';
import '../../state/session.dart';
import '../../features/settings/settings_controller.dart';
import '../../data/sync/sync_service.dart';
import '../../domain/entities/utilizador.dart';
import '../../shared/widgets/global_search_dialog.dart';
import 'app_sidebar.dart';

class ResponsiveLayout extends ConsumerStatefulWidget {
  final Widget child;
  const ResponsiveLayout({super.key, required this.child});

  @override
  ConsumerState<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends ConsumerState<ResponsiveLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final settingsAsync = ref.watch(settingsProvider);
    final session = ref.watch(sessionProvider);
    final perfil = session.perfil;
    final isSyncing = ref.watch(isSyncingProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final useDrawer = context.useNavigationDrawer(screenWidth);
        final sidebarWidth = context.sidebarWidthFor(screenWidth);
        final horizontalPadding = context.contentHorizontalPadding();
        final verticalPadding = context.contentVerticalPadding();

        final sidebar = AppSidebar(
          location: location,
          perfil: perfil,
          onNavigate: useDrawer ? () => _scaffoldKey.currentState?.closeDrawer() : null,
        );

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppTokens.background,
          drawer: useDrawer
              ? Drawer(
                  width: math.min(300, screenWidth * 0.88),
                  child: sidebar,
                )
              : null,
          bottomNavigationBar: useDrawer
              ? _buildQuickBottomNav(context, location, perfil, context.isCompact)
              : null,
          body: SafeArea(
            bottom: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!useDrawer)
                  SizedBox(
                    width: sidebarWidth,
                    child: ClipRect(child: sidebar),
                  ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, contentConstraints) {
                      final contentWidth = contentConstraints.maxWidth;
                      final maxContentWidth = context.maxContentWidth(contentWidth);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(
                            context,
                            ref,
                            location,
                            settingsAsync.value?.nomeInstituicao,
                            settingsAsync.value?.logotipoUrl,
                            perfil,
                            isSyncing,
                            useDrawer,
                            contentWidth,
                          ),
                          Expanded(
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: maxContentWidth,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding,
                                      vertical: verticalPadding,
                                    ),
                                    child: widget.child,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
    bool useDrawer,
    double contentWidth,
  ) {
    final title = AppModules.sectionTitleFor(location);
    final subtitle = AppModules.sectionSubtitleFor(location);
    final narrow = contentWidth < 560;
    final veryNarrow = contentWidth < 400;
    return Material(
      color: AppTokens.surface,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          useDrawer ? 4 : 12,
          veryNarrow ? 8 : 12,
          useDrawer ? 8 : 16,
          veryNarrow ? 8 : 10,
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTokens.border.withValues(alpha: 0.9))),
          boxShadow: [
            BoxShadow(
              color: AppTokens.primaryDark.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (useDrawer)
              IconButton(
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Abrir menu',
                visualDensity: VisualDensity.compact,
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            if (logoPath != null && logoPath.isNotEmpty && !veryNarrow) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.network(
                        logoPath,
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _institutionIcon(),
                      )
                    : Image.file(
                        File(logoPath),
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _institutionIcon(),
                      ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    institutionName ?? AppTokens.appName,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTokens.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTokens.primaryDark,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (!veryNarrow)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTokens.textMuted,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
            ),
            if (isSyncing)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            if (narrow)
              _HeaderOverflowMenu(
                location: location,
                isSyncing: isSyncing,
                onSearch: () => _showGlobalSearch(context),
                onSync: () => _runManualSync(context, ref),
                onSettings: () => context.go('/configuracoes'),
                onLogout: () => _showLogoutConfirm(context, ref),
              )
            else
              _HeaderIconActions(
                location: location,
                isSyncing: isSyncing,
                onSearch: () => _showGlobalSearch(context),
                onSync: () => _runManualSync(context, ref),
                onSettings: () => context.go('/configuracoes'),
                onLogout: () => _showLogoutConfirm(context, ref),
              ),
          ],
        ),
      ),
    );
  }

  Widget _institutionIcon() {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: AppTokens.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.school_rounded, color: AppTokens.primary, size: 18),
    );
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

  Widget _buildQuickBottomNav(
    BuildContext context,
    String location,
    Utilizador? perfil,
    bool isCompact,
  ) {
    final items = AppNavMenu.quickBottomNav(perfil);
    final selectedIndex = AppNavMenu.quickNavIndex(location, items).clamp(0, items.length - 1);

    return Material(
      color: AppTokens.surface,
      child: NavigationBar(
        height: isCompact ? 64 : 68,
        backgroundColor: AppTokens.surface,
        indicatorColor: AppTokens.primary.withValues(alpha: 0.12),
        labelBehavior: isCompact
            ? NavigationDestinationLabelBehavior.onlyShowSelected
            : NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => context.go(items[index].route),
        destinations: [
          for (final item in items)
            NavigationDestination(
              icon: Icon(item.icon, size: 22),
              selectedIcon: Icon(_selectedIcon(item.icon), size: 22),
              label: item.title,
            ),
        ],
      ),
    );
  }

  IconData _selectedIcon(IconData outlined) {
    return switch (outlined) {
      Icons.dashboard_outlined => Icons.dashboard_rounded,
      Icons.people_outline_rounded => Icons.people_rounded,
      Icons.how_to_reg_outlined => Icons.how_to_reg_rounded,
      Icons.receipt_long_outlined => Icons.receipt_long_rounded,
      Icons.trending_down_outlined => Icons.trending_down_rounded,
      _ => outlined,
    };
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

class _HeaderIconActions extends StatelessWidget {
  final String location;
  final bool isSyncing;
  final VoidCallback onSearch;
  final VoidCallback onSync;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const _HeaderIconActions({
    required this.location,
    required this.isSyncing,
    required this.onSearch,
    required this.onSync,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.search_rounded, size: 22),
          tooltip: 'Pesquisa',
          visualDensity: VisualDensity.compact,
          onPressed: onSearch,
        ),
        IconButton(
          icon: const Icon(Icons.sync_rounded, size: 22),
          tooltip: 'Sincronizar',
          visualDensity: VisualDensity.compact,
          onPressed: isSyncing ? null : onSync,
        ),
        if (location != '/configuracoes')
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            tooltip: 'Definições',
            visualDensity: VisualDensity.compact,
            onPressed: onSettings,
          ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, size: 22),
          tooltip: 'Sair',
          visualDensity: VisualDensity.compact,
          color: AppTokens.error.withValues(alpha: 0.85),
          onPressed: onLogout,
        ),
      ],
    );
  }
}

class _HeaderOverflowMenu extends StatelessWidget {
  final String location;
  final bool isSyncing;
  final VoidCallback onSearch;
  final VoidCallback onSync;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const _HeaderOverflowMenu({
    required this.location,
    required this.isSyncing,
    required this.onSearch,
    required this.onSync,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: 'Mais opções',
      onSelected: (value) {
        switch (value) {
          case 'search':
            onSearch();
          case 'sync':
            onSync();
          case 'settings':
            onSettings();
          case 'logout':
            onLogout();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'search',
          child: ListTile(
            leading: Icon(Icons.search_rounded),
            title: Text('Pesquisar'),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ),
        PopupMenuItem(
          value: 'sync',
          enabled: !isSyncing,
          child: const ListTile(
            leading: Icon(Icons.sync_rounded),
            title: Text('Sincronizar'),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ),
        if (location != '/configuracoes')
          const PopupMenuItem(
            value: 'settings',
            child: ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Definições'),
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout_rounded, color: AppTokens.error),
            title: Text('Sair', style: TextStyle(color: AppTokens.error)),
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}
