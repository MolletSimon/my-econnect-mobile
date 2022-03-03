import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseURL = "https://api-my-connect.herokuapp.com";
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  dynamic header = {
    'Content-Type': 'application/json',
  };
}
