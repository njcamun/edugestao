import '../entities/nota_avaliacao.dart';

abstract class GradesRepository {
  Stream<List<NotaAvaliacao>> watchNotas({required int trimestre, String? anoLectivo, String? disciplina});
  Future<void> save(NotaAvaliacao nota);
  Future<void> delete(String id);
}
