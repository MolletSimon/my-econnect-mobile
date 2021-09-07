import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/api.dart';
import 'package:my_econnect/models/posts/group.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;
import 'package:my_econnect/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [];
  late User currentUser;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "null";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    currentUser = User.oneUser(decodedToken);
    _getPosts(currentUser);
  }

  void checkIfUserLiked() {
    if (this.currentUser.id != "") {
      posts.forEach((post) {
        if (post.liked.isNotEmpty) {
          post.liked.forEach((like) {
            if (like.id == this.currentUser.id) {
              setState(() {
                post.userLiked = true;
              });
            }
          });
        }
      });
    } else {
      checkIfUserLiked();
    }
  }

  void _getPictures() async {
    posts.forEach((post) {
      Api().getPictures(post.user).then((value) => {
            setState(() {
              post.user.picture = jsonDecode(value!.body)[0]['img'];
            })
          });
    });
  }

  Future<void> _getPosts(user) async {
    Api().getPosts(user).then((value) {
      setState(() {
        posts = Post.postsList(jsonDecode(value!.body));
      });
      _getPictures();
      checkIfUserLiked();
    });
  }

  void _like(Post post) {
    UserPost.User userWhoLiked = new UserPost.User(
        firstname: currentUser.firstname,
        lastname: currentUser.lastname,
        id: currentUser.id);

    if (post.userLiked) {
      setState(() {
        post.liked.removeWhere((element) => element.id == userWhoLiked.id);
        post.userLiked = false;
      });
    } else {
      setState(() {
        post.liked.add(userWhoLiked);
        post.userLiked = true;
      });
    }

    Api().like(post).then((value) => {
          if (value!.statusCode == 201) {checkIfUserLiked()}
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

  Container _buttons(Post post) {
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _like(post);
            },
            icon: post.userLiked
                ? Icon(Icons.thumb_up)
                : Icon(Icons.thumb_up_outlined),
            color: Color(0xFF23439B),
          ),
          if (post.liked.isNotEmpty)
            Expanded(
              child: Wrap(children: [
                _liked(post.liked[0], post.liked.length),
              ]),
            )
        ],
      ),
    );
  }

  Container _liked(UserPost.User user, int length) {
    if (length == 1) {
      return Container(
        child: Text(user.firstname + ' ' + user.lastname + ' a aimé ceci'),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(user.firstname +
            ' ' +
            user.lastname +
            ' et ' +
            length.toString() +
            ' autres personnes ont aimés ceci'),
      );
    }
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
                  radius: 25,
                  backgroundImage: post.user.picture!.isEmpty
                      ? Image.asset('assets/images/PHUser.png').image
                      : MemoryImage(base64Decode(post.user.picture!)),
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
      width: MediaQuery.of(context).size.width,
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
      width: MediaQuery.of(context).size.width,
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
        subtitle: Column(
          children: [
            post.isPoll ? _poll(post) : _content(post),
            _buttons(post),
          ],
        ),
      );

  ListView _postsListView(data) {
    if (data == null) {
      return ListView();
    }
    return ListView.builder(
      // shrinkWrap: true,
      // scrollDirection: Axis.vertical,
      // physics: const NeverScrollableScrollPhysics(),
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
      child: Column(
        children: <Widget>[
          _inputPost(),
          posts.isEmpty
              ? (CircularProgressIndicator())
              : Expanded(
                  child: (RefreshIndicator(
                    child: _postsListView(posts),
                    onRefresh: _getCurrentUser,
                  )),
                )
        ],
      ),
    );
  }
}
