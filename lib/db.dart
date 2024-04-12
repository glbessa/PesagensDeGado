import 'package:pesagens_de_gado/weighing_controll.dart';
import 'package:pesagens_de_gado/weighing.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null)
      return _database;

    return await _initDatabase();
  }

  final String _createWeighingControllTable = '''
    CREATE TABLE controleDePesagens (
      idControle INTEGER PRIMARY KEY AUTOINCREMENT,
      lote TEXT NOT NULL,
      data INTEGER NOT NULL,
      detalhes TEXT NOT NULL
    );
  ''';

  final String _createWeighinsTable = '''
    CREATE TABLE pesagens (
      idPesagem INTEGER PRIMARY KEY AUTOINCREMENT,
      idControle INTEGER NOT NULL,
      FOREIGN KEY(idControle) REFERENCES controleDePesagens(idControle),
      identificacaoAnimais TEXT NOT NULL,
      quantidadeAnimais INTEGER NOT NULL,
      pesoAnimais REAL NOT NULL
    );
  ''';

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'pesagens_de_gado.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_createWeighingControllTable);
    await db.execute(_createWeighinsTable);
  }

  close() async {
    final db = await instance.database;
    db.close();
  }

  Future<WeighingControll> insertWeighingControll(WeighingControll wc) async {
    final db = await instance.database;

    int id = await db.insert('controleDePesagens', wc.toJson());
    wc.idControle = id;

    return wc;
  }

  Future<int> updateWeighingControll(WeighingControll wc) async {
    final db = await instance.database;

    return db.update(
      'controleDePesagens',
      wc.toJson(),
      where: 'idControle = ?',
      whereArgs: wc.idControle
    );
  }

  Future<int> deleteWeighingControll(int id) async {
    final db = await instance.database;

    return db.delete(
        'controleDePesagens',
        where: 'idControle = ?',
        whereArgs: [id]
    );
  }

  Future<WeighingControll?> selectWeighingControll(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'controleDePesagens',
      where: 'idControle = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return WeighingControll.fromJson(maps.first);
    }

    return null;
  }

  Future<List<WeighingControll>> listWeighingControll() async {
    final db = await instance.database;

    final result = await db.query('controleDePesagens');

    return result.map((json) => WeighingControll.fromJson(json)).toList();
  }

  Future<Weighing> insertWeighing(Weighing w) async {
    final db = await instance.database;

    int id = await db.insert('pesagens', w.toJson());
    w.idPesagem = id;

    return w;
  }

  Future<int> updateWeighing(Weighing w) async {
    final db = await instance.database;

    return db.update(
        'pesagens',
        w.toJson(),
        where: 'idPesagem = ?',
        whereArgs: w.idControle
    );
  }

  Future<int> deleteWeighing(int id) async {
    final db = await instance.database;

    return db.delete(
        'pesagens',
        where: 'idPesagem = ?',
        whereArgs: [id]
    );
  }

  Future<Weighing?> selectWeighing(int id) async {
    final db = await instance.database;

    final maps = await db.query(
        'pesagens',
        where: 'idPesagem = ?',
        whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Weighing.fromJson(maps.first);
    }

    return null;
  }

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

  Future<List<Weighing>> listWeighing() async {
    final db = await instance.database;

    final result = await db.query('pesagens');

    return result.map((json) => Weighing.fromJson(json)).toList();
  }

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
}