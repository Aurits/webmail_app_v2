// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/mail.dart';

class EmailsPage extends StatefulWidget {
  const EmailsPage({super.key});

  @override
  State<EmailsPage> createState() => _EmailsPageState();
}

class _EmailsPageState extends State<EmailsPage>
    with SingleTickerProviderStateMixin {
  List<Mail> emails = [];

  bool loading = false;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _loadEmails();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {});
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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

    // Call the displayEmails

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
      //floating
      floatingActionButton: Container(
        margin: const EdgeInsets.all(10),
        child: FloatingActionButton(
          heroTag: "fab1",
          backgroundColor: Colors.teal[500],
          onPressed: () {
            print("Pressed");
          },
          elevation: 2,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Column(
        children: <Widget>[
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
          const Expanded(
            child: Text(
              "Hello",
            ),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: const EdgeInsets.all(0),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: TabBar(
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 1,
                tabs: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Tab(
                      icon: Icon(
                        Icons.apps,
                        color: Colors.teal[600],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Tab(
                      icon: Icon(
                        Icons.settings_applications,
                        color: Colors.teal[600],
                      ),
                    ),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
