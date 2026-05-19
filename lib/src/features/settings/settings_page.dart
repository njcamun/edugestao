import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/configuracao.dart';
import '../../domain/entities/utilizador.dart';
import '../../domain/entities/sync_entity.dart';
import '../../state/session.dart';
import '../../state/theme_mode_controller.dart';
import 'settings_controller.dart';
import 'users_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../shared/widgets/edu_card.dart';
import '../../shared/widgets/edu_segmented_tabs.dart';

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
          const SnackBar(content: Text('Configurações guardadas com sucesso.')),
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
          if (isAdmin) ...[
            EduSegmentedTabs(
              controller: _tabController,
              scrollable: isNarrow,
              labels: const ['Instituição', 'Utilizadores'],
            ),
            SizedBox(height: isNarrow ? 14 : 20),
          ],
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
                EduCard(
                  child: _buildSection('Aparência', [
                    Consumer(
                      builder: (context, ref, _) {
                        final mode = ref.watch(themeModeProvider);
                        final isDark = mode == ThemeMode.dark;
                        return SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Tema escuro'),
                          subtitle: const Text('Alternar entre modo claro e escuro'),
                          value: isDark,
                          onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(
                                v ? ThemeMode.dark : ThemeMode.light,
                              ),
                        );
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                EduCard(
                  child: _buildSection('Identidade visual', [
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: canEdit ? _pickImage : null,
                        child: Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: _logotipoPath != null && _logotipoPath!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: kIsWeb
                                      ? Image.network(
                                          _logotipoPath!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.black),
                                        )
                                      : Image.file(
                                          File(_logotipoPath!),
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => const Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.black),
                                        ),
                                )
                              : const Icon(Icons.add_a_photo_outlined,
                                  color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: isNarrow ? (width - 180).clamp(120.0, 320.0) : 320,
                        child: Text(
                          'Logótipo oficial da instituição.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ]),
                ),
                const SizedBox(height: 16),
                EduCard(
                  child: _buildSection('Dados gerais', [
                  _buildField('Nome da instituição', _nomeController, Icons.school_outlined, capitalize: true, enabled: canEdit),
                  const SizedBox(height: 16),
                  _buildField('NIF / Identificação fiscal', _nifController, Icons.badge_outlined, enabled: canEdit),
                  ]),
                ),
                const SizedBox(height: 16),
                EduCard(
                  child: _buildSection('Contactos e localização', [
                  _buildField('Morada completa', _moradaController, Icons.location_on_outlined, capitalize: true, enabled: canEdit),
                  const SizedBox(height: 16),
                  isNarrow
                      ? Column(
                          children: [
                            _buildField('Telefone', _telefoneController, Icons.phone_outlined, enabled: canEdit),
                            const SizedBox(height: 16),
                            _buildField('E-mail', _emailController, Icons.email_outlined, enabled: canEdit),
                          ],
                        )
                      : Row(
                    children: [
                      Expanded(child: _buildField('Telefone', _telefoneController, Icons.phone_outlined, enabled: canEdit)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildField('E-mail', _emailController, Icons.email_outlined, enabled: canEdit)),
                    ],
                  ),
                  ]),
                ),
                if (canEdit) ...[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar alterações'),
                  ),
                ],
                const SizedBox(height: 64),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
    );
  }
}
