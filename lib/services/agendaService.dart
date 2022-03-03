import 'dart:convert';

import 'package:http/http.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'apiService.dart';

class AgendaService {
  String url = ApiService().baseURL + "/appointment";

  Future<Response?> getAppointments(User user) async {
    SharedPreferences _prefs = await ApiService().prefs;
    String token = _prefs.getString("token") ?? "null";

    if (token != "null" || token.isEmpty) {
      var body = jsonEncode({"groups": user.groups});
      var response = await http.post(Uri.parse(url + '/getAll'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body);
      return response;
    }
  }
}
