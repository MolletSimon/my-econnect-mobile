import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/route.dart';

class Disconnect extends StatelessWidget {
  const Disconnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    logout() async {
      SharedPreferences prefs = await _prefs;
      prefs.setString("token", "");
      Navigator.of(context).pushNamed(RoutePaths.Login);
    }

    return Container(
      width: 35,
      margin: EdgeInsets.fromLTRB(0, 5, 25, 5),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
          side: MaterialStateProperty.all(
              BorderSide(width: 0, color: Colors.white)),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
        ),
        child: new Icon(
          Icons.logout,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => logout(),
      ),
    );
  }
}
