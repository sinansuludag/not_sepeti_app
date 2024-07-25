import 'package:sqflite/sqflite.dart';

abstract class IDatabaseHelper<T> {
  Future<List<Map<String, dynamic>>> getAll(Database db);
  Future<int> insert(Database db, T data);
  Future<int> update(
      Database db, T data, String whereClause, List<dynamic> whereArgs);
  Future<int> delete(Database db, String whereClause, List<dynamic> whereArgs);
}
