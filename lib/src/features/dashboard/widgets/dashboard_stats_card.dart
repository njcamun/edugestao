import 'package:flutter/material.dart';
import '../../../core/theme/app_tokens.dart';

class DashboardStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
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
    this.iconColor,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusLG),
        border: Border.all(color: Colors.black, width: 2), // Borda preta vincada
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(), // Estilo mais brutalista
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, size: 20, color: Colors.black),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
              if (value1 != null || value2 != null || value3 != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (value1 != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label1?.toUpperCase() ?? '', 
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                            Text(value1!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    if (value2 != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label2?.toUpperCase() ?? '', 
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orange)),
                            Text(value2!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    if (value3 != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label3?.toUpperCase() ?? '', 
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                            Text(value3!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    if (value4 != null)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label4?.toUpperCase() ?? '', 
                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.teal)),
                            Text(value4!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
