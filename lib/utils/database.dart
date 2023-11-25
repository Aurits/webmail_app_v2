import 'package:sqflite/sqflite.dart';

class Utils {
  static init() async {
    var db = openDatabase('local.db', version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE emails(
          id TEXT PRIMARY KEY,
          sender TEXT,
          receiver TEXT,
          reply_to TEXT,
          date TEXT,
          subject TEXT,
          message TEXT,
          attachments TEXT
        )
      ''');
    });
    return db;
  }
}
