import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'apiService.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;
import '../models/posts/post.dart';

class PostService {
  Future<Response?> getPosts(User user) async {
    SharedPreferences _prefs = await ApiService().prefs;
    String token = _prefs.getString("token") ?? "null";

    if (token != "null" || token.isEmpty) {
      var ids = [];

      user.groups.forEach((group) {
        ids.add(group.id);
      });

      var body = jsonEncode({"ids": ids, "isSuperadmin": user.isSuperadmin});

      var response =
          await http.post(Uri.parse(ApiService().baseURL + '/post/get'),
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
    SharedPreferences _prefs = await ApiService().prefs;
    String token = _prefs.getString("token") ?? "null";

    var body = jsonEncode(<String, List<UserPost.User>>{'liked': post.liked});

    if (token != "null" || token.isEmpty) {
      var response = await http.put(
          Uri.parse(
              ApiService().baseURL + '/post/update/' + post.id.toString()),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    }

    return null;
  }
}
