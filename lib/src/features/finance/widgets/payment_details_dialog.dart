import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/mensalidade.dart';
import '../../../domain/entities/pagamento.dart';
import '../../../domain/entities/evidencia_pagamento.dart';
import '../finance_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;

class PaymentDetailsDialog extends ConsumerWidget {
  final Mensalidade mensalidade;
  const PaymentDetailsDialog({super.key, required this.mensalidade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFmt = NumberFormat.currency(locale: 'pt_AO', symbol: 'KZ');
    final repo = ref.watch(financeRepositoryProvider);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FutureBuilder<List<Pagamento>>(
            future: repo.getPagamentosByMensalidade(mensalidade.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator(color: Colors.black)),
                );
              }

              final pagamentos = snapshot.data ?? [];
              if (pagamentos.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('NENHUM REGISTRO DE PAGAMENTO ENCONTRADO.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                );
              }

              final pagamento = pagamentos.first; // Pegamos o primeiro (geralmente único por mensalidade)

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DETALHES DO PAGAMENTO',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const Divider(color: Colors.black, thickness: 2, height: 32),
                  
                  _infoRow('RECIBO:', pagamento.numeroRecibo),
                  _infoRow('VALOR:', currencyFmt.format(pagamento.valorPago)),
                  _infoRow('DATA:', DateFormat('dd/MM/yyyy HH:mm').format(pagamento.dataPagamento)),
                  _infoRow('MÉTODO:', pagamento.formaPagamento.toUpperCase()),
                  if (pagamento.observacao?.isNotEmpty ?? false)
                    _infoRow('OBS:', pagamento.observacao!),
                  
                  const SizedBox(height: 24),
                  const Text('EVIDÊNCIA / COMPROVATIVO:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  
                  if (pagamento.evidenciaId != null)
                    FutureBuilder<EvidenciaPagamento?>(
                      future: repo.getEvidenciaById(pagamento.evidenciaId!),
                      builder: (context, eviSnapshot) {
                        if (eviSnapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.black12,
                            child: const Center(child: CircularProgressIndicator(color: Colors.black)),
                          );
                        }

                        final evidencia = eviSnapshot.data;
                        if (evidencia == null) {
                          return const Text('EVIDÊNCIA NÃO LOCALIZADA.');
                        }

                        return Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: _buildEvidenciaImage(evidencia),
                          ),
                        );
                      },
                    )
                  else
                    const Text('SEM EVIDÊNCIA ANEXADA.'),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('FECHAR', style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildEvidenciaImage(EvidenciaPagamento evidencia) {
    // Tenta carregar do path local ou URL remota
    if (kIsWeb) {
      if (evidencia.urlRemota != null) {
        return Image.network(evidencia.urlRemota!, fit: BoxFit.contain);
      }
      // Se for web e não tiver URL, tentamos o caminho local (pode ser blob)
      return Image.network(evidencia.caminhoLocal, fit: BoxFit.contain, 
        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 40)));
    } else {
      final file = File(evidencia.caminhoLocal);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.contain);
      } else if (evidencia.urlRemota != null) {
        return Image.network(evidencia.urlRemota!, fit: BoxFit.contain);
      }
    }
    return const Center(child: Text('IMAGEM INDISPONÍVEL LOCALMENTE'));
  }
}
