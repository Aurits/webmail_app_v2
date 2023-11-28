// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:sqflite/sqflite.dart';
import '../utils/database.dart';

class User {
  String username;
  String password;
  String timestamp; // Add a timestamp field

  User({required this.username, required this.password})
      : timestamp = DateTime.now()
            .toIso8601String(); // Set the timestamp when the user is created

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'timestamp': timestamp};
  }

  // Save user in the local database
  Future<String> saveUser() async {
    String response = "";
    Database db = await Utils.init();
    String resp = await initTable(db);

    print(resp);

    if (resp.isNotEmpty) {
      print("Deleting existing user...");
      // Delete the existing user
      await db.delete('usersTable');

      print("Saving new user...");
      try {
        await db.insert(
          'usersTable',
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
//delete the table
    await db.execute('DROP TABLE IF EXISTS userTable');
    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS usersTable(
          username TEXT PRIMARY KEY,
          password TEXT NOT NULL,
          timestamp TEXT NOT NULL
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

  // Delete the user from the table
  static void deleteUser() async {
    Database db = await Utils.init();
    await initTable(db);

    db.delete('usersTable');

    print('User deleted');
  }

  // Check if the user record is expired based on a specified period (in minutes)
  static Future<bool> isUserExpired(int expirationPeriodInMinutes) async {
    Database db = await Utils.init();
    await initTable(db);

    List<Map<String, dynamic>> user = await db.query('usersTable');

    if (user.isNotEmpty) {
      String timestamp = user[0]['timestamp'];
      DateTime userTimestamp = DateTime.parse(timestamp);
      DateTime now = DateTime.now();
      Duration difference = now.difference(userTimestamp);

      return difference.inMinutes > expirationPeriodInMinutes;
    }

    // Return true if no user record is found (consider it as expired)
    return true;
  }
}
