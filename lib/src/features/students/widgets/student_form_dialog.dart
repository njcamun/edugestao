import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/sync_entity.dart';
import '../students_controller.dart';

class StudentFormDialog extends ConsumerStatefulWidget {
  final Aluno? aluno;
  const StudentFormDialog({super.key, this.aluno});

  @override
  ConsumerState<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends ConsumerState<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers - Dados Pessoais
  late TextEditingController _nomeController;
  late TextEditingController _dataNascimentoController;
  late DateTime? _dataNascimento;
  String _sexo = 'M';
  late TextEditingController _moradaController;
  
  // Controllers - Académico
  late TextEditingController _escolaController;
  String _anoEscolaridade = '1ª Classe';
  
  final List<String> _anosEscolaridade = [
    '1ª Classe', '2ª Classe', '3ª Classe', '4ª Classe', 
    '5ª Classe', '6ª Classe', '7ª Classe', '8ª Classe'
  ];
  
  // Controllers - Saúde
  bool _possuiCondicaoMedica = false;
  late TextEditingController _condicaoMedicaDescController;
  
  // Controllers - Encarregado
  late TextEditingController _encarregadoController;
  late TextEditingController _telefonePrincipalController;
  late TextEditingController _telefoneAlternativoController;
  late TextEditingController _emailController;
  
  // Pagamento de Inscrição
  late TextEditingController _valorPagamentoController;
  bool _isentoPagamento = false;
  File? _comprovativoFile;
  
  // Outros
  late TextEditingController _observacoesController;
  late TextEditingController _dataInscricaoController;
  late DateTime _dataInscricao;

  @override
  void initState() {
    super.initState();
    final a = widget.aluno;
    
    _nomeController = TextEditingController(text: a?.nomeCompleto);
    _dataNascimento = a?.dataNascimento;
    _dataNascimentoController = TextEditingController(
      text: a != null ? DateFormat('dd/MM/yyyy').format(a.dataNascimento) : '',
    );
    _sexo = a?.sexo ?? 'M';
    _moradaController = TextEditingController(text: a?.morada);
    _escolaController = TextEditingController(text: a?.escolaQueFrequenta);
    
    _anoEscolaridade = (a != null && _anosEscolaridade.contains(a.anoEscolaridade)) 
        ? a.anoEscolaridade 
        : _anosEscolaridade.first;
    
    _possuiCondicaoMedica = a?.possuiCondicaoMedica ?? false;
    _condicaoMedicaDescController = TextEditingController(text: a?.descricaoCondicaoMedica);
    _encarregadoController = TextEditingController(text: a?.nomeEncarregado);
    _telefonePrincipalController = TextEditingController(text: a?.telefonePrincipal);
    _telefoneAlternativoController = TextEditingController(text: a?.telefoneAlternativo);
    _emailController = TextEditingController(text: a?.email);
    _observacoesController = TextEditingController(text: a?.observacoes);
    
    _dataInscricao = a?.dataInscricao ?? DateTime.now();
    _dataInscricaoController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_dataInscricao),
    );

    _valorPagamentoController = TextEditingController(text: a?.valorPagamentoInscricao.toString() ?? '5000');
    _isentoPagamento = a?.isentoPagamento ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _moradaController.dispose();
    _escolaController.dispose();
    _condicaoMedicaDescController.dispose();
    _encarregadoController.dispose();
    _telefonePrincipalController.dispose();
    _telefoneAlternativoController.dispose();
    _emailController.dispose();
    _observacoesController.dispose();
    _dataInscricaoController.dispose();
    _valorPagamentoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _comprovativoFile = File(pickedFile.path));
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime.now().subtract(const Duration(days: 365 * 6)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dataNascimento = picked;
        _dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectInscricaoDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataInscricao,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dataInscricao = picked;
        _dataInscricaoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (_dataNascimento == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione a data de nascimento.'), backgroundColor: AppTokens.warning),
        );
        return;
      }

      final repository = ref.read(studentRepositoryProvider);
      final aluno = widget.aluno ?? Aluno();
      
      aluno.id = widget.aluno?.id ?? const Uuid().v4();
      aluno.nomeCompleto = _nomeController.text;
      aluno.dataNascimento = _dataNascimento!;
      aluno.sexo = _sexo;
      aluno.morada = _moradaController.text;
      aluno.escolaQueFrequenta = _escolaController.text;
      aluno.anoEscolaridade = _anoEscolaridade;
      aluno.possuiCondicaoMedica = _possuiCondicaoMedica;
      aluno.descricaoCondicaoMedica = _possuiCondicaoMedica ? _condicaoMedicaDescController.text : null;
      aluno.nomeEncarregado = _encarregadoController.text;
      aluno.telefonePrincipal = _telefonePrincipalController.text;
      aluno.telefoneAlternativo = _telefoneAlternativoController.text;
      aluno.email = _emailController.text;
      aluno.observacoes = _observacoesController.text;
      aluno.numeroAluno = widget.aluno?.numeroAluno ?? 'ALU-${DateTime.now().year}${DateTime.now().millisecond}';
      aluno.status = widget.aluno?.status ?? AlunoStatus.ativo;
      aluno.dataInscricao = _dataInscricao;
      
      // Pagamento
      aluno.isentoPagamento = _isentoPagamento;
      aluno.valorPagamentoInscricao = _isentoPagamento ? 0 : (double.tryParse(_valorPagamentoController.text) ?? 0);
      aluno.comprovativoInscricaoLocal = _comprovativoFile?.path;

      aluno.createdAt = widget.aluno?.createdAt ?? DateTime.now();
      aluno.updatedAt = DateTime.now();
      aluno.syncStatus = SyncStatus.pendingSync;

      await repository.saveAluno(aluno);
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
        constraints: BoxConstraints(
          maxWidth: isCompact ? width * 0.96 : 550,
          maxHeight: isCompact ? 760 : 800,
        ),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EduFormStyles.dialogHeader(
                  context,
                  widget.aluno == null ? 'Ficha de inscrição' : 'Editar ficha',
                ),
                const SizedBox(height: AppTokens.paddingMD),
                
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EduFormStyles.formSectionTitle('1. Identificação do aluno'),
                        const SizedBox(height: 16),
                        _buildField('Nome Completo', _nomeController, Icons.person_outline, capitalize: true),
                        const SizedBox(height: 16),
                        isCompact
                            ? Column(
                                children: [
                                  _buildDateField('Data de nascimento', _dataNascimentoController, _selectDate),
                                  const SizedBox(height: 12),
                                  _buildDropdown('Sexo', ['M', 'F'], (val) => setState(() => _sexo = val!)),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _buildDateField('Data de nascimento', _dataNascimentoController, _selectDate),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildDropdown('Sexo', ['M', 'F'], (val) => setState(() => _sexo = val!))),
                                ],
                              ),
                        const SizedBox(height: 16),
                        _buildField('Morada Completa', _moradaController, Icons.home_outlined, capitalize: true),
                        
                        const SizedBox(height: 32),
                        EduFormStyles.formSectionTitle('2. Percurso académico'),
                        const SizedBox(height: 16),
                        _buildField('Escola de Proveniência', _escolaController, Icons.school_outlined, capitalize: true),
                        const SizedBox(height: 16),
                        _buildDropdown('Ano de Escolaridade', _anosEscolaridade, (val) => setState(() => _anoEscolaridade = val!)),

                        const SizedBox(height: 32),
                        EduFormStyles.formSectionTitle('3. Saúde'),
                        SwitchListTile(
                          title: const Text('Possui condição médica?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          value: _possuiCondicaoMedica,
                          onChanged: (v) => setState(() => _possuiCondicaoMedica = v),
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: AppTokens.primary,
                        ),
                        if (_possuiCondicaoMedica) ...[
                          const SizedBox(height: 8),
                          _buildField('Descrição da Condição', _condicaoMedicaDescController, Icons.medical_services_outlined, maxLines: 2, capitalize: true),
                        ],

                        const SizedBox(height: 32),
                        EduFormStyles.formSectionTitle('4. Encarregado de educação'),
                        const SizedBox(height: 16),
                        _buildField('Nome do Encarregado', _encarregadoController, Icons.family_restroom_outlined, capitalize: true),
                        const SizedBox(height: 16),
                        isCompact
                            ? Column(
                                children: [
                                  _buildField('Telefone Principal', _telefonePrincipalController, Icons.phone_android_outlined),
                                  const SizedBox(height: 12),
                                  _buildField('Telefone Alternativo', _telefoneAlternativoController, Icons.phone_iphone_outlined, required: false),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(child: _buildField('Telefone Principal', _telefonePrincipalController, Icons.phone_android_outlined)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildField('Telefone Alternativo', _telefoneAlternativoController, Icons.phone_iphone_outlined, required: false)),
                                ],
                              ),
                        const SizedBox(height: 16),
                        _buildField('E-mail', _emailController, Icons.email_outlined, required: false),

                        const SizedBox(height: 32),
                        EduFormStyles.formSectionTitle('5. Pagamento de inscrição'),
                        const SizedBox(height: 16),
                        CheckboxListTile(
                          title: const Text('Aluno isento de pagamento?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          value: _isentoPagamento,
                          onChanged: (v) => setState(() => _isentoPagamento = v!),
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppTokens.primary,
                        ),
                        if (!_isentoPagamento) ...[
                          _buildField('Valor Pago (Kz)', _valorPagamentoController, Icons.payments_outlined, isNumber: true),
                          const SizedBox(height: 16),
                          isCompact
                              ? Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () => _pickImage(ImageSource.camera),
                                        icon: const Icon(Icons.camera_alt_outlined),
                                        label: const Text('Câmara'),
                                        style: OutlinedButton.styleFrom(foregroundColor: AppTokens.primary),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () => _pickImage(ImageSource.gallery),
                                        icon: const Icon(Icons.file_upload_outlined),
                                        label: const Text('Galeria'),
                                        style: OutlinedButton.styleFrom(foregroundColor: AppTokens.primary),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _pickImage(ImageSource.camera),
                                        icon: const Icon(Icons.camera_alt_outlined),
                                        label: const Text('Câmara'),
                                        style: OutlinedButton.styleFrom(foregroundColor: AppTokens.primary),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _pickImage(ImageSource.gallery),
                                        icon: const Icon(Icons.file_upload_outlined),
                                        label: const Text('Galeria'),
                                        style: OutlinedButton.styleFrom(foregroundColor: AppTokens.primary),
                                      ),
                                    ),
                                  ],
                                ),
                          if (_comprovativoFile != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Comprovativo: ${_comprovativoFile!.path.split(Platform.pathSeparator).last}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTokens.success),
                              ),
                            ),
                        ],

                        const SizedBox(height: 32),
                        EduFormStyles.formSectionTitle('6. Informações adicionais'),
                        const SizedBox(height: 16),
                        _buildDateField('Data de inscrição', _dataInscricaoController, _selectInscricaoDate),
                        const SizedBox(height: 16),
                        _buildField('Observações Internas', _observacoesController, Icons.note_alt_outlined, maxLines: 3, required: false, capitalize: true),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: AppTokens.paddingMD),
                EduFormStyles.dialogActions(
                  onCancel: () => Navigator.pop(context),
                  onConfirm: _save,
                  confirmLabel: widget.aluno == null ? 'Confirmar inscrição' : 'Guardar alterações',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, VoidCallback onTap) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: EduFormStyles.inputDecoration(label, icon: Icons.calendar_today_outlined),
      validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool required = true, int maxLines = 1, bool capitalize = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      decoration: EduFormStyles.inputDecoration(label, icon: icon).copyWith(alignLabelWithHint: true),
      validator: required ? (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    String value = items.contains(_sexo) && label.toLowerCase().contains('sexo')
        ? _sexo
        : (label.toLowerCase().contains('ano') ? _anoEscolaridade : items.first);
    if (!items.contains(value)) value = items.first;

    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: EduFormStyles.inputDecoration(label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
