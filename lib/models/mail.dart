// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:makerere_webmail_app/models/user.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/database.dart';

class Mail {
  String sender;
  String receiver;
  String replyTo;
  String date;
  String subject;
  String message;
  String attachments;

  Mail({
    required this.sender,
    required this.receiver,
    required this.replyTo,
    required this.date,
    required this.subject,
    required this.message,
    required this.attachments,
  });

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(
      sender: json['from'] ?? '',
      receiver: json['to'] ?? '',
      replyTo: json['reply_to'] ?? '',
      date: json['date'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      attachments: json['attachments'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'reply_to': replyTo,
      'date': date,
      'subject': subject,
      'message': message,
      'attachments': attachments,
    };
  }

  // Get emails, first from local storage, then online if local is empty
  static Future<List<Mail>> getItems() async {
    List<Mail> emails = await getLocalEmails();
    if (emails.isEmpty) {
      print("Fetching online emails...");
      await getOnlineEmails();
      emails = await getLocalEmails();
    } else {
      print("Fetching online emails for refresh...");
      await getOnlineEmails();
      emails = await getLocalEmails();
    }
    print(emails);
    return emails;
  }

  // Fetch emails from the online API
  static Future<void> getOnlineEmails() async {
    final dio = Dio();

    try {
      // Retrieve user details from the local database
      User? user = await getUserDetails();

      //print the user details here

      // Check if user details are available
      if (user != null) {
        print(
            "${user.username}${user.password}...............................");
        // Make the API request with user credentials

        Response<dynamic> response = await dio.get(
          'https://multi-client-webmail-api-c9bb15a3-7f5f-41f9-88b4.cranecloud.io/api/fetch-emails',
          data: {
            'username': 'your_username',
            'password': 'your_password',
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': '*/*',
            },
          ),
        );

        if (response.statusCode == 200) {
          dynamic data = response.data;

          print(data);

          if (data.containsKey('emails')) {
            List<dynamic> emails = data['emails'];

            int i = 0;
            for (var x in emails) {
              i++;
              // Assuming you have a Mail.fromJson method to create a Mail object
              Mail email = Mail.fromJson(x);
              email.save(); // Save the email to local storage
            }

            print("Saved $i emails");
          }
        }
      } else {
        print('User details not available.');
      }
    } catch (error) {
      // Handle the error case
      print("Error fetching online emails: $error");
    }
  }

// Function to retrieve user details from the local database
  static Future<User?> getUserDetails() async {
    Database db = await Utils.init();
    List<Map<String, dynamic>> results = await db.query('userTable');

    if (results.isNotEmpty) {
      // Assuming there is only one user in the database
      return User.fromJson(results[0]);
    } else {
      return null;
    }
  }

  // Save email to local database
  Future<void> save() async {
    Database db = await Utils.init();
    String resp = await initTable(db);

    print(resp);
    print("start......next");

    if (resp.isNotEmpty) {
      print("start......");
      try {
        await db.insert(
          'emailTable',
          toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("Saved successfully");
      } catch (e) {
        print("Failed db save: $e");
      }
    } else {
      print("Table not created");
    }
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
      //delete the table
      // await db.execute('''DROP TABLE IF EXISTS emailTable''');
      //create the table
      await db.execute('''
                          CREATE TABLE IF NOT EXISTS emailTable (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            sender TEXT,  
                            receiver TEXT,
                            reply_to TEXT,
                            date TEXT,
                            subject TEXT,
                            message TEXT,
                            attachments TEXT
                          )
                        ''');

      resp = 'Table created successfully....';
      print(resp);
    } catch (e) {
      resp = 'Failed to create table in the db: ${e.toString()}}';
      print(resp);
    }
    return resp;
  }

  // Get local emails from the database
  static Future<List<Mail>> getLocalEmails({String where = "1"}) async {
    Database db = await Utils.init();
    await initTable(db);

    print(
        'local...............................................................................');

    return db.query('emailTable', where: where).then((value) {
      List<Mail> emails = [];
      for (var x in value) {
        emails.add(Mail.fromJson(x));
      }
      return emails;
    });
  }

  //TO DISPLAY THE NAME OF THE EMAIL IN THE DATABASE BY PRINT
  static void deleteEmails() async {
    Database db = await Utils.init();
    await initTable(db);

    print(
        'local...............................................................................');

    db.delete('emailTable');

    print('deleted');
  }
}
