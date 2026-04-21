import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/utilizador.dart';
import '../../shared/firebase_service.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) return const Center(child: Text('NENHUM UTILIZADOR ENCONTRADO.'));
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _UserCard(user: users[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
              error: (e, _) => Center(child: Text('ERRO: $e')),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => _showAddUserDialog(context, ref),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('ADICIONAR UTILIZADOR'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
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
      final newUser = {
        'nome': _nomeController.text,
        'email': _emailController.text.trim().toLowerCase(),
        'perfil': _perfilSelecionado.name,
        'senhaInicial': _senhaController.text, // Senha guardada para referência do Admin
        'ativo': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('utilizadores').add(newUser);

      if (mounted) {
        Navigator.pop(context);
        rootScaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('UTILIZADOR REGISTADO COM SUCESSO!'), backgroundColor: Colors.black),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ERRO: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 640;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black, width: 2)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isCompact ? width * 0.96 : 400),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : 24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NOVO UTILIZADOR', style: TextStyle(fontSize: isCompact ? 15 : 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const Divider(color: Colors.black, thickness: 2, height: 32),
                  _buildField('NOME COMPLETO', _nomeController, Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildField('E-MAIL DE ACESSO', _emailController, Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildField('SENHA INICIAL', _senhaController, Icons.lock_outline, isObscure: true),
                  const SizedBox(height: 16),
                  const Text('PERFIL DE ACESSO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black54)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Perfil>(
                    initialValue: _perfilSelecionado,
                    decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                    items: Perfil.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(),
                    onChanged: (val) => setState(() => _perfilSelecionado = val!),
                  ),
                  const SizedBox(height: 32),
                  isCompact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: _isSaving ? null : _submit,
                              style: FilledButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              child: _isSaving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('REGISTAR', style: TextStyle(fontWeight: FontWeight.w900)),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: _isSaving ? null : _submit,
                              style: FilledButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              child: _isSaving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('REGISTAR', style: TextStyle(fontWeight: FontWeight.w900)),
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

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon, size: 18, color: Colors.black),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
      ),
      validator: (v) => v!.isEmpty ? 'OBRIGATÓRIO' : null,
    );
  }
}

class _UserCard extends ConsumerWidget {
  final Utilizador user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 1.5)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(backgroundColor: Colors.black, child: Text(user.nome.isNotEmpty ? user.nome[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        title: Text(user.nome.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)), child: Text(user.perfil.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900))),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onSelected: (String action) async {
            if (action == 'delete') {
              _confirmDelete(context, ref);
            } else {
              final Perfil p = Perfil.values.byName(action);
              final firestore = ref.read(firebaseServiceProvider).db;
              await firestore.collection('utilizadores').doc(user.id).update({'perfil': p.name});
            }
          },
          itemBuilder: (context) => [
            ...Perfil.values.map((p) => PopupMenuItem(value: p.name, child: Text('MUDAR PARA ${p.name.toUpperCase()}'))),
            const PopupMenuDivider(),
            const PopupMenuItem(value: 'delete', child: Text('ELIMINAR UTILIZADOR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)),
        title: const Text('ELIMINAR UTILIZADOR', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text('TEM A CERTEZA QUE DESEJA REMOVER ${user.nome.toUpperCase()} DO SISTEMA?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () async {
              final firestore = ref.read(firebaseServiceProvider).db;
              await firestore.collection('utilizadores').doc(user.id).delete();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}
