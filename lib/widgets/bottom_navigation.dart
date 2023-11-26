// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
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
