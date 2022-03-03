import 'package:flutter/material.dart';
import 'package:my_econnect/pages/home/homePage.dart';
import 'package:my_econnect/pages/loginPage.dart';

class RoutePaths {
  static const Login = 'loginPage';
  static const Home = 'homePage';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => HomePage());

      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
