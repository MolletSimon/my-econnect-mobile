import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:my_econnect/models/api.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var parser = EmojiParser();
  var finger = Emoji('finger', '✌🏻');
  Container _email() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Veuillez saisir votre identifiant',
          labelText: "Adresse email",
          contentPadding: EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
      ),
    );
  }

  Container _title() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Text(
        "Wesh !",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
        ),
      ),
    );
  }

  Container _password() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: 'Saisissez votre mot de passe !',
          labelText: "Mot de passe",
          contentPadding: EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(200),
          ),
        ),
      ),
    );
  }

  Container _loginButton() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all(EdgeInsets.fromLTRB(40, 20, 40, 20)),
        ),
        child: Text("Se connecter"),
        onPressed: () => {
          login("mollet.simon.pro@gmail.com", "yes"),
        },
      ),
    );
  }

  login(username, password) {
    Api().login(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _title(),
            _email(),
            _password(),
            _loginButton(),
          ],
        ),
      ),
    );
  }
}
