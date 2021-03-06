import 'dart:async';
import 'package:my_econnect/models/route.dart' as RouterApp;
import 'package:flutter/material.dart';
import 'package:my_econnect/pages/home/homePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

String? token;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterAppBadger.updateBadgeCount(1);
}

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    runApp(MyApp(prefs));
  }, (error, st) => print(error));
}

Map<int, Color> color = {
  50: Color.fromRGBO(35, 67, 155, .1),
  100: Color.fromRGBO(35, 67, 155, .2),
  200: Color.fromRGBO(35, 67, 155, .3),
  300: Color.fromRGBO(35, 67, 155, .4),
  400: Color.fromRGBO(35, 67, 155, .5),
  500: Color.fromRGBO(35, 67, 155, .6),
  600: Color.fromRGBO(35, 67, 155, .7),
  700: Color.fromRGBO(35, 67, 155, .8),
  800: Color.fromRGBO(35, 67, 155, .9),
  900: Color.fromRGBO(35, 67, 155, 1),
};

class MyApp extends StatelessWidget {
  MyApp(this.prefs);
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: MaterialColor(0xFF23439B, color),
          backgroundColor: Color.fromARGB(248, 248, 249, 250),
          focusColor: Color.fromARGB(255, 245, 245, 245),
          primaryColor: Color(0xFF23439B),
          fontFamily: 'Poppins',
          primaryTextTheme: const TextTheme(
            caption: TextStyle(
              color: Color.fromARGB(255, 90, 90, 90),
              fontSize: 14,
            ),
            headline6: TextStyle(
              color: Color(0xFF23439B),
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          )),
      // darkTheme: ThemeData(
      //     brightness: Brightness.dark,
      //     focusColor: Color.fromARGB(255, 131, 131, 131),
      //     primaryColor: Color.fromARGB(255, 113, 151, 255),
      //     backgroundColor: Color.fromARGB(255, 100, 100, 100),
      //     cardColor: Color.fromARGB(255, 87, 87, 87),
      //     primaryTextTheme: const TextTheme(
      //       caption: TextStyle(
      //         color: Color.fromARGB(255, 236, 236, 236),
      //         fontSize: 14,
      //       ),
      //     )),
      home: HomePage(),
      initialRoute: token == null || token!.isEmpty
          ? RouterApp.RoutePaths.Login
          : RouterApp.RoutePaths.Home,
      onGenerateRoute: RouterApp.Router.generateRoute,
    );
  }
}
