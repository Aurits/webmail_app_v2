// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makerere_webmail_app/adapters/email_adapter.dart';
import 'package:makerere_webmail_app/pages/emails/email_detail_page.dart';

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
      drawer: const Drawer(),
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
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/compose');
            },
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: double.infinity,
            color: Colors.green[400],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  //display the number of emails
                  "All mails (${emails.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
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
                        color: Colors.black,
                      ),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
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
                        child: EmailAdapter(emails, (index, mail) {
                          // Handle the click event, if needed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EmailDetailPage(email: emails[index]),
                            ),
                          );
                        }).getView(),
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
                      icon: InkWell(
                        onTap: () {
                          showBottonSheet();
                        },
                        child: Icon(
                          Icons.apps,
                          color: Colors.teal[600],
                        ),
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

  void showBottonSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: const Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.inbox,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'Inbox',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.star,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'Starred',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.send,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'Sent',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.drafts,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'Drafts',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'Trash',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.archive,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'Archive',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: null,
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.teal,
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: null,
                ),
              ],
            ),
          );
        });
  }
}
