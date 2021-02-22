import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Initdb {
  static final _databaseName = "hashapp.db";
  static final _databaseVersion = 1;

  static final table = 'user';

  static final columnId = '_id';
  static final columnCoins = '_coins';
  static final columnLockedLevels = '_lockedLevels';
  static final columnSolvedProblem = '_solvedProblems';
  static final columnNumberOfSolved = '_numberOfSolved';

  Initdb._privateConstructor();
  static final Initdb instance = Initdb._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initializeDb();
    return _database;
  }

  _initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnCoins INTEGER,
            $columnLockedLevels INTEGER,
            $columnSolvedProblem TEXT,
            $columnNumberOfSolved INTEGER
          )
          ''');
  }

  Future rmDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _databaseName);
    await deleteDatabase(path);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  //This future is used to simplify seeing the content of the DB
  Future<List> dbContent() async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery('SELECT * FROM user');
    return list;
  }

  //This series of future will help retrive specific data
  Future<int> coins() async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery('SELECT * FROM user');
    return list[0]['_coins'];
  }

  Future<int> lockedLevels() async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery('SELECT * FROM user');
    return list[0]['_lockedLevels'];
  }

  Future<String> solvedProblems() async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery('SELECT * FROM user');
    return list[0]['_solvedProblems'];
  }

  Future<int> numberOfSolved() async {
    Database db = await instance.database;
    List<Map> list = await db.rawQuery('SELECT * FROM user');
    return list[0]['_numberOfSolved'];
  }
}
