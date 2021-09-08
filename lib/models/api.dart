import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;
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
        ids.add(group.id);
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

  Future<Response?> getGroups(User user) async {
    SharedPreferences _prefs = await prefs;
    String token = _prefs.getString("token") ?? "null";

    if (token != "null" || token.isEmpty) {
      var body = jsonEncode({"groups": user.groups});

      var response = await http.post(Uri.parse(baseURL + '/group/getAll'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    }

    return null;
  }

  Future<Response?> like(Post post) async {
    SharedPreferences _prefs = await prefs;
    String token = _prefs.getString("token") ?? "null";

    var body = jsonEncode(<String, List<UserPost.User>>{'liked': post.liked});

    if (token != "null" || token.isEmpty) {
      var response = await http.put(
          Uri.parse(baseURL + '/post/update/' + post.id.toString()),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    }

    return null;
  }

  Future<Response?> getPictures(UserPost.User user) async {
    SharedPreferences _prefs = await prefs;
    String token = _prefs.getString("token") ?? "null";

    var id = user.id ?? "";
    if (token != "null" || token.isEmpty) {
      var response = await http
          .get(Uri.parse(baseURL + '/user/get/picture/' + id), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      });
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
