import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/posts/group.dart';
import 'package:my_econnect/models/posts/post.dart';

import 'package:my_econnect/models/user.dart';
import 'package:my_econnect/pages/feed/widgets/card.dart';
import 'package:my_econnect/pages/new-post/post.dart';
import 'package:my_econnect/services/postService.dart';
import 'package:my_econnect/services/userService.dart';
import 'package:my_econnect/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Utils utils = new Utils();

  List<Post> posts = [];
  List<Post> postsDisplayed = [];
  late User currentUser;
  bool filter = false;
  bool writing = false;

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

    UserService().getGroups(currentUser).then((value) => {
          if (value!.statusCode == 200)
            {
              if (mounted)
                {
                  setState(() {
                    currentUser.groups =
                        Group.groupsList(jsonDecode(value.body));
                  })
                }
            }
        });

    _getPosts(currentUser);
  }

  void checkIfUserLiked() {
    if (this.currentUser.id != "") {
      posts.forEach((post) {
        if (post.liked.isNotEmpty) {
          post.liked.forEach((like) {
            if (like.id == this.currentUser.id) {
              if (mounted) {
                setState(() {
                  post.userLiked = true;
                });
              }
            }
          });
        }
      });
    } else {
      checkIfUserLiked();
    }
  }

  Future<void> _getPosts(user) async {
    PostService().getPosts(user).then((value) {
      if (mounted) {
        setState(() {
          posts = Post.postsList(jsonDecode(value!.body));
          postsDisplayed = posts;
        });
      }
      checkIfUserLiked();
    });
  }

  void publish(String content) {
    if (content.isNotEmpty) {
      print(content);
    }
  }

  ListView _postsListView(List<Post> data) {
    if (data == null) {
      return ListView();
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ConnectCard(
              post: data[index],
              user: currentUser,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 0),
        child: Column(
          children: <Widget>[
            postsDisplayed.isEmpty
                ? (Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: (RefreshIndicator(
                      child: _postsListView(postsDisplayed),
                      onRefresh: _getCurrentUser,
                    )),
                  )
          ],
        ),
      ),
    );
  }
}
