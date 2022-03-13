import 'package:flutter/material.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;
import 'package:my_econnect/models/user.dart';
import 'package:my_econnect/services/postService.dart';
import 'package:my_econnect/services/userService.dart';

class ConnectButtons extends StatefulWidget {
  const ConnectButtons({Key? key, required this.post, required this.user})
      : super(key: key);
  final Post post;
  final User user;
  @override
  State<ConnectButtons> createState() => _ConnectButtonsState();
}

class _ConnectButtonsState extends State<ConnectButtons> {
  User currentUser = UserService().initEmptyUser();

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

  void _like(Post post) {
    UserPost.User userWhoLiked = new UserPost.User(
        firstname: currentUser.firstname,
        lastname: currentUser.lastname,
        phone: currentUser.phone,
        id: currentUser.id);

    if (post.userLiked) {
      if (mounted) {
        setState(() {
          post.liked.removeWhere((element) => element.id == userWhoLiked.id);
          post.userLiked = false;
        });
      }
    } else {
      setState(() {
        post.liked.add(userWhoLiked);
        post.userLiked = true;
      });
    }

    PostService().update(post, true, false).then((value) => {
          if (value!.statusCode == 201) {print('liked')}
        });
  }

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    currentUser = widget.user;

    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 209, 209, 209), width: 0.5))),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _like(post);
            },
            icon: post.userLiked
                ? Icon(Icons.thumb_up)
                : Icon(Icons.thumb_up_outlined),
            color: Theme.of(context).primaryColor,
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
    ;
  }
}
