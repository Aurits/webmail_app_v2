import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makerere_webmail_app/models/mail.dart';

class EmailsPage extends StatefulWidget {
  const EmailsPage({super.key});

  @override
  State<EmailsPage> createState() => _EmailsPageState();
}

class _EmailsPageState extends State<EmailsPage> {
  List<Mail> emails = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  // Function to load emails
  Future<void> _loadEmails() async {
    // Simulating an asynchronous call to fetch emails
    await Future.delayed(const Duration(seconds: 3));

    List<Mail> fetchedEmails = await Mail.getItems();
    setState(() {
      emails = fetchedEmails;
    });
  }

  // Function to handle pull-to-refresh
  Future<void> _handleRefresh() async {
    setState(() {
      loading = true;
    });

    await _loadEmails();

    //call the displayEmails

    Mail.displayEmails();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Display emails
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  itemCount: emails.length,
                  itemBuilder: (BuildContext context, int index) {
                    Mail email = emails[index];
                    // Customize the ListTile according to your email model
                    return ListTile(
                      title: Text(email.subject),
                      subtitle: Text(email.sender),
                      // Add more details as needed
                    );
                  },
                ),
              ),
            ),
            // Display the number of emails
            Text(
              "You have ${emails.length} emails",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            //inkwell to refresh emails
            InkWell(
              onTap: _handleRefresh,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Refresh",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
