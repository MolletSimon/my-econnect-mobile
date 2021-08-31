import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/api.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [];

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
        posts = Post.postsList(jsonDecode(value!.body));
        posts.forEach((element) {
          print(element.content);
        });
      });
    });
  }

  Container _card(Post post, index) {
    return Container(
      child: Column(
        children: [_tile(post, index)],
      ),
    );
  }

  Container _title(Post post) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CircleAvatar(
                  backgroundColor: Colors.indigo[700],
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    post.user.firstname + ' ' + post.user.lastname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  post.date.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container _content(Post post) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          post.content ?? "",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Container _poll(Post post) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          "SONDAGE",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  ListTile _tile(Post post, index) => ListTile(
        title: _title(post),
        isThreeLine: true,
        subtitle: post.isPoll ? _poll(post) : _content(post),
      );

  ListView _postsListView(data) {
    if (data == null) {
      return ListView();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _card(data[index], index),
            const Divider(),
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
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _inputPost(),
          posts.isEmpty
              ? (CircularProgressIndicator())
              : (_postsListView(posts)),
        ],
      ),
    ));
  }
}
