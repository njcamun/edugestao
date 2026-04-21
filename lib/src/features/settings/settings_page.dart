import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/configuracao.dart';
import '../../domain/entities/utilizador.dart';
import '../../domain/entities/sync_entity.dart';
import '../../state/session.dart';
import 'settings_controller.dart';
import 'users_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nomeController;
  late TextEditingController _nifController;
  late TextEditingController _moradaController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;
  late TextEditingController _prefixoController;
  String? _logotipoPath;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _nomeController = TextEditingController();
    _nifController = TextEditingController();
    _moradaController = TextEditingController();
    _telefoneController = TextEditingController();
    _emailController = TextEditingController();
    _prefixoController = TextEditingController();
  }

  void _loadConfig(ConfiguracaoInstitucional? config) {
    if (config != null) {
      _nomeController.text = config.nomeInstituicao;
      _nifController.text = config.nif;
      _moradaController.text = config.morada;
      _telefoneController.text = config.telefone;
      _emailController.text = config.email;
      _prefixoController.text = config.reciboPrefixo;
      _logotipoPath = config.logotipoUrl;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomeController.dispose();
    _nifController.dispose();
    _moradaController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _prefixoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _logotipoPath = image.path);
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final currentConfig = ref.read(settingsProvider).value;
      final config = currentConfig ?? ConfiguracaoInstitucional();
      
      config.id = currentConfig?.id ?? const Uuid().v4();
      config.nomeInstituicao = _nomeController.text;
      config.nif = _nifController.text;
      config.morada = _moradaController.text;
      config.telefone = _telefoneController.text;
      config.email = _emailController.text;
      config.reciboPrefixo = _prefixoController.text;
      config.logotipoUrl = _logotipoPath;
      config.moedaPadrao = 'Kz';
      config.textoRodapeRelatorio = 'OBRIGADO POR CONFIAR NA NOSSA INSTITUIÇÃO.';
      
      config.createdAt = currentConfig?.createdAt ?? DateTime.now();
      config.updatedAt = DateTime.now();
      config.syncStatus = SyncStatus.pendingSync;

      await ref.read(settingsRepositoryProvider).saveConfig(config);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CONFIGURAÇÕES ACTUALIZADAS COM SUCESSO!'), backgroundColor: Colors.black),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final canEdit = session.perfil?.perfil != Perfil.user;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = width < 760;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          if (isAdmin)
            Container(
              height: isNarrow ? 42 : 45,
              margin: EdgeInsets.only(bottom: isNarrow ? 14 : 24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black, width: 1.5)),
              child: TabBar(
                controller: _tabController,
                isScrollable: isNarrow,
                tabAlignment: isNarrow ? TabAlignment.start : TabAlignment.fill,
                indicator: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: isNarrow ? 10 : 11),
                tabs: const [Tab(text: 'INSTITUIÇÃO'), Tab(text: 'UTILIZADORES')],
              ),
            ),
          Expanded(
            child: isAdmin 
              ? TabBarView(controller: _tabController, children: [_buildInstituicaoForm(settingsAsync, canEdit), const UsersPage()])
              : _buildInstituicaoForm(settingsAsync, canEdit),
          ),
        ],
      ),
    );
  }

  Widget _buildInstituicaoForm(AsyncValue<ConfiguracaoInstitucional?> settingsAsync, bool canEdit) {
    return settingsAsync.when(
      data: (config) {
        if (_nomeController.text.isEmpty) _loadConfig(config);
        final width = MediaQuery.sizeOf(context).width;
        final isNarrow = width < 780;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('IDENTIDADE VISUAL', [
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: canEdit ? _pickImage : null,
                        child: Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 2)),
                          child: _logotipoPath != null
                              ? ClipRRect(borderRadius: BorderRadius.circular(10), child: kIsWeb ? Image.network(_logotipoPath!, fit: BoxFit.cover) : Image.file(File(_logotipoPath!), fit: BoxFit.cover))
                              : const Icon(Icons.add_a_photo_outlined, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: isNarrow ? (width - 180).clamp(120.0, 320.0) : 320,
                        child: const Text('LOGÓTIPO OFICIAL DA INSTITUIÇÃO.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ]),
                const SizedBox(height: 32),
                _buildSection('DADOS GERAIS', [
                  _buildField('NOME DA INSTITUIÇÃO', _nomeController, Icons.school_outlined, capitalize: true, enabled: canEdit),
                  const SizedBox(height: 16),
                  _buildField('NIF / IDENTIFICAÇÃO FISCAL', _nifController, Icons.badge_outlined, enabled: canEdit),
                ]),
                const SizedBox(height: 32),
                _buildSection('CONTACTOS & LOCALIZAÇÃO', [
                  _buildField('MORADA COMPLETA', _moradaController, Icons.location_on_outlined, capitalize: true, enabled: canEdit),
                  const SizedBox(height: 16),
                  isNarrow
                      ? Column(
                          children: [
                            _buildField('TELEFONE', _telefoneController, Icons.phone_outlined, enabled: canEdit),
                            const SizedBox(height: 16),
                            _buildField('E-MAIL', _emailController, Icons.email_outlined, enabled: canEdit),
                          ],
                        )
                      : Row(
                    children: [
                      Expanded(child: _buildField('TELEFONE', _telefoneController, Icons.phone_outlined, enabled: canEdit)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildField('E-MAIL', _emailController, Icons.email_outlined, enabled: canEdit)),
                    ],
                  ),
                ]),
                if (canEdit) ...[
                  const SizedBox(height: 48),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('GUARDAR ALTERAÇÕES'),
                    style: FilledButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                ],
                const SizedBox(height: 64),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.black)),
      error: (e, _) => Center(child: Text('Erro: $e')),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black, letterSpacing: 1.5)),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool capitalize = false, bool enabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      style: TextStyle(color: enabled ? Colors.black : Colors.black54, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon, size: 20, color: Colors.black),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
      ),
      validator: (v) => v!.isEmpty ? 'OBRIGATÓRIO' : null,
    );
  }
}
