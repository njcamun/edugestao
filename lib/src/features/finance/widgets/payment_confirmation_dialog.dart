import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/edu_form_styles.dart';
import '../../../domain/entities/mensalidade.dart';
import '../../../domain/entities/pagamento.dart';
import '../../../domain/entities/evidencia_pagamento.dart';
import '../../../domain/entities/sync_entity.dart';
import '../finance_controller.dart';
import '../../../state/session.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
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
  Uint8List? _webBytes;
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
    if (image != null) {
      setState(() {
        _evidencia = image;
        _webBytes = null; // image_picker já dá blob URL no .path no web
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        withData: kIsWeb,
      );

      if (result != null) {
        final file = result.files.first;
        setState(() {
          if (kIsWeb) {
            _webBytes = file.bytes;
            _evidencia = XFile.fromData(file.bytes!, name: file.name, path: file.name);
          } else {
            _evidencia = XFile(file.path!, name: file.name);
          }
        });
      }
    } catch (e) {
      debugPrint('Erro ao selecionar ficheiro: $e');
    }
  }

  Future<void> _confirmar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_evidencia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A evidência é obrigatória para confirmar o pagamento.'),
          backgroundColor: AppTokens.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final session = ref.read(sessionProvider);
    final repo = ref.read(financeRepositoryProvider);

    try {
      final extension = p.extension(_evidencia!.name).toLowerCase().isEmpty 
          ? '.jpg' 
          : p.extension(_evidencia!.name).toLowerCase();
      
      final mimeType = _getMimeType(extension);
      final tipoArquivo = extension == '.pdf' ? 'pdf' : 
                         (['.jpg', '.jpeg', '.png'].contains(extension) ? 'imagem' : 'documento');

      String? localPath;
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = 'EVI_${const Uuid().v4()}$extension';
        localPath = '${dir.path}/$fileName';
        await File(_evidencia!.path).copy(localPath);
      } else {
        localPath = _evidencia!.path; // No browser usamos o path do blob ou nome
      }

      final evidencia = EvidenciaPagamento()
        ..id = const Uuid().v4()
        ..nomeArquivo = 'EVI_${const Uuid().v4()}$extension'
        ..caminhoLocal = localPath
        ..tipoArquivo = tipoArquivo
        ..tamanhoBytes = await _evidencia!.length()
        ..mimeType = mimeType
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: AppTokens.error));
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
      shape: EduFormStyles.dialogShape(),
      child: ConstrainedBox(
        constraints: EduFormStyles.dialogConstraints(context, maxWidth: 500),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EduFormStyles.dialogHeader(context, 'Confirmar recebimento'),
                  const SizedBox(height: AppTokens.paddingMD),
                  
                  if (!_dividaAnulada) ...[
                    _buildField('Valor recebido (KZ)', _valorController, Icons.payments_outlined, isNumber: true),
                    const SizedBox(height: 16),
                    _buildDropdown('Forma de pagamento', ['Numerário', 'TPA', 'Transferência', 'Depósito'], (val) => setState(() => _formaPagamento = val!), initial: _formaPagamento),
                  ] else ...[
                    EduFormStyles.warningBanner(
                      'Modo de anulação: o valor será zerado e a dívida marcada como anulada no sistema.',
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  _buildField('Observações / justificação', _obsController, Icons.note_alt_outlined, maxLines: 2, capitalize: true),
                  
                  const SizedBox(height: 24),
                  CheckboxListTile(
                    title: const Text('Dívida anulada (isenção)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Marque para anular este pagamento mediante autorização.', style: TextStyle(fontSize: 12)),
                    value: _dividaAnulada,
                    onChanged: (val) => setState(() => _dividaAnulada = val!),
                    activeColor: AppTokens.primary,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 24),
                  EduFormStyles.sectionLabel(
                    _dividaAnulada ? 'Evidência de autorização (obrigatório)' : 'Comprovativo de depósito/TPA (obrigatório)',
                  ),
                  const SizedBox(height: 12),
                  
                  if (_evidencia != null)
                    Stack(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTokens.border),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: _buildPreview(),
                          ),
                        ),
                        Positioned(
                          right: 8, top: 8,
                          child: CircleAvatar(
                            backgroundColor: AppTokens.primaryDark,
                            child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 18), onPressed: () => setState(() {
                              _evidencia = null;
                              _webBytes = null;
                            })),
                          ),
                        ),
                      ],
                    )
                  else
                    isCompact
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: EduFormStyles.imageAction('Câmara', Icons.camera_alt_outlined, () => _pickImage(ImageSource.camera))),
                                  const SizedBox(width: 12),
                                  Expanded(child: EduFormStyles.imageAction('Galeria', Icons.image_outlined, () => _pickImage(ImageSource.gallery))),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(width: double.infinity, child: EduFormStyles.imageAction('Ficheiro / PDF', Icons.attach_file_rounded, _pickFile)),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: EduFormStyles.imageAction('Câmara', Icons.camera_alt_outlined, () => _pickImage(ImageSource.camera))),
                              const SizedBox(width: 12),
                              Expanded(child: EduFormStyles.imageAction('Galeria', Icons.image_outlined, () => _pickImage(ImageSource.gallery))),
                              const SizedBox(width: 12),
                              Expanded(child: EduFormStyles.imageAction('Ficheiro / PDF', Icons.attach_file_rounded, _pickFile)),
                            ],
                          ),
                  
                  const SizedBox(height: AppTokens.paddingLG),
                  EduFormStyles.dialogActions(
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _isSaving ? null : _confirmar,
                    confirmLabel: _dividaAnulada ? 'Anular dívida' : 'Confirmar pagamento',
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

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, int maxLines = 1, bool capitalize = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textCapitalization: capitalize ? TextCapitalization.words : TextCapitalization.none,
      decoration: EduFormStyles.inputDecoration(label, icon: icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, {String? initial}) {
    return DropdownButtonFormField<String>(
      initialValue: initial,
      decoration: EduFormStyles.inputDecoration(label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPreview() {
    final name = _evidencia!.name.toLowerCase();
    if (name.endsWith('.pdf')) {
      return _fileIcon(Icons.picture_as_pdf, 'DOCUMENTO PDF', Colors.red);
    }
    
    if (kIsWeb) {
      if (_webBytes != null) {
        return Image.memory(_webBytes!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fileIcon(Icons.insert_drive_file, 'FICHEIRO', Colors.black54));
      }
      return Image.network(_evidencia!.path, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fileIcon(Icons.insert_drive_file, 'FICHEIRO', Colors.black54));
    }
    
    return Image.file(File(_evidencia!.path), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fileIcon(Icons.insert_drive_file, 'FICHEIRO', Colors.black54));
  }

  Widget _fileIcon(IconData icon, String label, Color color) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
          Text(_evidencia!.name, style: const TextStyle(fontSize: 8), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  String _getMimeType(String ext) {
    switch (ext) {
      case '.pdf': return 'application/pdf';
      case '.jpg':
      case '.jpeg': return 'image/jpeg';
      case '.png': return 'image/png';
      case '.doc': return 'application/msword';
      case '.docx': return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default: return 'application/octet-stream';
    }
  }
}
