import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
        children: [_inputPost()],
      ),
    );
  }
}
