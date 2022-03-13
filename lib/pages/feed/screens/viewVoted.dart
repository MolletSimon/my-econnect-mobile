import 'package:flutter/material.dart';
import 'package:my_econnect/models/posts/poll.dart';

class ViewPoll extends StatelessWidget {
  final Poll poll;
  const ViewPoll({Key? key, required this.poll}) : super(key: key);
  
  Text _textButton(context) {
    return Text(
      "Vous avez déjà voté sur pour ce sondage, cliquez ici pour voir les résultats.",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontStyle: FontStyle.italic
      ),
    );
  }
  
  MaterialPageRoute<Null> _openModal() {
    return MaterialPageRoute<Null>(
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
        fullscreenDialog: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(_openModal());
              },
              child: _textButton(context)
            ),
          )
        ],
      ),
    );
  }
}
