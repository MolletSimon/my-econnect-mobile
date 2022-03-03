import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/posts/group.dart';
import '../models/user.dart';
import 'apiService.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;

class UserService {
  Future<Response> login(String username, String password) async {
    var response = await http.post(
        Uri.parse(ApiService().baseURL + '/user/login'),
        headers: ApiService().header,
        body: jsonEncode(
            <String, String>{"mail": username, "password": password}));
    if (response.statusCode == 201) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("token", jsonDecode(response.body)["token"]);

      Map<String, dynamic> decodedToken = JwtDecoder.decode(response.body);
      User currentUser = User.oneUser(decodedToken);

      await subscribeToTopic(currentUser);
    }
    return response;
  }

  Future<void> subscribeToTopic(User currentUser) async {
    if (currentUser.isSuperadmin) {
      await FirebaseMessaging.instance
          .subscribeToTopic('60ce71b2a9392e00158655b3');
      await FirebaseMessaging.instance
          .subscribeToTopic('60ce71f3a9392e00158655b4');
      await FirebaseMessaging.instance
          .subscribeToTopic('60ce724aa9392e00158655b5');
      await FirebaseMessaging.instance
          .subscribeToTopic('60ce727ba9392e00158655b6');
      await FirebaseMessaging.instance
          .subscribeToTopic('60ce729aa9392e00158655b7');
      await FirebaseMessaging.instance
          .subscribeToTopic('60ce72bca9392e00158655b8');
    }
  }

  User initEmptyUser() {
    return new User(
        id: "id",
        firstname: "Utilisateur",
        lastname: "",
        groups: [new Group(color: '', id: '', name: 'groupe')],
        isSuperadmin: false,
        phone: "",
        mail: "");
  }

  Future<Response?> getGroups(User user) async {
    SharedPreferences _prefs = await ApiService().prefs;
    String token = _prefs.getString("token") ?? "null";

    if (token != "null" || token.isEmpty) {
      var body = jsonEncode({"groups": user.groups});

      var response =
          await http.post(Uri.parse(ApiService().baseURL + '/group/getAll'),
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
    SharedPreferences _prefs = await ApiService().prefs;
    String token = _prefs.getString("token") ?? "null";

    var id = user.id ?? "";
    if (token != "null" || token.isEmpty) {
      var response = await http.get(
          Uri.parse(ApiService().baseURL + '/user/get/picture/' + id),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          });
      return response;
    }

    return null;
  }
}
