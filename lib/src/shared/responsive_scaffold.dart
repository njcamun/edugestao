import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/session.dart';

class ResponsiveScaffold extends ConsumerWidget {
  final Widget child;
  const ResponsiveScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    const Color bgLight = Color(0xFFF8FAFC);
    const Color slate900 = Color(0xFF0F172A);
    const Color slate100 = Color(0xFFF1F5F9);

    const navItems = [
      _NavItem(label: 'Dashboard', icon: Icons.dashboard_rounded, route: '/'),
      _NavItem(label: 'Alunos', icon: Icons.people_alt_rounded, route: '/students'),
      _NavItem(label: 'Matrículas', icon: Icons.how_to_reg_rounded, route: '/enrollments'),
      _NavItem(label: 'Turmas', icon: Icons.class_rounded, route: '/classes'),
      _NavItem(label: 'Relatórios', icon: Icons.assessment_rounded, route: '/reports'),
      _NavItem(label: 'Financeiro', icon: Icons.payments_rounded, route: '/finance'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        if (isMobile) {
          return Scaffold(
            backgroundColor: bgLight,
            appBar: AppBar(
              title: const Text('Educlass', style: TextStyle(fontWeight: FontWeight.bold, color: slate900, fontFamily: 'Inter')),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () => ref.read(sessionProvider.notifier).logout(),
                  icon: const Icon(Icons.logout_rounded, color: slate900),
                ),
              ],
            ),
            body: child,
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: slate100, width: 1.5)),
              ),
              child: NavigationBar(
                backgroundColor: Colors.white,
                elevation: 0,
                selectedIndex: _getSelectedIndex(location, navItems),
                onDestinationSelected: (index) => context.go(navItems[index].route),
                destinations: navItems.map((item) {
                  return NavigationDestination(
                    icon: Icon(item.icon),
                    label: item.label,
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: bgLight,
            body: Row(
              children: [
                _buildSidebar(context, ref, location, navItems, constraints),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: child,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, String location, List<_NavItem> items, BoxConstraints constraints) {
    const Color slate900 = Color(0xFF0F172A);
    const Color slate100 = Color(0xFFF1F5F9);

    return Container(
      width: constraints.maxWidth >= 1200 ? 280 : 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: slate100, width: 1.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Image.asset('assets/images/logo.jpg', height: 40),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = location == item.route;
                final isExtended = constraints.maxWidth >= 1200;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    onTap: () => context.go(item.route),
                    selected: isSelected,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Icon(
                      item.icon,
                      color: isSelected ? Colors.blue : const Color(0xFF64748B),
                    ),
                    title: isExtended 
                      ? Text(
                          item.label,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? slate900 : const Color(0xFF64748B),
                            fontFamily: 'Inter',
                          ),
                        )
                      : null,
                    tileColor: isSelected ? Colors.blue.withAlpha(15) : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: () => ref.read(sessionProvider.notifier).logout(),
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              tooltip: 'Sair',
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location, List<_NavItem> items) {
    final index = items.indexWhere((item) => item.route == location);
    return index >= 0 ? index : 0;
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem({required this.label, required this.icon, required this.route});
}
