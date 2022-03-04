import 'package:flutter/material.dart';

class ConnectPoll extends StatefulWidget {
  const ConnectPoll({Key? key}) : super(key: key);

  @override
  State<ConnectPoll> createState() => _PollState();
}

class _PollState extends State<ConnectPoll> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          "SONDAGE - La fonctionnalité n'est pas encore disponible sur cette version de l'application. Merci d'utiliser le site my-econnect.fr pour exploiter cette fonctionnalité.",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
