import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Carrega fontes com suporte Unicode (acentos, ç, etc.) para PDFs.
class PdfFontService {
  static pw.Font? _base;
  static pw.Font? _bold;

  static Future<pw.ThemeData> theme() async {
    _base ??= await PdfGoogleFonts.notoSansRegular();
    _bold ??= await PdfGoogleFonts.notoSansBold();
    return pw.ThemeData.withFont(base: _base!, bold: _bold!);
  }
}
