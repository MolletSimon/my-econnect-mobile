import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String baseURL = "https://api-my-connect.herokuapp.com";
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  dynamic header = {
    'Content-Type': 'application/json',
  };

  Future<String> getPosts() async {
    http.post(Uri.parse(baseURL + '/post/get')).then((value) => print(value));
    return "salut";
  }

  Future<Response> login(String username, String password) async {
    var response = await http.post(Uri.parse(baseURL + '/user/login'),
        headers: header,
        body: jsonEncode(
            <String, String>{"mail": username, "password": password}));
    return response;
  }
}
