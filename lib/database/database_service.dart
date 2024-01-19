import 'package:animain/util/strings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = databaseNameString;
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async =>
    await database.execute(
      """CREATE TABLE IF NOT EXISTS $tableNameString (
        "id" INTEGER NOT NULL,
        "title" TEXT NOT NULL,
        "description" TEXT NOT NULL,
        "episodes" INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );"""
    );
}