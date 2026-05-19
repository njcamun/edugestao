import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../../../domain/entities/matricula.dart';
import '../../../domain/entities/sync_entity.dart';
import '../../students/students_controller.dart';
import '../../classes/classes_controller.dart';
import '../enrollments_controller.dart';

class EnrollmentFormDialog extends ConsumerStatefulWidget {
  final Matricula? matricula;
  const EnrollmentFormDialog({super.key, this.matricula});

  @override
  ConsumerState<EnrollmentFormDialog> createState() => _EnrollmentFormDialogState();
}

class _EnrollmentFormDialogState extends ConsumerState<EnrollmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedAlunoId;
  String? _selectedTurmaId;
  String _turno = 'Manhã';
  late TextEditingController _anoLectivoController;
  late TextEditingController _precoController;
  int _diaVencimento = 10;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final m = widget.matricula;
    _selectedAlunoId = m?.alunoId;
    _selectedTurmaId = m?.turmaId;
    _turno = m?.turno ?? 'Manhã';
    _anoLectivoController = TextEditingController(text: m?.anoLectivo ?? '${DateTime.now().year}/${DateTime.now().year + 1}');
    _precoController = TextEditingController(text: m?.valorMensalidade.toString() ?? '0');
    _diaVencimento = m?.diaVencimento ?? 10;
  }

  @override
  void dispose() {
    _anoLectivoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsStreamProvider);
    final classesAsync = ref.watch(classesStreamProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 640;

    return Dialog(
      shape: EduFormStyles.dialogShape(),
      child: ConstrainedBox(
        constraints: EduFormStyles.dialogConstraints(context),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EduFormStyles.dialogHeader(
                    context,
                    widget.matricula == null ? 'Nova matrícula' : 'Editar matrícula',
                  ),
                  const SizedBox(height: AppTokens.paddingMD),

                  // Seleção de Aluno
                  studentsAsync.when(
                    data: (alunos) => _buildDropdown('ALUNO', alunos.map((a) => a.id).toList(), (val) => setState(() => _selectedAlunoId = val), 
                      initial: _selectedAlunoId,
                      customItems: alunos.map((a) => DropdownMenuItem(value: a.id, child: Text(a.nomeCompleto.toUpperCase()))).toList(),
                      disabled: widget.matricula != null),
                    loading: () => const LinearProgressIndicator(color: AppTokens.primary),
                    error: (_, __) => const Text('ERRO AO CARREGAR ALUNOS'),
                  ),
                  const SizedBox(height: 16),

                  // Seleção de Turma
                  classesAsync.when(
                    data: (turmas) => _buildDropdown('TURMA', turmas.map((t) => t.id).toList(), (val) => setState(() => _selectedTurmaId = val),
                      initial: _selectedTurmaId,
                      customItems: turmas.map((t) => DropdownMenuItem(value: t.id, child: Text(t.nomeTurma.toUpperCase()))).toList()),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const Text('ERRO AO CARREGAR TURMAS'),
                  ),
                  const SizedBox(height: 16),

                  isCompact
                      ? Column(
                          children: [
                            _buildField('MENSALIDADE (KZ)', _precoController, Icons.payments_outlined, isNumber: true),
                            const SizedBox(height: 12),
                            _buildDropdown('VENCIMENTO (DIA)', ['5', '10', '15', '20', '25'], (val) => setState(() => _diaVencimento = int.parse(val!)), initial: _diaVencimento.toString()),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildField('MENSALIDADE (KZ)', _precoController, Icons.payments_outlined, isNumber: true)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDropdown('VENCIMENTO (DIA)', ['5', '10', '15', '20', '25'], (val) => setState(() => _diaVencimento = int.parse(val!)), initial: _diaVencimento.toString())),
                          ],
                        ),
                  const SizedBox(height: 16),

                  isCompact
                      ? Column(
                          children: [
                            _buildDropdown('TURNO', ['MANHÃ', 'TARDE', 'NOITE'], (val) => setState(() => _turno = val!), initial: _turno.toUpperCase()),
                            const SizedBox(height: 12),
                            _buildField('ANO LECTIVO', _anoLectivoController, Icons.calendar_today_outlined),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildDropdown('TURNO', ['MANHÃ', 'TARDE', 'NOITE'], (val) => setState(() => _turno = val!), initial: _turno.toUpperCase())),
                            const SizedBox(width: 16),
                            Expanded(child: _buildField('ANO LECTIVO', _anoLectivoController, Icons.calendar_today_outlined)),
                          ],
                        ),
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _isSubmitting ? null : _submit,
                    confirmLabel: widget.matricula == null ? 'Confirmar' : 'Guardar',
                    isLoading: _isSubmitting,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTokens.warning),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
        content: Text(message),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Compreendi')),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, bool capitalize = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      decoration: EduFormStyles.inputDecoration(label, icon: icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {String? initial, List<DropdownMenuItem<String>>? customItems, bool disabled = false}) {
    return DropdownButtonFormField<String>(
      initialValue: initial,
      decoration: EduFormStyles.inputDecoration(label),
      items: customItems ?? items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: disabled ? null : onChanged,
      validator: (v) => v == null ? 'Campo obrigatório' : null,
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedTurmaId != null) {
      setState(() => _isSubmitting = true);
      
      try {
        final repository = ref.read(enrollmentRepositoryProvider);
        final classes = ref.read(classesStreamProvider).value ?? [];
        final enrollments = ref.read(enrollmentsStreamProvider).value ?? [];
        
        final selectedTurma = classes.firstWhere((t) => t.id == _selectedTurmaId);
        
        if (widget.matricula == null || widget.matricula!.turmaId != _selectedTurmaId) {
          final jaMatriculado = enrollments.any((e) => 
            e.alunoId == _selectedAlunoId && 
            e.turmaId == _selectedTurmaId && 
            e.estado == 'ativa' &&
            e.id != widget.matricula?.id
          );

          if (jaMatriculado) {
            setState(() => _isSubmitting = false);
            if (mounted) _showErrorAlert('Matrícula duplicada', 'Este aluno já possui uma matrícula activa nesta turma.');
            return;
          }

          final totalInscritos = enrollments.where((e) => e.turmaId == _selectedTurmaId && e.estado == 'ativa').length;
          if (totalInscritos >= selectedTurma.limiteAlunos) {
            setState(() => _isSubmitting = false);
            if (mounted) _showErrorAlert('Limite atingido', 'Esta turma atingiu o limite máximo de ${selectedTurma.limiteAlunos} vagas.');
            return;
          }
        }

        final matricula = widget.matricula ?? Matricula();
        final isNew = widget.matricula == null;
        final matriculaId = isNew ? const Uuid().v4() : widget.matricula!.id;

        matricula.id = matriculaId;
        matricula.alunoId = _selectedAlunoId!;
        matricula.turmaId = _selectedTurmaId!;
        matricula.turno = _turno;
        matricula.anoLectivo = _anoLectivoController.text;
        matricula.valorMensalidade = double.tryParse(_precoController.text) ?? 0.0;
        matricula.diaVencimento = _diaVencimento;
        matricula.dataMatricula = widget.matricula?.dataMatricula ?? DateTime.now();
        matricula.estado = widget.matricula?.estado ?? 'ativa';
        matricula.numeroMatricula = widget.matricula?.numeroMatricula ?? 'MAT-${DateTime.now().year}-${const Uuid().v4().substring(0, 4).toUpperCase()}';
        
        matricula.createdAt = widget.matricula?.createdAt ?? DateTime.now();
        matricula.updatedAt = DateTime.now();
        matricula.syncStatus = SyncStatus.pendingSync;

        await repository.saveMatricula(matricula);

        if (mounted) Navigator.pop(context);
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }
}
