import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/mensalidade.dart';
import '../../../domain/entities/pagamento.dart';
import '../../../domain/entities/evidencia_pagamento.dart';
import '../../../domain/entities/sync_entity.dart';
import '../finance_controller.dart';
import '../../../state/session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;

class PaymentConfirmationDialog extends ConsumerStatefulWidget {
  final Mensalidade mensalidade;
  const PaymentConfirmationDialog({super.key, required this.mensalidade});

  @override
  ConsumerState<PaymentConfirmationDialog> createState() => _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState extends ConsumerState<PaymentConfirmationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valorController;
  late TextEditingController _obsController;
  String _formaPagamento = 'Numerário';
  XFile? _evidencia;
  bool _isSaving = false;
  bool _dividaAnulada = false;

  @override
  void initState() {
    super.initState();
    _valorController = TextEditingController(text: widget.mensalidade.valor.toString());
    _obsController = TextEditingController();
  }

  @override
  void dispose() {
    _valorController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) setState(() => _evidencia = image);
  }

  Future<void> _confirmar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_evidencia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A EVIDÊNCIA É OBRIGATÓRIA PARA CONFIRMAR O PAGAMENTO.'),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final session = ref.read(sessionProvider);
    final repo = ref.read(financeRepositoryProvider);

    try {
      String? localPath;
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = 'EVI_${const Uuid().v4()}.jpg';
        localPath = '${dir.path}/$fileName';
        await File(_evidencia!.path).copy(localPath);
      } else {
        localPath = _evidencia!.path; // No browser usamos o path do blob
      }

      final evidencia = EvidenciaPagamento()
        ..id = const Uuid().v4()
        ..nomeArquivo = 'EVI_${const Uuid().v4()}.jpg'
        ..caminhoLocal = localPath
        ..tipoArquivo = 'imagem'
        ..tamanhoBytes = kIsWeb ? 0 : await File(localPath).length()
        ..mimeType = 'image/jpeg'
        ..createdAt = DateTime.now()
        ..syncStatus = SyncStatus.pendingSync;

      if (_dividaAnulada) {
        final mensalidade = widget.mensalidade;
        mensalidade.estado = 'anulada';
        mensalidade.observacao = 'DÍVIDA ANULADA. MOTIVO: ${_obsController.text}';
        mensalidade.updatedAt = DateTime.now();
        mensalidade.syncStatus = SyncStatus.pendingSync;
        
        await repo.saveMensalidade(mensalidade);
      } else {
        final pagamento = Pagamento()
          ..id = const Uuid().v4()
          ..mensalidadeId = widget.mensalidade.id
          ..valorPago = double.parse(_valorController.text)
          ..dataPagamento = DateTime.now()
          ..formaPagamento = _formaPagamento
          ..observacao = _obsController.text
          ..numeroRecibo = 'REC-${const Uuid().v4().substring(0, 6).toUpperCase()}'
          ..confirmadoPor = session.firebaseUser?.uid ?? 'sistema'
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now()
          ..syncStatus = SyncStatus.pendingSync;

        await repo.confirmarPagamento(
          pagamento: pagamento,
          evidencia: evidencia,
          mensalidadeId: widget.mensalidade.id,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ERRO: $e'), backgroundColor: Colors.black));
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black, width: 2)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isCompact ? width * 0.96 : 500),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : AppTokens.paddingLG),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CONFIRMAR RECEBIMENTO', style: TextStyle(fontSize: isCompact ? 15 : 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const Divider(color: Colors.black, thickness: 2, height: 32),
                  
                  if (!_dividaAnulada) ...[
                    _buildField('VALOR RECEBIDO (KZ)', _valorController, Icons.payments_outlined, isNumber: true),
                    const SizedBox(height: 16),
                    _buildDropdown('FORMA DE PAGAMENTO', ['Numerário', 'TPA', 'Transferência', 'Depósito'], (val) => setState(() => _formaPagamento = val!), initial: _formaPagamento),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        'MODO DE ANULAÇÃO: O VALOR SERÁ ZERADO E A DÍVIDA MARCADA COMO ANULADA NO SISTEMA.',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  _buildField('OBSERVAÇÕES / JUSTIFICAÇÃO', _obsController, Icons.note_alt_outlined, maxLines: 2, capitalize: true),
                  
                  const SizedBox(height: 24),
                  CheckboxListTile(
                    title: const Text('DÍVIDA ANULADA (ISENÇÃO)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    subtitle: const Text('MARQUE PARA ANULAR ESTE PAGAMENTO MEDIANTE AUTORIZAÇÃO.', style: TextStyle(fontSize: 10)),
                    value: _dividaAnulada,
                    onChanged: (val) => setState(() => _dividaAnulada = val!),
                    activeColor: Colors.black,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 24),
                  Text(_dividaAnulada ? 'EVIDÊNCIA DE AUTORIZAÇÃO (OBRIGATÓRIO)' : 'COMPROVATIVO DE DEPÓSITO/TPA (OBRIGATÓRIO)', 
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  
                  if (_evidencia != null)
                    Stack(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1.5),
                            image: DecorationImage(
                              image: kIsWeb 
                                ? NetworkImage(_evidencia!.path) as ImageProvider
                                : FileImage(File(_evidencia!.path)), 
                              fit: BoxFit.cover
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8, top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 18), onPressed: () => setState(() => _evidencia = null)),
                          ),
                        ),
                      ],
                    )
                  else
                    isCompact
                        ? Column(
                            children: [
                              SizedBox(width: double.infinity, child: _buildImageAction('CÂMARA', Icons.camera_alt_outlined, () => _pickImage(ImageSource.camera))),
                              const SizedBox(height: 12),
                              SizedBox(width: double.infinity, child: _buildImageAction('GALERIA', Icons.image_outlined, () => _pickImage(ImageSource.gallery))),
                            ],
                          )
                        : Row(
                            children: [
                              _buildImageAction('CÂMARA', Icons.camera_alt_outlined, () => _pickImage(ImageSource.camera)),
                              const SizedBox(width: 12),
                              _buildImageAction('GALERIA', Icons.image_outlined, () => _pickImage(ImageSource.gallery)),
                            ],
                          ),
                  
                  const SizedBox(height: 32),
                  isCompact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: _isSaving ? null : _confirmar,
                              style: FilledButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              child: _isSaving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text(_dividaAnulada ? 'ANULAR DÍVIDA' : 'CONFIRMAR PAGAMENTO', style: const TextStyle(fontWeight: FontWeight.w900)),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: _isSaving ? null : _confirmar,
                              style: FilledButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              child: _isSaving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text(_dividaAnulada ? 'ANULAR DÍVIDA' : 'CONFIRMAR PAGAMENTO', style: const TextStyle(fontWeight: FontWeight.w900)),
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

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, int maxLines = 1, bool capitalize = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
        prefixIcon: Icon(icon, size: 20, color: Colors.black),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
      ),
      validator: (v) => v!.isEmpty ? 'OBRIGATÓRIO' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {String? initial}) {
    return DropdownButtonFormField<String>(
      initialValue: initial,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.5)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImageAction(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 80,
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, color: Colors.black), Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900))],
          ),
        ),
      ),
    );
  }
}
