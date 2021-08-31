import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_econnect/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String baseURL = "https://api-my-connect.herokuapp.com";
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  dynamic header = {
    'Content-Type': 'application/json',
  };

  Future<Response?> getPosts(User user) async {
    SharedPreferences _prefs = await prefs;
    String token = _prefs.getString("token") ?? "null";

    if (token != "null" || token.isEmpty) {
      var ids = [];

      user.groups.forEach((group) {
        ids.add(group["_id"]);
      });

      var body = jsonEncode({"ids": ids, "isSuperadmin": user.isSuperadmin});

      var response = await http.post(Uri.parse(baseURL + '/post/get'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    }

    return null;
  }

  Future<Response> login(String username, String password) async {
    var response = await http.post(Uri.parse(baseURL + '/user/login'),
        headers: header,
        body: jsonEncode(
            <String, String>{"mail": username, "password": password}));
    if (response.statusCode == 201) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("token", jsonDecode(response.body)["token"]);
    }
    return response;
  }
}
