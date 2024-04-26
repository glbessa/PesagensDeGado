import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class Weighing {
  static const String TableName = "weighings";

  int? id;
  String? idAnimal;
  String? batchName;
  DateTime date;
  double weight;

  Weighing ({
    this.id,
    this.idAnimal,
    required this.batchName,
    required this.date,
    required this.weight
  });

  static Weighing fromJson(Map<String, Object?> json) => Weighing (
      id: json['id'] as int?,
      idAnimal: json['idAnimal'] as String,
      batchName: json['batchName'] as String,
      date: json['date'] as DateTime,
      weight: json['weight'] as double
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'idAnimal': idAnimal,
    'batchName': batchName,
    'date': date,
    'weight': weight
  };
}