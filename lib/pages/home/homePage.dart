import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_econnect/pages/agenda/agendaPage.dart';
import 'package:my_econnect/pages/feed/feedPage.dart';
import 'package:my_econnect/pages/groups/groupsPage.dart';
import 'package:my_econnect/pages/new-post/post.dart';
import './widgets/index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      "main_channel", "Man channel notif",
      importance: Importance.max);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      FlutterAppBadger.removeBadge();
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _setNotificationChannel();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_name');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) => {
              if (message != null) {print(message)}
            });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _setNotificationChannel() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  color: Theme.of(context).primaryColor,
                  priority: Priority.high,
                  importance: Importance.high
                  // other properties...
                  ),
            ));
      }
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
