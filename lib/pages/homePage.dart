import 'package:flutter/material.dart';
import 'package:my_econnect/models/route.dart';
import 'package:my_econnect/pages/agendaPage.dart';
import 'package:my_econnect/pages/feedPage.dart';
import 'package:my_econnect/pages/groupsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Widget> _children = [
    FeedPage(),
    AgendaPage(),
    GroupsPage(),
    Container(
      child: Text("Users"),
    )
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  logout() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString("token", "");
    Navigator.of(context).pushNamed(RoutePaths.Login);
  }

  Container _disconnect() {
    return Container(
      child: TextButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
              BorderSide(width: 0, color: Colors.white)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: new Icon(
          Icons.logout,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () => logout(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 50,
        ),
        backgroundColor: Colors.white,
        actions: [_disconnect()],
        centerTitle: false,
      ),
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
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              // showSelectedLabels: false,
              // showUnselectedLabels: false,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  label: "Accueil",
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.today),
                  label: "Agenda",
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.groups),
                  label: "Mes Groupes",
                ),
                BottomNavigationBarItem(
                    icon: new Icon(Icons.person), label: "Mon compte")
              ],
            ),
          )),
    );
  }
}
