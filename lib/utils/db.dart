import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import 'package:pesagens_de_gado/models/weighing.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database == null)
      _database = await _initDatabase();

    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'pesagens_de_gado.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(db, version) async {
    await db.execute(_createAnimalsTable);
    await db.execute(_createBatchesTable);
    await db.execute(_createWeighingsTable);
  }

  void close() async {
    final db = await instance.database;
    db.close();
  }

  final String _createAnimalsTable = '''
    CREATE TABLE animals (
      id TEXT PRIMARY KEY,
      coat TEXT NULL,
      birthDate DATETIME NULL
    );
  ''';

  final String _createBatchesTable = '''
    CREATE TABLE batches (
      batchName TEXT PRIMARY KEY,
      description TEXT NULL
    );
  ''';

  final String _createWeighingsTable = '''
    CREATE TABLE weighings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      idAnimal TEXT NULL,
      batchName TEXT NULL,
      date DATETIME NOT NULL,
      weight TEXT NOT NULL,
      FOREIGN KEY (idAnimal) REFERENCES animals (id),
      FOREIGN KEY (batchName) REFERENCES batches (batchName)
    );
  ''';



  /*
  Future<List<Weighing>> listWeighingByControllId(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'pesagens',
      where: 'idControle = ?',
      whereArgs: [id],
      orderBy: 'idPesagem DESC'
    );

    return result.map((json) => Weighing.fromJson(json)).toList();
  }
  */

  Future<List<Weighing>> listWeighings() async {
    final db = await instance.database;

    final result = await db.query('weighings');

    return result.map((json) => Weighing.fromJson(json)).toList();
  }

  /*
  Future<double> sumOfWeight(int id) async {
    final db = await instance.database;

    return (await db.rawQuery('SELECT SUM(pesoAnimais) FROM pesagens WHERE idControle = ?', [id])).first;
  }

  Future<double> minOfWeight(int id) async {
    final db = await instance.database;

    return (await db.rawQuery('SELECT MIN(pesoAnimais) FROM pesagens WHERE idControle = ?', [id])).first;
  }

  Future<double> maxOfWeight(int id) async {
    final db = await instance.database;

    return (await db.rawQuery('SELECT MAX(pesoAnimais) FROM pesagens WHERE idControle = ?', [id])).first;
  }

  Future<int> quantOfAnimals(int id) async {
    final db = await instance.database;

    return (await db.rawQuery('SELECT COUNT(quantidadeAnimais) FROM pesagens WHERE idControle = ?', [id])).first;
  }
  */
}