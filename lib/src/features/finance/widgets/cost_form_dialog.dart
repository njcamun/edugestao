import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/custo.dart';
import '../../../domain/entities/utilizador.dart';
import '../../../domain/entities/sync_entity.dart';
import '../costs_controller.dart';
import '../../../state/session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CostFormDialog extends ConsumerStatefulWidget {
  final CustoMensal? custo;
  const CostFormDialog({super.key, this.custo});

  @override
  ConsumerState<CostFormDialog> createState() => _CostFormDialogState();
}

class _CostFormDialogState extends ConsumerState<CostFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  String _tipo = 'FIXO';
  XFile? _evidencia;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.custo?.descricao ?? '');
    
    String valorTexto = '';
    if (widget.custo != null) {
      final v = widget.custo!.valor;
      if (v != 0) valorTexto = v.toString();
    }
    _valorController = TextEditingController(text: valorTexto);
    _tipo = widget.custo?.tipo ?? 'FIXO';
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) setState(() => _evidencia = image);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final isPaid = widget.custo?.estado == 'PAGO';
    final isPaying = widget.custo != null && !isPaid;

    if (isPaying && _evidencia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A EVIDÊNCIA É OBRIGATÓRIA PARA CONFIRMAR O PAGAMENTO.'), backgroundColor: Colors.black),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repository = ref.read(costsRepositoryProvider);
    final session = ref.read(sessionProvider);
    final now = DateTime.now();
    
    try {
      final item = widget.custo ?? CustoMensal();
      
      item.id = widget.custo?.id ?? const Uuid().v4();
      item.descricao = _descricaoController.text;
      item.valor = double.tryParse(_valorController.text) ?? 0.0;
      item.categoria = widget.custo?.categoria ?? 'EXTRA';
      item.tipo = _tipo;
      
      // Se for novo item, definimos mês/ano referência
      if (widget.custo == null) {
        item.mesReferencia = now.month;
        item.anoReferencia = now.year;
        item.data = now;
        item.estado = 'PENDENTE';
      }

      if (isPaying) {
        item.estado = 'PAGO';
      }
      
      item.responsavelId = session.firebaseUser?.uid ?? 'SISTEMA';
      
      if (_evidencia != null) {
        String? localPath;
        if (!kIsWeb) {
          final dir = await getApplicationDocumentsDirectory();
          final fileName = 'COST_EVI_${const Uuid().v4()}.jpg';
          localPath = '${dir.path}/$fileName';
          await File(_evidencia!.path).copy(localPath);
        } else {
          localPath = _evidencia!.path;
        }
        item.comprovativoLocal = localPath;
      }

      item.updatedAt = now;
      item.syncStatus = SyncStatus.pendingSync;

      await repository.saveCusto(item);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ERRO: $e'), backgroundColor: Colors.black));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final isAdmin = session.perfil?.perfil == Perfil.admin;
    final isPaid = widget.custo?.estado == 'PAGO';
    final isPaying = widget.custo != null && !isPaid;
    final isNew = widget.custo == null;
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 640;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black, width: 2)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isCompact ? width * 0.96 : (isPaid && !isAdmin ? 500 : 400)),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : AppTokens.paddingLG),
          child: (isPaid && !isAdmin) ? _buildReadOnlyView() : _buildForm(isPaying, isNew, isAdmin),
        ),
      ),
    );
  }

  Widget _buildReadOnlyView() {
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final c = widget.custo!;
    final List<String> meses = ['JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO', 'JULHO', 'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'];
    final mesNome = c.mesReferencia > 0 && c.mesReferencia <= 12 ? meses[c.mesReferencia - 1] : 'N/A';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('DETALHES DO CUSTO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ],
        ),
        const Divider(color: Colors.black, thickness: 2, height: 24),
        _infoRow('DESCRIÇÃO', c.descricao.toUpperCase()),
        const SizedBox(height: 12),
        MediaQuery.sizeOf(context).width < 640
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('VALOR PAGO', currencyFmt.format(c.valor)),
                  const SizedBox(height: 8),
                  _infoRow('TIPO', c.tipo),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _infoRow('VALOR PAGO', currencyFmt.format(c.valor))),
                  Expanded(child: _infoRow('TIPO', c.tipo)),
                ],
              ),
        const SizedBox(height: 12),
        _infoRow('REFERÊNCIA', '$mesNome ${c.anoReferencia}'),
        const SizedBox(height: 24),
        if (c.comprovativoLocal != null && (kIsWeb || File(c.comprovativoLocal!).existsSync()))
          Container(
            height: 180, width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), 
              borderRadius: BorderRadius.circular(8), 
              image: DecorationImage(
                image: kIsWeb ? NetworkImage(c.comprovativoLocal!) as ImageProvider : FileImage(File(c.comprovativoLocal!)), 
                fit: BoxFit.cover
              )
            ),
          ),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black)), child: const Text('FECHAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)))),
      ],
    );
  }

  Widget _buildForm(bool isPaying, bool isNew, bool isAdmin) {
    final isCorrection = !isNew && !isPaying;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPaying 
              ? 'LIQUIDAR CUSTO' 
              : (isCorrection ? 'CORRIGIR DADOS' : 'ADICIONAR CUSTO'), 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1)
          ),
          const Divider(color: Colors.black, thickness: 2, height: 24),
          _buildField('DESCRIÇÃO DO CUSTO', _descricaoController, Icons.description_outlined, capitalize: true, enabled: isNew || isAdmin),
          if (isPaying || (isCorrection && isAdmin) || isNew) ...[
            const SizedBox(height: 16),
            _buildField('VALOR (KZ)', _valorController, Icons.payments_outlined, isNumber: true),
            const SizedBox(height: 20),
            if (isPaying) ...[
              const Text('EVIDÊNCIA (OBRIGATÓRIO)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
              const SizedBox(height: 8),
            ] else if (isCorrection) ...[
              const Text('ALTERAR EVIDÊNCIA (OPCIONAL)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
              const SizedBox(height: 8),
            ],
            
            if (_evidencia != null)
              Stack(
                children: [
                  Container(
                    height: 100, width: double.infinity, 
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), 
                      borderRadius: BorderRadius.circular(8), 
                      image: DecorationImage(
                        image: kIsWeb ? NetworkImage(_evidencia!.path) as ImageProvider : FileImage(File(_evidencia!.path)), 
                        fit: BoxFit.cover
                      )
                    )
                  ),
                  Positioned(right: 4, top: 4, child: CircleAvatar(backgroundColor: Colors.black, radius: 12, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 12), onPressed: () => setState(() => _evidencia = null))))
                ],
              )
            else if (isCorrection && widget.custo?.comprovativoLocal != null)
              Stack(
                children: [
                  Container(
                    height: 100, width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: kIsWeb 
                          ? NetworkImage(widget.custo!.comprovativoLocal!) as ImageProvider 
                          : FileImage(File(widget.custo!.comprovativoLocal!)),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  Positioned(
                    bottom: 4, right: 4,
                    child: Row(
                      children: [
                        _buildImageActionSmall(Icons.camera_alt_outlined, () => _pickImage(ImageSource.camera)),
                        const SizedBox(width: 4),
                        _buildImageActionSmall(Icons.image_outlined, () => _pickImage(ImageSource.gallery)),
                      ],
                    ),
                  )
                ],
              )
            else if (isPaying || (isCorrection && isAdmin))
              MediaQuery.sizeOf(context).width < 640
                  ? Column(children: [
                      SizedBox(
                        width: double.infinity,
                        child: _buildImageAction(
                            'CÂMARA',
                            Icons.camera_alt_outlined,
                            () => _pickImage(ImageSource.camera)),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: _buildImageAction(
                            'GALERIA',
                            Icons.image_outlined,
                            () => _pickImage(ImageSource.gallery)),
                      ),
                    ])
                  : Row(children: [
                      Expanded(
                        child: _buildImageAction(
                            'CÂMARA',
                            Icons.camera_alt_outlined,
                            () => _pickImage(ImageSource.camera)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildImageAction(
                            'GALERIA',
                            Icons.image_outlined,
                            () => _pickImage(ImageSource.gallery)),
                      ),
                    ]),
          ],
          if (isNew || (isCorrection && isAdmin)) ...[
            const SizedBox(height: 16),
            _buildDropdown('TIPO DE CUSTO', ['FIXO', 'VARIAVEL'], (val) => setState(() => _tipo = val!), initial: _tipo),
          ],
          if (isCorrection && isAdmin) ...[
            const SizedBox(height: 16),
            _buildDropdown('ESTADO', ['PENDENTE', 'PAGO'], (val) => setState(() => widget.custo?.estado = val!), initial: widget.custo?.estado),
          ],
          const SizedBox(height: 32),
          MediaQuery.sizeOf(context).width < 640
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _isSaving ? null : _save,
                      style: FilledButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(isPaying ? 'CONFIRMAR' : (isCorrection ? 'CORRIGIR' : 'ADICIONAR'), style: const TextStyle(fontWeight: FontWeight.w900)),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCELAR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isSaving ? null : _save,
                      style: FilledButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(isPaying ? 'CONFIRMAR' : (isCorrection ? 'CORRIGIR' : 'ADICIONAR'), style: const TextStyle(fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildImageActionSmall(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black54)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
    ]);
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool capitalize = false, bool enabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      style: TextStyle(color: enabled ? Colors.black : Colors.black54, fontWeight: FontWeight.w600, fontSize: 13),
      decoration: InputDecoration(
        labelText: label.toUpperCase(),
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon, size: 18, color: Colors.black),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
      ),
      validator: (v) => v!.isEmpty ? 'OBRIGATÓRIO' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {String? initial}) {
    return DropdownButtonFormField<String>(
      initialValue: initial ?? (items.contains(_tipo) ? _tipo : items.first),
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label.toUpperCase(),
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImageAction(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.black, size: 18),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w900))
                ])));
  }
}
