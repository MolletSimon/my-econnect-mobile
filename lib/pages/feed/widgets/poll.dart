import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_econnect/models/posts/poll.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:smart_select/smart_select.dart';

import '../../../models/user.dart';

class ConnectPoll extends StatefulWidget {
  const ConnectPoll({Key? key, required this.post, required this.user})
      : super(key: key);

  final Post post;
  final User user;

  @override
  State<ConnectPoll> createState() => _PollState();
}

class _PollState extends State<ConnectPoll> {
  _checkIfUserVoted(Poll poll, User user) {
    poll.hasVoted = false;
    for (var i = 0; i < poll.answers!.length; i++) {
      for (var k = 0; k < poll.answers![i].usersWhoVoted!.length; k++) {
        if (poll.answers![i].usersWhoVoted![k].id == user.id) {
          setState(() {
            poll.hasVoted = true;
          });
        }
      }
    }
  }

  SmartSelect<int> _votePanel(Poll poll, List<int> value) {
    return SmartSelect<int>.multiple(
      title: poll.content!,
      placeholder: 'Votez !',
      value: value,
      choiceType: S2ChoiceType.chips,
      modalType: S2ModalType.fullPage,
      choiceItems: poll.answers!
          .map((a) => S2Choice<int>(value: a.id, title: a.name!))
          .toList(),
      onChange: (state) => setState(() => value = state.value),
    );
  }

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    Poll poll = new Poll();
    User user = widget.user;
    if (post.isPoll) poll = post.poll!;
    List<int> value = [];

    _checkIfUserVoted(poll, user);
    print(poll.hasVoted);
    return Container(
        child: poll.hasVoted! ? Text("A voté !") : _votePanel(poll, value));
  }
}
