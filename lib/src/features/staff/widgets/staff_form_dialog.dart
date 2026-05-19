import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/funcionario.dart';
import '../staff_controller.dart';

class StaffFormDialog extends ConsumerStatefulWidget {
  final Funcionario? funcionario;

  const StaffFormDialog({super.key, this.funcionario});

  @override
  ConsumerState<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends ConsumerState<StaffFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numero;
  late final TextEditingController _nome;
  late final TextEditingController _cargo;
  late final TextEditingController _telefone;
  late final TextEditingController _email;
  late final TextEditingController _documento;
  late final TextEditingController _salario;
  late final TextEditingController _obs;
  late DateTime _dataAdmissao;
  late FuncionarioStatus _status;

  @override
  void initState() {
    super.initState();
    final f = widget.funcionario;
    _numero = TextEditingController(text: f?.numeroFuncionario ?? '');
    _nome = TextEditingController(text: f?.nomeCompleto ?? '');
    _cargo = TextEditingController(text: f?.cargo ?? 'Professor');
    _telefone = TextEditingController(text: f?.telefone ?? '');
    _email = TextEditingController(text: f?.email ?? '');
    _documento = TextEditingController(text: f?.documentoIdentidade ?? '');
    _salario = TextEditingController(text: f?.salarioBase.toStringAsFixed(0) ?? '0');
    _obs = TextEditingController(text: f?.observacoes ?? '');
    _dataAdmissao = f?.dataAdmissao ?? DateTime.now();
    _status = f?.status ?? FuncionarioStatus.ativo;
  }

  @override
  void dispose() {
    _numero.dispose();
    _nome.dispose();
    _cargo.dispose();
    _telefone.dispose();
    _email.dispose();
    _documento.dispose();
    _salario.dispose();
    _obs.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dataAdmissao,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _dataAdmissao = d);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(staffActionsProvider).save(
          existing: widget.funcionario,
          numero: _numero.text.trim(),
          nome: _nome.text.trim(),
          cargo: _cargo.text.trim(),
          telefone: _telefone.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          documento: _documento.text.trim().isEmpty ? null : _documento.text.trim(),
          dataAdmissao: _dataAdmissao,
          salarioBase: double.tryParse(_salario.text.replaceAll(',', '.')) ?? 0,
          status: _status,
          observacoes: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.funcionario != null;
    return AlertDialog(
      title: Text(isEdit ? 'Editar funcionário' : 'Novo funcionário'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _numero,
                  decoration: const InputDecoration(labelText: 'Nº funcionário'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nome,
                  decoration: const InputDecoration(labelText: 'Nome completo'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cargo,
                  decoration: const InputDecoration(labelText: 'Cargo'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _telefone,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _documento,
                  decoration: const InputDecoration(labelText: 'Documento de identidade'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _salario,
                  decoration: const InputDecoration(labelText: 'Salário base (KZ)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data de admissão'),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataAdmissao)),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: _pickDate,
                  ),
                ),
                DropdownButtonFormField<FuncionarioStatus>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: FuncionarioStatus.values
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _status = v ?? FuncionarioStatus.ativo),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _obs,
                  decoration: const InputDecoration(labelText: 'Observações'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: _submit, child: Text(isEdit ? 'Guardar' : 'Registar')),
      ],
    );
  }
}
