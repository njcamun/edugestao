import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/database_provider.dart';
import '../../../domain/entities/aluno.dart';
import '../../../domain/entities/sync_entity.dart';
import '../students_controller.dart';

class StudentSeeder extends ConsumerStatefulWidget {
  const StudentSeeder({super.key});

  @override
  ConsumerState<StudentSeeder> createState() => _StudentSeederState();
}

class _StudentSeederState extends ConsumerState<StudentSeeder> {
  bool _isImporting = false;

  Future<void> _importCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt'],
      );

      if (result == null || result.files.single.path == null) return;

      setState(() => _isImporting = true);

      final file = File(result.files.single.path!);
      final input = await file.readAsLines(encoding: utf8);
      
      final repository = ref.read(studentRepositoryProvider);
      final db = ref.read(databaseProvider);
      
      int importedCount = 0;
      int skippedCount = 0;

      for (var i = 0; i < input.length; i++) {
        final line = input[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        final nome = parts[0].trim();
        if (nome.isEmpty || nome.toLowerCase() == 'nome') continue;

        // Correção da query para evitar erro de findFirst
        final query = db.select(db.alunos)..where((t) => t.nomeCompleto.equals(nome));
        final existingAluno = await query.getSingleOrNull();
        
        if (existingAluno != null) {
          skippedCount++;
          continue;
        }

        String dataStr = parts.length > 1 ? parts[1].trim() : '';
        DateTime dataInscricao;
        try {
          dataInscricao = dataStr.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(dataStr) : DateTime.now();
        } catch (_) {
          dataInscricao = DateTime.now();
        }

        final aluno = Aluno()
          ..id = const Uuid().v4()
          ..nomeCompleto = nome
          ..dataInscricao = dataInscricao
          ..dataNascimento = DateTime(2015, 1, 1)
          ..sexo = 'M'
          ..morada = 'Pendente'
          ..escolaQueFrequenta = 'Pendente'
          ..anoEscolaridade = '1ª Classe'
          ..possuiCondicaoMedica = false
          ..nomeEncarregado = 'Pendente'
          ..telefonePrincipal = '000000000'
          ..numeroAluno = 'ALU-${DateTime.now().year}${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}$i'
          ..status = AlunoStatus.ativo
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now()
          ..syncStatus = SyncStatus.pendingSync;

        await repository.saveAluno(aluno);
        importedCount++;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SUCESSO: $importedCount IMPORTADOS, $skippedCount REPETIDOS IGNORADOS.'),
            backgroundColor: Colors.black,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ERRO NA IMPORTAÇÃO: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isImporting
        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
        : ElevatedButton.icon(
            onPressed: _importCSV,
            icon: const Icon(Icons.file_upload_outlined),
            label: const Text('IMPORTAR CSV/TXT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
  }
}
