import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class EduSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const EduSectionTitle(this.title, {super.key, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTokens.primaryDark,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
