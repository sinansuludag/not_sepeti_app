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

  Future<List<T>> getAll() async {
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

  String dateFormat(DateTime tm) {
    DateTime today = DateTime.now();
    Duration oneDay = Duration(days: 1);
    Duration twoDays = Duration(days: 2);
    Duration oneWeek = Duration(days: 7);
    String month;

    // Ay isimlerini belirleme
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylül";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
      default:
        throw ArgumentError('Invalid month');
    }

    Duration difference = today.difference(tm);

    // Tarih karşılaştırmaları
    if (difference.inDays == 0) {
      return "Bugün";
    } else if (difference.inDays == 1) {
      return "Dün";
    } else if (difference.inDays < 7) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
        default:
          throw ArgumentError('Invalid weekday');
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
  }
}
