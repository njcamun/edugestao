// ignore_for_file: deprecated_member_use

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor connect() {
  return WebDatabase('edugestao_db', logStatements: true);
}
