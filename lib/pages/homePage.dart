
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_econnect/models/route.dart';
import 'package:my_econnect/pages/agendaPage.dart';
import 'package:my_econnect/pages/feedPage.dart';
import 'package:my_econnect/pages/groupsPage.dart';
import 'package:my_econnect/pages/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {    
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) => {
      if(message!=null) {
        print(message)
      }
    });
  }

  final List<Widget> _children = [
    FeedPage(),
    AgendaPage(),
    PostPage(),
    GroupsPage(),
    Container(
      child: Text("L'application est encore en cours de développement et cette fonctionnalité n'est pas encore disponible. Merci d'utiliser le site my-connect.fr pour utiliser ces fonctionnalités."),
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
      width: 35,
      margin: EdgeInsets.fromLTRB(0, 5, 25, 5),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
          side: MaterialStateProperty.all(
              BorderSide(width: 0, color: Colors.white)),
          backgroundColor: MaterialStateProperty.all(Color(0xFF23439B)),
        ),
        child: new Icon(
          Icons.logout,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => logout(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(event.notification!.body.toString()),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                margin: EdgeInsets.only(bottom: 10, left: 3, right: 3),
                backgroundColor: Color(0xFF23439B),
              ));
    });
    return GestureDetector(
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBar(
                elevation: 0,
                title: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                  ),
                ),
                backgroundColor: Color.fromARGB(248, 248, 249, 250),
                actions: [_disconnect()],
                centerTitle: false,
              ),
            ],
          ),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0)
              ),
              child: BottomNavigationBar(
                selectedFontSize: 10,
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                // showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: onTabTapped,
                items: [
                  
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.home),
                    label: "ACCUEIL",
                  ),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.today),
                    label: "AGENDA",
                  ),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.control_point), 
                    label: "NOUVEAU",),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.groups),
                    label: "MES GROUPES",
                  ),
                  BottomNavigationBarItem(
                      icon: new Icon(Icons.person), label: "MON COMPTE")
                ],
              ),
            )),
      ),
    );
  }
}
