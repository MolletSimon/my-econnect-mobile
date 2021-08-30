import 'dart:async';
import 'package:my_econnect/models/route.dart' as RouterApp;
import 'package:flutter/material.dart';
import 'package:my_econnect/pages/homePage.dart';
import 'package:my_econnect/pages/loginPage.dart';
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
      home: MyHomePage(prefs: prefs),
      initialRoute: token == null || token!.isEmpty
          ? RouterApp.RoutePaths.Login
          : RouterApp.RoutePaths.Home,
      onGenerateRoute: RouterApp.Router.generateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.prefs}) : super(key: key);

  final SharedPreferences prefs;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  logout() async {
    var prefs = widget.prefs;
    prefs.setString("token", "");
    Navigator.of(context).pushNamed(RouterApp.RoutePaths.Login);
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
        title: Text("My Connect"),
        backgroundColor: Colors.white,
        actions: [_disconnect()],
        centerTitle: false,
      ),
    );
  }
}
