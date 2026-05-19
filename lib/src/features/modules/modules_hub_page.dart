import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/app_modules.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_card.dart';
import '../../state/session.dart';

class ModulesHubPage extends ConsumerWidget {
  const ModulesHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionProvider).perfil;
    final modules = AppModules.catalog(user);

    return ListView.separated(
      itemCount: modules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final module = modules[index];
        return EduCard(
          onTap: () => context.go(module.route),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTokens.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                ),
                child: Icon(module.icon, color: AppTokens.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      module.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTokens.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTokens.textMuted),
            ],
          ),
        );
      },
    );
  }
}
