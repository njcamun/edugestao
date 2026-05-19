import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

/// Barra de abas reutilizável com estilo EDUCLASS.
class EduSegmentedTabs extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<String> labels;
  final bool scrollable;

  const EduSegmentedTabs({
    super.key,
    required this.controller,
    required this.labels,
    this.scrollable = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
        border: Border.all(color: AppTokens.border),
        boxShadow: AppTokens.cardShadow,
      ),
      child: TabBar(
        controller: controller,
        isScrollable: scrollable,
        tabAlignment: scrollable ? TabAlignment.start : TabAlignment.fill,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTokens.radiusMD),
          color: AppTokens.primary,
          boxShadow: [
            BoxShadow(
              color: AppTokens.primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTokens.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        tabs: labels.map((l) => Tab(text: l)).toList(),
      ),
    );
  }
}
