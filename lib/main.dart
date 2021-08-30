import 'package:flutter/material.dart';
import 'package:my_econnect/pages/homePage.dart';
import 'package:my_econnect/pages/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String token = "";

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token")!;
  runApp(MyApp());
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
  // This widget is the root of your application.
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("My Connect"),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body:
          LoginPage(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
