import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/edu_card.dart';

class DashboardStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? accentColor;
  final String? label1;
  final String? value1;
  final String? label2;
  final String? value2;
  final String? label3;
  final String? value3;
  final String? label4;
  final String? value4;

  const DashboardStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.accentColor,
    this.label1,
    this.value1,
    this.label2,
    this.value2,
    this.label3,
    this.value3,
    this.label4,
    this.value4,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppTokens.primary;

    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTokens.radiusSM),
                ),
                child: Icon(icon, size: 20, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTokens.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                    letterSpacing: -0.5,
                  ),
            ),
          ),
          if (value1 != null || value2 != null || value3 != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (value1 != null) Expanded(child: _metric(label1, value1, AppTokens.primary)),
                if (value2 != null) Expanded(child: _metric(label2, value2, AppTokens.warning)),
                if (value3 != null) Expanded(child: _metric(label3, value3, AppTokens.error)),
                if (value4 != null) Expanded(child: _metric(label4, value4, AppTokens.success)),
              ],
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTokens.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metric(String? label, String? value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color.withValues(alpha: 0.9)),
        ),
        Text(
          value ?? '',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
