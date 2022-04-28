import 'package:flutter/material.dart';
import 'package:my_econnect/models/posts/poll.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;
import 'package:my_econnect/services/postService.dart';
import 'package:my_econnect/pages/feed/screens/viewVoted.dart';
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

  SmartSelect<int> _votePanel(Poll poll, List<int> value, Post post, User user) {
    return SmartSelect<int>.multiple(
      title: poll.content!,
      placeholder: 'Votez !',
      value: value,
      choiceType: S2ChoiceType.checkboxes,
      modalConfig: S2ModalConfig(
        confirmIcon: const Icon(Icons.send),
        useConfirm: true,
        confirmColor: Theme.of(context).primaryColor
      ),
      modalType: S2ModalType.fullPage,
      choiceItems: poll.answers!
          .map((a) => S2Choice<int>(value: a.id, title: a.name!))
          .toList(),
      onChange: (state) => setState(() => {value = state.value, vote(value, poll, post, user)}),
    );
  }

  void vote(List<int> value, Poll poll, Post post, User user) {
    UserPost.User userPost = new UserPost.User(firstname: user.firstname, lastname: user.lastname, phone: user.phone, id: user.id);
    Post newPost = post;
    value.forEach((element) {
      newPost.poll!.answers!.forEach((answer) {
        if (element == answer.id) {
          answer.usersWhoVoted!.add(userPost);
          answer.nbVote++;
        }
      });
    });
    PostService().update(newPost, false, true).then((value) =>
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Merci de votre vote !"),
          backgroundColor: Theme.of(context).primaryColor,
      ))
    });
  }

  Container _viewUsersVoted(Poll poll) {
    return Container(
      child: Row(
        children: [
          Flexible(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(),
                        body: Center(
                          child: Container(
                            child: ListView.builder(
                                itemCount: poll.answers!.length,
                                itemBuilder: (context, position) {
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: Text(poll.answers![position].name!)),
                                        if (poll.answers![position].usersWhoVoted!.length > 0)
                                        Container(
                                          child: TextButton(
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                builder: (BuildContext context) {
                                                  return ListView.builder(
                                                    itemCount: poll.answers![position].usersWhoVoted!.length,
                                                    itemBuilder: (context, pos) {
                                                      return Card(
                                                        margin: const EdgeInsets.only(right: 20, left: 20, top: 10),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(20.0),
                                                          child: Row(
                                                            children: [
                                                              Text(poll.answers![position].usersWhoVoted![pos].firstname),
                                                              Text(" " + poll.answers![position].usersWhoVoted![pos].lastname.toUpperCase(),
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              );
                                            },
                                            child: Row(children: [
                                              Text("Les votants (" + poll.answers![position].usersWhoVoted!.length.toString() + ")"),
                                              Icon(Icons.arrow_forward_ios)
                                            ],),),
                                        )
                                      ],
                                    ),
                                  );
                                })
                          ),
                        ),
                      );
                    },
                    fullscreenDialog: true));
              },
              child: Text(
                "Vous avez déjà voté sur pour ce sondage, cliquez ici pour voir les résultats.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic
                ),
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
    Poll poll = new Poll();
    User user = widget.user;
    if (post.isPoll) poll = post.poll!;
    List<int> value = [];

    _checkIfUserVoted(poll, user);
    return Container(
        child: poll.hasVoted! ? ViewPoll(poll: poll) : _votePanel(poll, value, post, user));
  }
}