import 'package:flutter/material.dart';
import 'package:my_econnect/models/posts/poll.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/user.dart';
import 'package:my_econnect/pages/feed/widgets/buttons.dart';
import 'package:my_econnect/pages/feed/widgets/poll.dart';
import 'package:my_econnect/pages/feed/widgets/title.dart';

class ConnectTile extends StatefulWidget {
  const ConnectTile({Key? key, required this.post, required this.user})
      : super(key: key);
  final Post post;
  final User user;

  @override
  State<ConnectTile> createState() => _ConnectTileState();
}

class _ConnectTileState extends State<ConnectTile> {
  Container _content(Post post) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 2),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(post.content ?? "",
            style: Theme.of(context).primaryTextTheme.caption),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    User currentUser = widget.user;

    return ListTile(
      title: CardTitle(post: post),
      isThreeLine: true,
      subtitle: Column(
        children: [
          post.isPoll
              ? ConnectPoll(
                  post: post,
                  user: currentUser,
                )
              : _content(post),
          ConnectButtons(
            post: post,
            user: currentUser,
          ),
        ],
      ),
    );
    ;
  }
}
