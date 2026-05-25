import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/app_nav_menu.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/utilizador.dart';
import '../../features/notifications/notifications_controller.dart';
import '../../shared/widgets/user_session_bar.dart';

/// Barra lateral / drawer com secções recolhíveis.
class AppSidebar extends ConsumerStatefulWidget {
  final String location;
  final Utilizador? perfil;
  final VoidCallback? onNavigate;

  const AppSidebar({
    super.key,
    required this.location,
    required this.perfil,
    this.onNavigate,
  });

  @override
  ConsumerState<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends ConsumerState<AppSidebar> {
  final Set<String> _expandedSections = {};

  @override
  void initState() {
    super.initState();
    _syncExpandedToActiveRoute();
  }

  @override
  void didUpdateWidget(covariant AppSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location || oldWidget.perfil != widget.perfil) {
      _syncExpandedToActiveRoute();
    }
  }

  /// Só expande a secção da rota actual (submenus fechados por defeito).
  void _syncExpandedToActiveRoute() {
    _expandedSections.clear();
    for (final section in AppNavMenu.sections(widget.perfil)) {
      if (section.items.length == 1 && section.id == 'principal') continue;
      if (AppNavMenu.sectionHasActiveRoute(widget.location, section, widget.perfil)) {
        _expandedSections.add(section.id);
      }
    }
  }

  void _toggleSection(String id) {
    setState(() {
      if (_expandedSections.contains(id)) {
        _expandedSections.remove(id);
      } else {
        _expandedSections.add(id);
      }
    });
  }

  void _go(BuildContext context, String route) {
    context.go(route);
    widget.onNavigate?.call();
  }

  @override
  Widget build(BuildContext context) {
    final sections = AppNavMenu.sections(widget.perfil);
    final unread = ref.watch(unreadNotificationsCountProvider).valueOrNull ?? 0;

    return Material(
      color: AppTokens.primaryDark,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
          children: [
            if (widget.perfil != null)
              UserSessionBar(
                perfil: widget.perfil!,
                compact: true,
              ),
            const SizedBox(height: 8),
            for (final section in sections) ...[
              if (section.items.length == 1 && section.id == 'principal')
                _NavTile(
                  item: section.items.first,
                  location: widget.location,
                  isSubItem: false,
                  badgeCount: null,
                  onTap: () => _go(context, section.items.first.route),
                )
              else
                _SectionBlock(
                  section: section,
                  location: widget.location,
                  isExpanded: _expandedSections.contains(section.id),
                  unreadNotifications: unread,
                  onToggle: () => _toggleSection(section.id),
                  onItemTap: (route) => _go(context, route),
                ),
              const SizedBox(height: 4),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Divider(height: 1, color: Color(0x33FFFFFF)),
            ),
            _NavTile(
              item: AppNavMenu.configuracoes,
              location: widget.location,
              isSubItem: false,
              badgeCount: null,
              onTap: () => _go(context, AppNavMenu.configuracoes.route),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final AppNavSection section;
  final String location;
  final bool isExpanded;
  final int unreadNotifications;
  final VoidCallback onToggle;
  final ValueChanged<String> onItemTap;

  const _SectionBlock({
    required this.section,
    required this.location,
    required this.isExpanded,
    required this.unreadNotifications,
    required this.onToggle,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasActive = AppNavMenu.sectionHasActiveRoute(location, section, null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: hasActive ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppTokens.radiusMD),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(section.icon, size: 18, color: Colors.white.withValues(alpha: 0.9)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      section.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Column(
              children: section.items.map((item) {
                final badge = item.id == 'notificacoes' && unreadNotifications > 0
                    ? unreadNotifications
                    : null;
                return _NavTile(
                  item: item,
                  location: location,
                  isSubItem: true,
                  badgeCount: badge,
                  onTap: () => onItemTap(item.route),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  final AppNavItem item;
  final String location;
  final bool isSubItem;
  final int? badgeCount;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.location,
    required this.isSubItem,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = AppNavMenu.isRouteActive(location, item.route);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isSelected ? Colors.white.withValues(alpha: 0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSubItem ? 12 : 10,
              vertical: isSubItem ? 7 : 9,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (badgeCount != null) _Badge(count: badgeCount!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTokens.accentYellow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTokens.primaryDark),
      ),
    );
  }
}
