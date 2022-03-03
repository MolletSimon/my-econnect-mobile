import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/api.dart';
import 'package:my_econnect/models/posts/group.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;
import 'package:my_econnect/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPage extends StatefulWidget {
  PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Group> groupsSelected = [];
  User currentUser = new User(id: "id", firstname: "Utilisateur", lastname: "", groups: [new Group(color: '', id: '', name: 'groupe')], isSuperadmin: false, phone: "", mail: "");
  String dropdownValue = '';
  String content = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _getCurrentUser();
      dropdownValue = currentUser.groups[0].name;
    });
  }

    Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "null";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    currentUser = User.oneUser(decodedToken);

    if (currentUser.isSuperadmin) {
      Api().getGroups(currentUser).then((value) => {
            if (value!.statusCode == 200)
              {
                if (mounted)
                  {
                    setState(() {
                      currentUser.groups =
                          Group.groupsList(jsonDecode(value.body));
                      dropdownValue = currentUser.groups[0].name;
                    })
                  }
              }
          });
    }
  }

  void _getPicture() {
    Api()
        .getPictures(UserPost.User(
            firstname: currentUser.firstname,
            lastname: currentUser.lastname,
            id: currentUser.id,
            phone: currentUser.phone,
            picture: ""))
        .then((value) => {
              setState(() {
                currentUser.picture = jsonDecode(value!.body)[0]['img'];
              })
            });
  }

  void _addGroup(Group group) {
    if (groupsSelected.isNotEmpty) {
      if (!groupsSelected.contains(group)) {
        setState(() {
          groupsSelected.add(group);
        });
      }
    } else {
      groupsSelected.add(group);
    }
  }

  Container _profilePicture() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.grey[100]),
      child: CircleAvatar(
          radius: 25,
          backgroundImage: MemoryImage(base64.decode(currentUser.picture!))),
    );
  }

  Container _user() {
    return Container(
      child: Row(
        children: [
          if (currentUser.picture != null) _profilePicture(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15, bottom: 20),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        currentUser.firstname + ' ' + currentUser.lastname,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Align(
                    child: currentUser.isSuperadmin
                        ? Text(
                            'SUPER ADMINISTRATEUR',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF23439B),
                            ),
                          )
                        : Text('Membre'),
                    alignment: Alignment.topLeft,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
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

  Align _groupsPost() {
    if (currentUser.groups.isNotEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.grey[100]),
            margin: EdgeInsets.only(top: 15),
            child: DropdownButton(
              value: dropdownValue,
              underline: SizedBox(),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value ?? "";
                  _addGroup(currentUser.groups
                      .where((element) => element.name == value)
                      .first);
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Vous venez de choisir un groupe, pour le retirer de votre post, appuyez sur le groupe à supprimer !'),
                  backgroundColor: Colors.blue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  behavior: SnackBarBehavior.floating,
                ));
              },
              icon: Icon(Icons.keyboard_arrow_down),
              hint: Text('Sélectionnez un groupe'),
              items: currentUser.groups.map((e) {
                return DropdownMenuItem(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                      child: Text(
                        e.name,
                        style: TextStyle(
                            color: colorConvert(e.color),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  value: e.name,
                );
              }).toList(),
            )),
      );
    }

    return Align();
  }

  Container _publishButton() {
    return Container(
        margin: EdgeInsets.only(top: 15),
        child: ElevatedButton(
          child: Icon(
            Icons.send,
          ),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            primary: Color(0xFF23439B), // <-- Button color
            onPrimary: Colors.white, // <-- Splash color
          ),
          onPressed: () {
            print(content);
          },
        ));
  }

  Container _groupsSelected() {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          children: groupsSelected.map((e) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  groupsSelected.remove(currentUser.groups
                      .where((element) => element.id == e.id)
                      .first);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorConvert('78' + e.color),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                margin: EdgeInsets.only(bottom: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 3, bottom: 3),
                  child: Column(
                    children: [
                      Text(
                        e.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                
                TextField(
                  onChanged: (value) {
                    setState(() {
                      content = value;
                    });
                  },
                  // keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onEditingComplete: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      groupsSelected = [];
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Écrivez quelque chose !',
                    contentPadding: EdgeInsets.only(left: 25, bottom: 25),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: _groupsPost(),
                      flex: 8,
                    ),
                    Flexible(child: _publishButton(), flex: 2)
                  ],
                ),
                if (groupsSelected.isNotEmpty) _groupsSelected(),
                Expanded(child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                ))
              ],
            ),
          ),
        ));
  }
}
