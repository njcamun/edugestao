import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_tokens.dart';
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
          const SnackBar(content: Text('DEVE SELECIONAR UM ANO LECTIVO ATIVO'), backgroundColor: Colors.red),
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLG), side: const BorderSide(color: Colors.black, width: 2)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isCompact ? width * 0.96 : 500),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : AppTokens.paddingLG),
          child: _isLoadingAnos 
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.turma == null ? 'CRIAR NOVA TURMA' : 'EDITAR TURMA',
                              style: TextStyle(fontSize: isCompact ? 15 : 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.black)),
                        ],
                      ),
                      const Divider(color: Colors.black, thickness: 2, height: 32),
                      
                      if (_anosLectivos.isEmpty) 
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: Colors.red.shade50, border: Border.all(color: Colors.red), borderRadius: BorderRadius.circular(4)),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.red),
                              SizedBox(width: 8),
                              Expanded(child: Text('AVISO: NÃO EXISTE NENHUM ANO LECTIVO CADASTRADO NO SISTEMA.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11))),
                            ],
                          ),
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
                      
                      const SizedBox(height: 32),
                      isCompact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 8),
                                FilledButton(
                                  onPressed: _anosLectivos.isEmpty ? null : _save,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('GUARDAR TURMA'),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 12),
                                FilledButton(
                                  onPressed: _anosLectivos.isEmpty ? null : _save,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('GUARDAR TURMA'),
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

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool capitalize = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label.toUpperCase(),
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon, size: 20, color: Colors.black),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (v) => v!.isEmpty ? 'OBRIGATÓRIO' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {String? value}) {
    return DropdownButtonFormField<String>(
      initialValue: (value != null && items.contains(value)) ? value : (items.isNotEmpty ? items.first : null),
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label.toUpperCase(),
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
      onChanged: onChanged,
    );
  }
}
