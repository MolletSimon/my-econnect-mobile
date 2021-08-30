import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // final String baseURL = "http://localhost:3000/api";
  final String baseURL = "http://localhost:3000";
  dynamic header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer',
  };

  Future<String> getPosts() async {
    http.post(Uri.parse(baseURL + '/post/get')).then((value) => print(value));
    return "salut";
  }
}
