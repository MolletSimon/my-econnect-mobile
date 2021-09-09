import 'dart:async';
import 'package:my_econnect/models/route.dart' as RouterApp;
import 'package:flutter/material.dart';
import 'package:my_econnect/pages/homePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
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
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: [const Locale('fr', '')],
      // locale: const Locale('fr'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(0xFF23439B, color),
          primaryColor: Color(0xFF23439B),
          fontFamily: 'Poppins',
          primaryTextTheme: const TextTheme(
            headline6: TextStyle(
              color: Color(0xFF23439B),
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          )),
      home: HomePage(),
      initialRoute: token == null || token!.isEmpty
          ? RouterApp.RoutePaths.Login
          : RouterApp.RoutePaths.Home,
      onGenerateRoute: RouterApp.Router.generateRoute,
    );
  }
}
