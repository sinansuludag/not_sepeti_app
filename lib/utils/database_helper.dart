import 'dart:io';

import 'package:flutter/services.dart';
import 'package:not_sepeti_app/utils/Idatabase_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper<T> {
  static final Map<Type, dynamic> _instances = {};
  final IDatabaseHelper<T> _strategy;
  static Database? _database;

  DatabaseHelper._internal(this._strategy);

  factory DatabaseHelper(IDatabaseHelper<T> strategy) {
    if (_instances[T] == null) {
      _instances[T] = DatabaseHelper._internal(strategy);
    }
    return _instances[T] as DatabaseHelper<T>;
  }

  Future<Database> _getDatabase() async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notlar.db");

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load("assets/notlar.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    var db = await _getDatabase();
    return await _strategy.getAll(db);
  }

  Future<int> insert(T data) async {
    var db = await _getDatabase();
    return await _strategy.insert(db, data);
  }

  Future<int> update(
      T data, String whereClause, List<dynamic> whereArgs) async {
    var db = await _getDatabase();
    return await _strategy.update(db, data, whereClause, whereArgs);
  }

  Future<int> delete(String whereClause, List<dynamic> whereArgs) async {
    var db = await _getDatabase();
    return await _strategy.delete(db, whereClause, whereArgs);
  }
}


// class DatabaseHelper {
//   static DatabaseHelper? _databaseHelper;
//   static Database? _database;

//   factory DatabaseHelper() {
//     if (_databaseHelper == null) {
//       _databaseHelper = DatabaseHelper._internal();
//       return _databaseHelper!;
//     } else {
//       return _databaseHelper!;
//     }
//   }

//   DatabaseHelper._internal() {}

//   Future<Database> _getDatabase() async {
//     _database ??= await _initializeDatabase();
//     return _database!;
//   }

//   Future<Database> _initializeDatabase() async {
//     var databasesPath = await getDatabasesPath();
//     var path = join(databasesPath, "notlar.db");
//     print("Database path: $path");

//     // Check if the database exists
//     var exists = await databaseExists(path);
//     print("Database exists: $exists");

//     if (!exists) {
//       // Should happen only the first time you launch your application
//       print("Creating new copy from asset");

//       // Make sure the parent directory exists
//       try {
//         await Directory(dirname(path)).create(recursive: true);
//       } catch (_) {}

//       // Copy from asset
//       ByteData data =
//           await rootBundle.load("assets/notlar.db"); // Fix the path here
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//       // Write and flush the bytes written
//       await File(path).writeAsBytes(bytes, flush: true);
//     } else {
//       print("Opening existing database");
//     }

//     // Open the database
//     var db = await openDatabase(path, readOnly: false);
//     return db; // Return the correct variable here
//   }

//   Future<List<Map<String, dynamic>>> kategorileriGetir() async {
//     var db = await _getDatabase();
//     var sonuc = await db.query("Kategori");
//     return sonuc;
//   }

//   Future<int> kategoriEkle(Kategori kategori) async {
//     var db = await _getDatabase();
//     var sonuc = await db.insert("Kategori", kategori.toMap());
//     return sonuc;
//   }

//   Future<int> kategoriGuncelle(Kategori kategori) async {
//     var db = await _getDatabase();
//     var sonuc = await db.update("Kategori", kategori.toMap(),
//         where: 'kategoriID=?', whereArgs: [kategori.kategoriID]);
//     return sonuc;
//   }

//   Future<int> kategoriSil(int kategoriID) async {
//     var db = await _getDatabase();
//     var sonuc = await db
//         .delete("Kategori", where: 'kategoriID=?', whereArgs: [kategoriID]);
//     return sonuc;
//   }

// //******************************************************** */

//   Future<List<Map<String, dynamic>>> notlariGetir() async {
//     var db = await _getDatabase();
//     var sonuc = await db.query("Not", orderBy: 'notID DESC');
//     return sonuc;
//   }

//   Future<int> notEkle(Not not) async {
//     var db = await _getDatabase();
//     var sonuc = await db.insert("Not", not.toMap());
//     return sonuc;
//   }

//   Future<int> notSil(int notID) async {
//     var db = await _getDatabase();
//     var sonuc = await db.delete("Not", where: 'notID=?', whereArgs: [notID]);
//     return sonuc;
//   }

//   Future<int> notlariGuncelle(Not not) async {
//     var db = await _getDatabase();
//     var sonuc = await db
//         .update("Not", not.toMap(), where: 'notID=?', whereArgs: [not.notID]);
//     return sonuc;
//   }
// }
