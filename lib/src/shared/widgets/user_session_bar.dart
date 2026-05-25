import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/utilizador.dart';

/// Barra com utilizador autenticado («Sessão iniciada»).
class UserSessionBar extends StatelessWidget {
  final Utilizador perfil;
  final bool onDarkBackground;
  final EdgeInsetsGeometry? padding;
  final bool compact;

  const UserSessionBar({
    super.key,
    required this.perfil,
    this.onDarkBackground = true,
    this.padding,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = onDarkBackground
        ? Colors.white.withValues(alpha: 0.55)
        : AppTokens.textMuted;
    final nameColor = onDarkBackground ? Colors.white : AppTokens.textPrimary;
    final roleColor = onDarkBackground
        ? Colors.white.withValues(alpha: 0.65)
        : AppTokens.textSecondary;

    final avatarRadius = compact ? 14.0 : 17.0;
    final defaultPadding = compact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 14, vertical: 10);

    return Container(
      width: double.infinity,
      padding: padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: onDarkBackground
            ? Colors.black.withValues(alpha: 0.18)
            : AppTokens.primary.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(
            color: onDarkBackground
                ? Colors.white.withValues(alpha: 0.12)
                : AppTokens.border.withValues(alpha: 0.8),
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: onDarkBackground ? AppTokens.primary : AppTokens.primaryDark,
            child: Text(
              perfil.nome.isNotEmpty ? perfil.nome[0].toUpperCase() : '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sessão iniciada',
                  style: TextStyle(color: labelColor, fontSize: 10, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  perfil.nome,
                  style: TextStyle(
                    color: nameColor,
                    fontSize: compact ? 12 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!compact)
                  Text(
                    perfil.perfil.name,
                    style: TextStyle(color: roleColor, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
