import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/ativo_inventario.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../inventory_controller.dart';

class AssetFormDialog extends ConsumerStatefulWidget {
  final AtivoInventario? ativo;

  const AssetFormDialog({super.key, this.ativo});

  @override
  ConsumerState<AssetFormDialog> createState() => _AssetFormDialogState();
}

class _AssetFormDialogState extends ConsumerState<AssetFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigo;
  late final TextEditingController _nome;
  late String _categoria;
  late final TextEditingController _local;
  late final TextEditingController _valor;
  late final TextEditingController _obs;
  late DateTime _dataAquisicao;
  late AtivoEstado _estado;
  bool _isSaving = false;

  static const _categorias = [
    'Mobiliário',
    'Informática',
    'Electrónica',
    'Desporto',
    'Laboratório',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.ativo;
    _codigo = TextEditingController(text: a?.codigo ?? '');
    _nome = TextEditingController(text: a?.nome ?? '');
    _categoria = a?.categoria ?? _categorias.first;
    _local = TextEditingController(text: a?.localizacao ?? '');
    _valor = TextEditingController(text: a?.valorAquisicao.toStringAsFixed(0) ?? '0');
    _obs = TextEditingController(text: a?.observacoes ?? '');
    _dataAquisicao = a?.dataAquisicao ?? DateTime.now();
    _estado = a?.estado ?? AtivoEstado.bom;
  }

  @override
  void dispose() {
    _codigo.dispose();
    _nome.dispose();
    _local.dispose();
    _valor.dispose();
    _obs.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dataAquisicao,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _dataAquisicao = d);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(inventoryActionsProvider).saveAtivo(
            existing: widget.ativo,
            codigo: _codigo.text.trim(),
            nome: _nome.text.trim(),
            categoria: _categoria,
            localizacao: _local.text.trim(),
            estado: _estado,
            valorAquisicao: double.tryParse(_valor.text.replaceAll(',', '.')) ?? 0,
            dataAquisicao: _dataAquisicao,
            observacoes: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: EduFormStyles.dialogShape(),
      child: ConstrainedBox(
        constraints: EduFormStyles.dialogConstraints(context, maxWidth: 480),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EduFormStyles.dialogHeader(
                    context,
                    widget.ativo == null ? 'Novo activo' : 'Editar activo',
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _codigo,
                    decoration: EduFormStyles.inputDecoration('Código', icon: Icons.tag_outlined),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _nome,
                    decoration: EduFormStyles.inputDecoration('Nome do activo', icon: Icons.inventory_2_outlined),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  DropdownButtonFormField<String>(
                    value: _categorias.contains(_categoria) ? _categoria : _categorias.last,
                    decoration: EduFormStyles.inputDecoration('Categoria'),
                    items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _categoria = v ?? _categorias.first),
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _local,
                    decoration: EduFormStyles.inputDecoration('Localização', icon: Icons.place_outlined),
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _valor,
                    decoration: EduFormStyles.inputDecoration('Valor de aquisição (KZ)', icon: Icons.payments_outlined),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Data de aquisição'),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataAquisicao)),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined, color: AppTokens.primary),
                      onPressed: _pickDate,
                    ),
                  ),
                  DropdownButtonFormField<AtivoEstado>(
                    value: _estado,
                    decoration: EduFormStyles.inputDecoration('Estado'),
                    items: AtivoEstado.values
                        .map((e) => DropdownMenuItem(value: e, child: Text(_estadoLabel(e))))
                        .toList(),
                    onChanged: (v) => setState(() => _estado = v ?? AtivoEstado.bom),
                  ),
                  const SizedBox(height: AppTokens.paddingMD),
                  TextFormField(
                    controller: _obs,
                    decoration: EduFormStyles.inputDecoration('Observações', icon: Icons.notes_rounded),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _isSaving ? null : _submit,
                    confirmLabel: 'Guardar',
                    isLoading: _isSaving,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _estadoLabel(AtivoEstado e) => switch (e) {
        AtivoEstado.bom => 'Bom',
        AtivoEstado.regular => 'Regular',
        AtivoEstado.avariado => 'Avariado',
        AtivoEstado.emManutencao => 'Em manutenção',
        AtivoEstado.abatido => 'Abatido',
      };
}
