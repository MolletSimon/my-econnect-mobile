import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/api.dart';
import 'package:my_econnect/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<dynamic> posts = [];

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  void _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "null";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    User currentUser = User.oneUser(decodedToken);
    _getPosts(currentUser);
  }

  void _getPosts(user) {
    Api().getPosts(user).then((value) {
      setState(() {
        posts = jsonDecode(value!.body);
      });
    });
  }

  Container _card(dynamic post, index) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [_tile(post, index)],
      ),
    );
  }

  ListTile _tile(dynamic post, index) => ListTile(
        tileColor: Colors.grey[100],
        leading: CircleAvatar(
          backgroundColor: Colors.amber,
        ),
        title: Text(post['content']),
      );

  ListView _postsListView(data) {
    if (data == null) {
      return ListView();
    }

    return ListView.builder(
      shrinkWrap: true,
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

  Container _inputPost() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Écrivez quelque chose !',
          contentPadding: EdgeInsets.only(left: 25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _inputPost(),
          posts.isEmpty
              ? (CircularProgressIndicator())
              : (_postsListView(posts))
        ],
      ),
    );
  }
}
