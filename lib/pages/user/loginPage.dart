import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_econnect/services/apiService.dart';
import 'package:my_econnect/models/route.dart';
import 'package:my_econnect/services/userService.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";
  bool loading = false;
  bool error = false;
  dynamic snackBar = SnackBar(content: Text(''));

  Container _email() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          username = value;
        },
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
        "Hello again !",
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
        onChanged: (value) {
          password = value;
        },
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
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ))),
        child: Text("Se connecter"),
        onPressed: () => {
          login(username, password),
        },
      ),
    );
  }

  Container _loading() {
    return Container(
      child: CircularProgressIndicator(),
      alignment: Alignment.center,
    );
  }

  login(username, password) {
    setState(() {
      loading = true;
    });
    UserService().login(username, password).then((value) => {
          if (value.statusCode == 401)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(jsonDecode(value.body)["message"]),
                backgroundColor: Colors.red[800],
              )),
              setState(() {
                loading = false;
                username = username;
              }),
            }
          else
            {
              setState(() {
                loading = false;
              }),
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Connect?? !'),
                backgroundColor: Colors.green[800],
              )),
              Navigator.of(context).pushReplacementNamed(RoutePaths.Home)
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? (_loading())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 150),
                child: Column(
                  children: [
                    _title(),
                    _email(),
                    _password(),
                    _loginButton(),
                  ],
                ),
              ),
            ),
    );
  }
}
