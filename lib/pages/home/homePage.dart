import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_econnect/pages/agenda/agendaPage.dart';
import 'package:my_econnect/pages/feedPage.dart';
import 'package:my_econnect/pages/groupsPage.dart';
import 'package:my_econnect/pages/post.dart';
import './widgets/index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) => {
              if (message != null) {print(message)}
            });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    FeedPage(),
    AgendaPage(),
    PostPage(),
    GroupsPage(),
    Container(
      child: Text(
          "L'application est encore en cours de développement et cette fonctionnalité n'est pas encore disponible. Merci d'utiliser le site my-connect.fr pour utiliser ces fonctionnalités."),
    )
  ];

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(event.data["body"]),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        margin: EdgeInsets.only(bottom: 10, left: 3, right: 3),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    });
    return GestureDetector(
        child: Scaffold(
      extendBody: true,
      appBar: Appbar(),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        parentAction: _onTabTapped,
        currentIndex: _currentIndex,
      ),
    ));
  }
}
