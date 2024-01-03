import 'package:sqflite/sqflite.dart';

class SelectionDB {
  Future<void> createTable(Database database) async {
    await database.execute('''
CREATE TABLE IF NOT EXISTS selection (
  "id" INTEGER,
  "name" TEXT,
  "article" TEXT,
  "cell" TEXT,
  "doc_number" TEXT,
  "table_value" TEXT,
  "count" REAL,
  "qty" REAL
);
''');
    await database.execute('''
CREATE TABLE IF NOT EXISTS barcodes (
  "nom_id" INTEGER,
  "barcode" TEXT,
  "ratio" INTEGER
);
''');
  }
}
