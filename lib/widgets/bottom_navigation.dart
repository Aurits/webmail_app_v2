import 'package:flutter/material.dart';

class PrimaryBottomNavigation extends StatefulWidget {
  PrimaryBottomNavigation();

  @override
  State<PrimaryBottomNavigation> createState() =>
      new _PrimaryBottomNavigationState();
}

class _PrimaryBottomNavigationState extends State<PrimaryBottomNavigation>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {});
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      //floating
      floatingActionButton: Container(
        margin: EdgeInsets.all(10),
        child: FloatingActionButton(
          heroTag: "fab1",
          backgroundColor: Colors.teal[500],
          onPressed: () {
            print("Pressed");
          },
          elevation: 2,
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
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
              margin: EdgeInsets.all(0),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: TabBar(
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 1,
                  tabs: [
                    Container(
                      child: Tab(
                        icon: Icon(
                          Icons.apps,
                          color: Colors.teal[600],
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    ),
                    Container(
                      child: Tab(
                        icon: Icon(
                          Icons.settings_applications,
                          color: Colors.teal[600],
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
