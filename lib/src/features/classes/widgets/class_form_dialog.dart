import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../../../core/providers/database_provider.dart';
import '../../../data/local/drift/mappers/ano_lectivo_mapper.dart';
import '../../../domain/entities/turma.dart';
import '../../../domain/entities/ano_lectivo.dart';
import '../../../domain/entities/sync_entity.dart';
import '../classes_controller.dart';

class ClassFormDialog extends ConsumerStatefulWidget {
  final Turma? turma;
  const ClassFormDialog({super.key, this.turma});

  @override
  ConsumerState<ClassFormDialog> createState() => _ClassFormDialogState();
}

class _ClassFormDialogState extends ConsumerState<ClassFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nomeController;
  late TextEditingController _limiteController;
  late TextEditingController _salaController;
  String _turno = 'Manhã';
  
  String? _selectedAnoLectivoId;
  List<AnoLectivo> _anosLectivos = [];
  bool _isLoadingAnos = true;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.turma?.nomeTurma);
    _limiteController = TextEditingController(text: widget.turma?.limiteAlunos.toString() ?? '15');
    _salaController = TextEditingController(text: widget.turma?.numeroSala);
    if (widget.turma != null) {
      _turno = widget.turma!.turno;
      _selectedAnoLectivoId = widget.turma!.anoLectivoId;
    }
    _loadAnosLectivos();
  }

  Future<void> _loadAnosLectivos() async {
    final db = ref.read(databaseProvider);
    final query = db.select(db.anosLectivos)..where((t) => t.isDeleted.equals(false));
    final rows = await query.get();
    final anos = rows.map((row) => row.toEntity()).toList();
    
    setState(() {
      _anosLectivos = anos;
      _isLoadingAnos = false;
      
      if (_selectedAnoLectivoId == null && anos.isNotEmpty) {
        final ativo = anos.firstWhere((a) => a.isActive, orElse: () => anos.first);
        _selectedAnoLectivoId = ativo.id;
      }
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _limiteController.dispose();
    _salaController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAnoLectivoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione um ano lectivo activo.'), backgroundColor: AppTokens.error),
        );
        return;
      }

      final repository = ref.read(classesRepositoryProvider);
      final novaTurma = widget.turma ?? Turma();
      
      novaTurma.id = widget.turma?.id ?? const Uuid().v4();
      novaTurma.nomeTurma = _nomeController.text;
      novaTurma.limiteAlunos = int.tryParse(_limiteController.text) ?? 15;
      novaTurma.turno = _turno;
      novaTurma.numeroSala = _salaController.text;
      novaTurma.anoLectivoId = _selectedAnoLectivoId!;
      novaTurma.ativa = true;
      
      novaTurma.createdAt = widget.turma?.createdAt ?? DateTime.now();
      novaTurma.updatedAt = DateTime.now();
      novaTurma.syncStatus = SyncStatus.pendingSync;

      await repository.saveTurma(novaTurma);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 640;

    return Dialog(
      shape: EduFormStyles.dialogShape(),
      child: ConstrainedBox(
        constraints: EduFormStyles.dialogConstraints(context),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: _isLoadingAnos 
            ? const Center(child: CircularProgressIndicator(color: AppTokens.primary))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EduFormStyles.dialogHeader(
                        context,
                        widget.turma == null ? 'Nova turma' : 'Editar turma',
                      ),
                      const SizedBox(height: AppTokens.paddingMD),
                      if (_anosLectivos.isEmpty)
                        EduFormStyles.warningBanner(
                          'Não existe nenhum ano lectivo cadastrado. Crie um ano lectivo antes de adicionar turmas.',
                        ),

                      _buildDropdown('Ano Lectivo', _anosLectivos.map((a) => a.ano).toList(), (val) {
                        final ano = _anosLectivos.firstWhere((a) => a.ano == val);
                        setState(() => _selectedAnoLectivoId = ano.id);
                      }, value: _anosLectivos.isNotEmpty ? _anosLectivos.firstWhere((a) => a.id == _selectedAnoLectivoId, orElse: () => _anosLectivos.first).ano : null),
                      
                      const SizedBox(height: 16),
                      _buildField('Nome da Turma', _nomeController, Icons.class_outlined, capitalize: true),
                      const SizedBox(height: 16),
                      
                      isCompact
                          ? Column(
                              children: [
                                _buildField('Sala', _salaController, Icons.door_front_door_outlined, capitalize: true),
                                const SizedBox(height: 12),
                                _buildField('Limite de Vagas', _limiteController, Icons.groups_outlined, isNumber: true),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _buildField('Sala', _salaController, Icons.door_front_door_outlined, capitalize: true)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildField('Limite de Vagas', _limiteController, Icons.groups_outlined, isNumber: true)),
                              ],
                            ),
                      const SizedBox(height: 16),
                      
                      _buildDropdown('Turno', ['Manhã', 'Tarde'], (val) => setState(() => _turno = val!), value: _turno),
                      
                      const SizedBox(height: AppTokens.paddingLG),
                      EduFormStyles.dialogActions(
                        onCancel: () => Navigator.pop(context),
                        onConfirm: _anosLectivos.isEmpty ? null : _save,
                        confirmLabel: 'Guardar turma',
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool capitalize = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      decoration: EduFormStyles.inputDecoration(label, icon: icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {String? value}) {
    return DropdownButtonFormField<String>(
      initialValue: (value != null && items.contains(value)) ? value : (items.isNotEmpty ? items.first : null),
      decoration: EduFormStyles.inputDecoration(label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
