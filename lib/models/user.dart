// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:sqflite/sqflite.dart';

import '../utils/database.dart';

class User {
  String username;
  String password;

  User({required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

//save user in local database //
  Future<String> saveUser() async {
    String response = "";
    Database db = await Utils.init();
    String resp = await initTable(db);

    print(resp);
    print("start......next");

    if (resp.isNotEmpty) {
      print("start......");
      try {
        await db.insert(
          'userTable',
          toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        response = 'Saved user successfully';
        print("Saved successfully");
      } catch (e) {
        print("Failed db save: $e");
      }
    } else {
      print("Table not created");
    }
    return response;
  }

  // Initialize the database table
  static Future<String> initTable(Database db) async {
    String resp = '';

    if (db == null) {
      resp = 'Failed to initialize the db';
      print(resp);
      return resp;
    }

    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS userTable(
          username TEXT PRIMARY KEY,
          password TEXT NOT NULL
        )
      ''');

      resp = 'Table for user created successfully....';
      print(resp);
    } catch (e) {
      resp = 'Failed to create table in the db: ${e.toString()}}';
      print(resp);
    }
    return resp;
  }

  //TO DISPLAY THE NAME OF THE EMAIL IN THE DATABASE BY PRINT
  static void deleteUser() async {
    Database db = await Utils.init();
    await initTable(db);

    db.delete('userTable');

    print('deleted');
  }
}
