// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/database.dart';

class Mail {
  String id; // You may want to add an ID field for database purposes
  String sender;
  String receiver;
  String replyTo;
  String date;
  String subject;
  String message;
  List<Attachment> attachments;

  Mail({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.replyTo,
    required this.date,
    required this.subject,
    required this.message,
    required this.attachments,
  });

  factory Mail.fromJson(Map<String, dynamic> json) {
    List<Attachment> attachments = [];
    if (json['attachments'] != null) {
      attachments = List<Attachment>.from(
        json['attachments']
            .map((attachment) => Attachment.fromJson(attachment)),
      );
    }

    return Mail(
      id: json['id'] ?? '',
      sender: json['from'] ?? '',
      receiver: json['to'] ?? '',
      replyTo: json['reply_to'] ?? '',
      date: json['date'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      attachments: attachments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'reply_to': replyTo,
      'date': date,
      'subject': subject,
      'message': message,
      'attachments': attachments.map((attachment) => attachment.toJson()),
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
      getOnlineEmails();
      emails = await getLocalEmails();
    }
    print(emails);
    return emails;
  }

  // Fetch emails from the online API
  static Future<void> getOnlineEmails() async {
    final dio = Dio();
    try {
      Response<dynamic> response = await dio.get(
        'http://10.103.3.196:8000/api/fetch-emails',
      );

      if (response.statusCode == 200) {
        dynamic data = response.data;

        print(data);

        if (data.containsKey('emails')) {
          List<dynamic> emails = data['emails'];

          int i = 0;
          for (var x in emails) {
            i++;
            Mail emails = Mail.fromJson(x);
            emails.save();
          }

          print(
              "...............................Saved $i emails..........................................");
        }
      }
    } catch (error) {
      // Handle the error case
      print("Error fetching online emails: $error");
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
      //delete the table if it exists
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
    attachmentsName TEXT,
    attachmentsUrl TEXT
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
    print('local.....');

    return db.query('emailTable', where: where).then((value) {
      List<Mail> emails = [];
      for (var x in value) {
        emails.add(Mail.fromJson(x));
      }
      return emails;
    });
  }

  //TO DISPLAY THE NAME OF THE EMAIL IN THE DATABASE BY PRINT
  static void displayEmails() async {
    List<Mail> emails = await getLocalEmails();
    for (var x in emails) {
      print(x.subject);
    }
  }
}

class Attachment {
  String filename;
  String url;

  Attachment({
    required this.filename,
    required this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      filename: json['filename'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'url': url,
    };
  }
}
