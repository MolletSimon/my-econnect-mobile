import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/services/apiService.dart';
import 'package:my_econnect/models/posts/group.dart';
import 'package:my_econnect/models/user.dart';
import 'package:my_econnect/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupsPage extends StatefulWidget {
  GroupsPage({Key? key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  late User currentUser;
  List<Group> groups = [];

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    }

    return Colors.white;
  }

  Container _responsable(Group group) {
    Color color = colorConvert('64' + group.color);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      margin: EdgeInsets.only(right: 8, top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              group.responsable!.firstname +
                  ' ' +
                  group.responsable!.lastname +
                  ' - ' +
                  group.responsable!.phone,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "null";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    currentUser = User.oneUser(decodedToken);

    _getGroups();
  }

  Future<void> _getGroups() async {
    UserService().getGroups(currentUser).then((value) => {
          if (value!.statusCode == 200)
            {
              setState(() {
                groups = Group.groupsList(jsonDecode(value.body));
              })
            }
        });
  }

  Container _card(Group group, index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorConvert('78' + group.color),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            Text(
              group.name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontStyle: FontStyle.italic,
              ),
            ),
            _responsable(group)
          ],
        ),
      ),
    );
  }

  ListView _groupsListView(data) {
    if (data == null) {
      return ListView();
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _card(data[index], index),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  'Vous faites partie du/des groupe(s) suivants',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF23439B),
                    fontSize: 17,
                  ),
                ),
              ),
              groups.isEmpty
                  ? (CircularProgressIndicator())
                  : Expanded(
                      child: _groupsListView(groups),
                    ),
            ],
          ),
        ));
  }
}
