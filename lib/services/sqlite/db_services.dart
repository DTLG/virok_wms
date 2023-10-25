import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'selection_db.dart';

class SQFLiteServices {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> fullPath() async {
    const name = 'test2.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize()async{
    final path = await fullPath();
    var database = await openDatabase(path, version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version)async => await SelectionDB().createTable(database);
}
