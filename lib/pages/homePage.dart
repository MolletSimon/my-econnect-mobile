import 'package:flutter/material.dart';
import 'package:my_econnect/pages/feedPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    FeedPage(),
    Container(
      child: Text("Agenda"),
    ),
    Container(
      child: Text("Groupes"),
    )
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.today),
                  label: "Calendar",
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.groups),
                  label: "Groups",
                ),
              ],
            ),
          )),
    );
  }
}
