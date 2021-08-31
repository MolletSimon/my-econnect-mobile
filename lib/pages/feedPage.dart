import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/api.dart';
import 'package:my_econnect/models/posts/group.dart';
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

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    }

    return Colors.white;
  }

  Container _card(Post post, index) {
    return Container(
      child: Column(
        children: [_tile(post, index)],
      ),
    );
  }

  Container _tag(Group group) {
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
              '@' + group.name,
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
                  backgroundColor: Colors.grey[100],
                  backgroundImage: NetworkImage(
                      'https://image.flaticon.com/icons/png/64/149/149071.png'),
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
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  DateFormat('dd/MM').format(post.date),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
          post.group.isEmpty
              ? Text('Pas de groupe')
              : post.group.length == 6
                  ? Row(
                      children: [
                        _tag(Group(
                            id: 'all',
                            name: 'Tous les groupes',
                            color: '#C5C6D0'))
                      ],
                    )
                  : Wrap(
                      children: post.group.map((e) => _tag(e)).toList(),
                    )
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
