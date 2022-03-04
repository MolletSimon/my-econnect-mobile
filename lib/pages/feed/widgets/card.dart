import 'package:flutter/material.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/user.dart';
import 'package:my_econnect/pages/feed/widgets/tile.dart';

class ConnectCard extends StatefulWidget {
  const ConnectCard({Key? key, required this.post, required this.user})
      : super(key: key);

  final User user;
  final Post post;
  @override
  State<ConnectCard> createState() => _ConnectCardState();
}

class _ConnectCardState extends State<ConnectCard> {
  @override
  Widget build(BuildContext context) {
    User currentUser = widget.user;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: new BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 211, 211, 211).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 4, 1, 1),
        child: Column(
          children: [
            ConnectTile(
              post: widget.post,
              user: currentUser,
            )
          ],
        ),
      ),
    );
  }
}
