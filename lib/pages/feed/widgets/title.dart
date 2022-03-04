import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_econnect/models/posts/group.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/utils/utils.dart';

class CardTitle extends StatefulWidget {
  const CardTitle({Key? key, required this.post}) : super(key: key);
  final Post post;
  @override
  State<CardTitle> createState() => _CardTitleState();
}

class _CardTitleState extends State<CardTitle> {
  Utils utils = new Utils();
  Container _tag(Group group) {
    Color color = utils.colorConvert('90' + group.color);

    return Container(
      height: 30,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Text(
              "@" + group.name.split(' ')[0],
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
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
                  radius: 20,
                  backgroundImage: post.user.picture!.isEmpty
                      ? Image.asset('assets/images/PHUser.png').image
                      : MemoryImage(base64Decode(post.user.picture!)),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        post.user.firstname + ' ' + post.user.lastname,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                                children:
                                    post.group.map((e) => _tag(e)).toList(),
                              )
                  ],
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
        ],
      ),
    );
    ;
  }
}
