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
  // scroll controller
  late ScrollController _scrollController;
  bool _showBackToTopButton = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() {
      setState(() {
        if (_scrollController.offset >= 400) {
          _showBackToTopButton = true; // show the back-to-top button
        } else {
          _showBackToTopButton = false; // hide the back-to-top button
        }
      });
    });
    _getCurrentUser();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
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

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
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

  ListView _postsListView(List<Post> data) {
    if (data == null) {
      return ListView();
    }
    return ListView.builder(
      itemCount: data.length,
      controller: _scrollController,
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
