import 'package:sqflite/sqflite.dart';

class Utils {
  static init() async {
    var db = openDatabase('local_db.db');
    return db;
  }
}
