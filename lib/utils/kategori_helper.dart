import 'package:not_sepeti_app/models/kategori.dart';
import 'package:not_sepeti_app/utils/Idatabase_helper.dart';
import 'package:sqflite/sqflite.dart';

class KategoriHelper implements IDatabaseHelper<Kategori> {
  @override
  Future<List<Kategori>> getAll(Database db) async {
    var sonuc = await db.query("Kategori", orderBy: 'kategoriID DESC');
    var kategoriListesi = <Kategori>[];
    for (Map<String, dynamic> map in sonuc) {
      kategoriListesi.add(Kategori.fromMap(map));
    }
    return kategoriListesi;
  }

  @override
  Future<int> insert(Database db, Kategori data) async {
    return await db.insert("Kategori", data.toMap());
  }

  @override
  Future<int> update(Database db, Kategori data, String whereClause,
      List<dynamic> whereArgs) async {
    return await db.update("Kategori", data.toMap(),
        where: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
      Database db, String whereClause, List<dynamic> whereArgs) async {
    return await db.delete("Kategori",
        where: whereClause, whereArgs: whereArgs);
  }
}
