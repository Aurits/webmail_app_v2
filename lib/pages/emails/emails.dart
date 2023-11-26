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

  bool loading = true;
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
    await Future.delayed(const Duration(seconds: 1));

    List<Mail> fetchedEmails = await Mail.getItems();
    setState(() {
      emails = fetchedEmails;
      loading = false;
    });
  }

  // Function to handle pull-to-refresh
  Future<void> _handleRefresh() async {
    setState(() {
      loading = true;
    });

    await _loadEmails();
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
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: double.infinity,
            color: Colors.teal[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  //display the number of emails
                  "Inbox (${emails.length})",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        print("Pressed");
                        _handleRefresh();
                      },
                    ),
                    //filter icon

                    IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        print("Pressed");
                        Mail.deleteEmails();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          loading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : emails.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text("No emails found"),
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                          itemCount: emails.length,
                          itemBuilder: (BuildContext context, int index) {
                            Mail email = emails[index];
                            // Customize the ListTile according to your email model
                            return ListTile(
                              subtitle: Text(email.subject,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                              title: Text(email.replyTo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              // Add more details as needed
                            );
                          },
                        ),
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
                      icon: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                        child: Icon(
                          Icons.settings,
                          color: Colors.teal[600],
                        ),
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
