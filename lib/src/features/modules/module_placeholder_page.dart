import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/app_modules.dart';
import '../../core/theme/app_tokens.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../../shared/widgets/edu_primary_button.dart';

class ModulePlaceholderPage extends StatelessWidget {
  final AppModule module;

  const ModulePlaceholderPage({super.key, required this.module});

  static const Map<String, List<String>> _roadmap = {
    'horarios': [
      'Grade horária por turma e professor',
      'Conflitos de sala automaticamente',
      'Exportação em PDF',
    ],
    'notas': [
      'Lançamento por disciplina e trimestre',
      'Médias e pautas finais',
      'Histórico por aluno',
    ],
    'notificacoes': [
      'Avisos para encarregados e staff',
      'Lembretes de propinas e eventos',
      'Centro de notificações na app',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final features = _roadmap[module.id] ?? const [
      'Interface alinhada ao design EDUCLASS',
      'Sincronização offline-first',
      'Integração com dados existentes',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EduEmptyState(
            icon: module.icon,
            title: module.title,
            message:
                'Este módulo está planeado para uma próxima actualização. '
                'As funcionalidades actuais da aplicação permanecem disponíveis.',
          ),
          const SizedBox(height: AppTokens.paddingLG),
          EduCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próximas funcionalidades',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTokens.textPrimary,
                      ),
                ),
                const SizedBox(height: AppTokens.paddingMD),
                ...features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 18, color: AppTokens.primary.withValues(alpha: 0.8)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(f, style: const TextStyle(color: AppTokens.textSecondary, fontSize: 14))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTokens.paddingLG),
          EduPrimaryButton(
            label: 'Voltar aos módulos',
            icon: Icons.apps_rounded,
            outlined: true,
            onPressed: () => context.go('/modulos'),
          ),
        ],
      ),
    );
  }
}
