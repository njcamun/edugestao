import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';

class DashboardKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? trend;
  final IconData icon;
  final Color? color;

  const DashboardKpiCard({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
        border: Border.all(color: AppTokens.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTokens.slate600,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, size: 18, color: color ?? AppTokens.slate900),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppTokens.slate900,
              letterSpacing: -1,
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 8),
            Text(
              trend!,
              style: TextStyle(
                fontSize: 11,
                color: trend!.contains('+') ? AppTokens.success : AppTokens.slate400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
