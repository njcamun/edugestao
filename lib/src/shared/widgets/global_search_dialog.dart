import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/global_search_service.dart';

class GlobalSearchDialog extends ConsumerStatefulWidget {
  const GlobalSearchDialog({super.key});

  @override
  ConsumerState<GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<GlobalSearchDialog> {
  final _controller = TextEditingController();
  List<SearchResult> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    if (q.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    final results = await ref.read(globalSearchServiceProvider).search(q);
    if (mounted) {
      setState(() {
        _results = results;
        _loading = false;
      });
    }
  }

  IconData _iconFor(SearchResultType type) => switch (type) {
        SearchResultType.aluno => Icons.person_outline_rounded,
        SearchResultType.turma => Icons.class_outlined,
        SearchResultType.funcionario => Icons.badge_outlined,
        SearchResultType.matricula => Icons.how_to_reg_outlined,
        SearchResultType.ativo => Icons.inventory_2_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pesquisa global'),
      content: SizedBox(
        width: 480,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Aluno, turma, funcionário...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: _search,
            ),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text(
                        _controller.text.length < 2
                            ? 'Digite pelo menos 2 caracteres'
                            : 'Nenhum resultado',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, i) {
                        final r = _results[i];
                        return ListTile(
                          leading: Icon(_iconFor(r.type)),
                          title: Text(r.title),
                          subtitle: Text(r.subtitle),
                          onTap: () {
                            Navigator.pop(context);
                            context.go(r.route);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
      ],
    );
  }
}
