import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/entities/utilizador.dart';
import '../../shared/firebase_service.dart';
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_empty_state.dart';
import '../../core/router/app_router.dart';

final usersListProvider = StreamProvider<List<Utilizador>>((ref) {
  final firestore = ref.watch(firebaseServiceProvider).db;
  return firestore.collection('utilizadores').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Utilizador.fromFirestore(doc.data(), doc.id)).toList();
  });
});

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Utilizadores do sistema',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTokens.textPrimary,
                      ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showAddUserDialog(context),
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text('Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: AppTokens.paddingMD),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return EduEmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'Nenhum utilizador',
                    message: 'Adicione o primeiro utilizador para permitir acesso à aplicação.',
                    actionLabel: 'Adicionar utilizador',
                    onAction: () => _showAddUserDialog(context),
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppTokens.paddingSM),
                  itemBuilder: (context, index) => _UserCard(user: users[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTokens.primary)),
              error: (e, _) => EduEmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Erro ao carregar',
                message: e.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const _AddUserDialog());
  }
}

class _AddUserDialog extends ConsumerStatefulWidget {
  const _AddUserDialog();

  @override
  ConsumerState<_AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends ConsumerState<_AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  Perfil _perfilSelecionado = Perfil.user;
  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final firestore = ref.read(firebaseServiceProvider).db;
      await firestore.collection('utilizadores').add({
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim().toLowerCase(),
        'perfil': _perfilSelecionado.name,
        'senhaInicial': _senhaController.text,
        'ativo': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Utilizador registado com sucesso.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppTokens.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 640;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLG)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isCompact ? width * 0.96 : 440),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? AppTokens.paddingMD : AppTokens.paddingLG),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Novo utilizador',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  _buildField('Nome completo', _nomeController, Icons.person_outline_rounded),
                  const SizedBox(height: AppTokens.paddingMD),
                  _buildField('E-mail de acesso', _emailController, Icons.email_outlined, keyboard: TextInputType.emailAddress),
                  const SizedBox(height: AppTokens.paddingMD),
                  _buildField('Senha inicial', _senhaController, Icons.lock_outline_rounded, isObscure: true),
                  const SizedBox(height: AppTokens.paddingMD),
                  DropdownButtonFormField<Perfil>(
                    value: _perfilSelecionado,
                    decoration: _inputDecoration('Perfil de acesso'),
                    items: Perfil.values
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(_perfilLabel(p)),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _perfilSelecionado = val!),
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving ? null : () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _isSaving ? null : _submit,
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Registar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusMD)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusMD),
        borderSide: const BorderSide(color: AppTokens.primary, width: 2),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isObscure = false,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboard,
      decoration: _inputDecoration(label).copyWith(prefixIcon: Icon(icon, color: AppTokens.primary)),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
    );
  }

  String _perfilLabel(Perfil p) {
    return switch (p) {
      Perfil.admin => 'Administrador',
      Perfil.superUser => 'Super utilizador',
      Perfil.geral => 'Geral',
      Perfil.user => 'Utilizador',
    };
  }
}

class _UserCard extends ConsumerWidget {
  final Utilizador user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EduCard(
      padding: const EdgeInsets.symmetric(horizontal: AppTokens.paddingMD, vertical: AppTokens.paddingSM),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTokens.primary.withValues(alpha: 0.12),
            foregroundColor: AppTokens.primaryDark,
            child: Text(
              user.nome.isNotEmpty ? user.nome[0].toUpperCase() : '?',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: AppTokens.paddingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nome,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppTokens.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(user.email, style: const TextStyle(fontSize: 13, color: AppTokens.textSecondary)),
                const SizedBox(height: 6),
                _PerfilChip(perfil: user.perfil),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppTokens.textSecondary),
            onSelected: (action) async {
              if (action == 'delete') {
                _confirmDelete(context, ref);
              } else {
                final perfil = Perfil.values.byName(action);
                final firestore = ref.read(firebaseServiceProvider).db;
                await firestore.collection('utilizadores').doc(user.id).update({'perfil': perfil.name});
              }
            },
            itemBuilder: (context) => [
              ...Perfil.values.map(
                (p) => PopupMenuItem(
                  value: p.name,
                  child: Text('Alterar para ${_perfilLabel(p)}'),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Eliminar', style: TextStyle(color: AppTokens.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _perfilLabel(Perfil p) {
    return switch (p) {
      Perfil.admin => 'Administrador',
      Perfil.superUser => 'Super utilizador',
      Perfil.geral => 'Geral',
      Perfil.user => 'Utilizador',
    };
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar utilizador'),
        content: Text('Tem a certeza que deseja remover ${user.nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final firestore = ref.read(firebaseServiceProvider).db;
              await firestore.collection('utilizadores').doc(user.id).delete();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Eliminar', style: TextStyle(color: AppTokens.error)),
          ),
        ],
      ),
    );
  }
}

class _PerfilChip extends StatelessWidget {
  final Perfil perfil;
  const _PerfilChip({required this.perfil});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (perfil) {
      Perfil.admin => ('Admin', AppTokens.primaryDark),
      Perfil.superUser => ('Super', AppTokens.info),
      Perfil.geral => ('Geral', AppTokens.accentPurple),
      Perfil.user => ('Utilizador', AppTokens.textSecondary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTokens.radiusSM),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
