import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/entities/mensalidade.dart';
import '../../../domain/entities/pagamento.dart';
import '../../../domain/entities/evidencia_pagamento.dart';
import '../../../shared/widgets/edu_form_styles.dart';
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
      shape: EduFormStyles.dialogShape(),
      child: ConstrainedBox(
        constraints: EduFormStyles.dialogConstraints(context, maxWidth: 500),
        child: Padding(
          padding: EduFormStyles.dialogPadding(context),
          child: FutureBuilder<List<Pagamento>>(
            future: repo.getPagamentosByMensalidade(mensalidade.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator(color: AppTokens.primary)),
                );
              }

              final pagamentos = snapshot.data ?? [];
              if (pagamentos.isEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EduFormStyles.dialogHeader(context, 'Detalhes do pagamento'),
                    const SizedBox(height: AppTokens.paddingLG),
                    const Text('Nenhum registo de pagamento encontrado.', textAlign: TextAlign.center),
                    const SizedBox(height: AppTokens.paddingLG),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
                    ),
                  ],
                );
              }

              final pagamento = pagamentos.first;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EduFormStyles.dialogHeader(context, 'Detalhes do pagamento'),
                  const SizedBox(height: AppTokens.paddingMD),
                  EduFormStyles.infoRow('Recibo', pagamento.numeroRecibo),
                  EduFormStyles.infoRow('Valor', currencyFmt.format(pagamento.valorPago)),
                  EduFormStyles.infoRow('Data', DateFormat('dd/MM/yyyy HH:mm').format(pagamento.dataPagamento)),
                  EduFormStyles.infoRow('Método', pagamento.formaPagamento),
                  if (pagamento.observacao?.isNotEmpty ?? false)
                    EduFormStyles.infoRow('Observação', pagamento.observacao!),
                  const SizedBox(height: AppTokens.paddingMD),
                  EduFormStyles.sectionLabel('Evidência / comprovativo'),
                  const SizedBox(height: 8),
                  if (pagamento.evidenciaId != null)
                    FutureBuilder<EvidenciaPagamento?>(
                      future: repo.getEvidenciaById(pagamento.evidenciaId!),
                      builder: (context, eviSnapshot) {
                        if (eviSnapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTokens.background,
                              borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                            ),
                            child: const CircularProgressIndicator(color: AppTokens.primary),
                          );
                        }

                        final evidencia = eviSnapshot.data;
                        if (evidencia == null) {
                          return const Text('Evidência não localizada.');
                        }

                        return Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                            border: Border.all(color: AppTokens.border),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppTokens.radiusMD),
                            child: _buildEvidenciaImage(evidencia),
                          ),
                        );
                      },
                    )
                  else
                    const Text('Sem evidência anexada.'),
                  const SizedBox(height: AppTokens.paddingLG),
                  FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenciaImage(EvidenciaPagamento evidencia) {
    if (kIsWeb) {
      if (evidencia.urlRemota != null) {
        return Image.network(evidencia.urlRemota!, fit: BoxFit.contain);
      }
      return Image.network(
        evidencia.caminhoLocal,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 40)),
      );
    }

    final file = File(evidencia.caminhoLocal);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.contain);
    }
    if (evidencia.urlRemota != null) {
      return Image.network(evidencia.urlRemota!, fit: BoxFit.contain);
    }
    return const Center(child: Text('Imagem indisponível localmente'));
  }
}
