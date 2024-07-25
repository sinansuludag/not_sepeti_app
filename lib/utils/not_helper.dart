import 'package:not_sepeti_app/models/notlar.dart';
import 'package:not_sepeti_app/utils/Idatabase_helper.dart';
import 'package:sqflite_common/sqlite_api.dart';

class NotHelper implements IDatabaseHelper<Not> {
  @override
  Future<List<Map<String, dynamic>>> getAll(Database db) async {
    return await db.query("Not", orderBy: 'notID DESC');
  }

  @override
  Future<int> insert(Database db, Not data) async {
    return await db.insert("Not", data.toMap());
  }

  @override
  Future<int> update(Database db, Not data, String whereClause,
      List<dynamic> whereArgs) async {
    return await db.update("Not", data.toMap(),
        where: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
      Database db, String whereClause, List<dynamic> whereArgs) async {
    return await db.delete("Not", where: whereClause, whereArgs: whereArgs);
  }
}