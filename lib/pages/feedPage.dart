import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/services/apiService.dart';
import 'package:my_econnect/models/posts/group.dart';
import 'package:my_econnect/models/posts/post.dart';
import 'package:my_econnect/models/posts/user.dart' as UserPost;
import 'package:my_econnect/models/user.dart';
import 'package:my_econnect/pages/post.dart';
import 'package:my_econnect/services/postService.dart';
import 'package:my_econnect/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [];
  List<Post> postsDisplayed = [];
  late User currentUser;
  bool filter = false;
  bool writing = false;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "null";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    currentUser = User.oneUser(decodedToken);

    if (currentUser.isSuperadmin) {
      UserService().getGroups(currentUser).then((value) => {
            if (value!.statusCode == 200)
              {
                if (mounted)
                  {
                    setState(() {
                      currentUser.groups =
                          Group.groupsList(jsonDecode(value.body));
                    })
                  }
              }
          });
    }

    _getPosts(currentUser);
  }

  void checkIfUserLiked() {
    if (this.currentUser.id != "") {
      posts.forEach((post) {
        if (post.liked.isNotEmpty) {
          post.liked.forEach((like) {
            if (like.id == this.currentUser.id) {
              if (mounted) {
                setState(() {
                  post.userLiked = true;
                });
              }
            }
          });
        }
      });
    } else {
      checkIfUserLiked();
    }
  }

  void _getPictures() async {
    posts.forEach((post) {
      UserService().getPictures(post.user).then((value) => {
            if (mounted)
              {
                setState(() {
                  post.user.picture = jsonDecode(value!.body)[0]['img'];
                })
              }
          });
    });
  }

  Future<void> _getPosts(user) async {
    PostService().getPosts(user).then((value) {
      if (mounted) {
        setState(() {
          posts = Post.postsList(jsonDecode(value!.body));
          postsDisplayed = posts;
        });
      }
      // _getPictures();
      checkIfUserLiked();
    });
  }

  void _like(Post post) {
    UserPost.User userWhoLiked = new UserPost.User(
        firstname: currentUser.firstname,
        lastname: currentUser.lastname,
        phone: currentUser.phone,
        id: currentUser.id);

    if (post.userLiked) {
      if (mounted) {
        setState(() {
          post.liked.removeWhere((element) => element.id == userWhoLiked.id);
          post.userLiked = false;
        });
      }
    } else {
      setState(() {
        post.liked.add(userWhoLiked);
        post.userLiked = true;
      });
    }

    PostService().like(post).then((value) => {
          if (value!.statusCode == 201) {checkIfUserLiked()}
        });
  }

  void _displayFilters() {
    if (!filter) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 48.0, top: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: currentUser.groups
                      .map((group) => tileGroup(group))
                      .toList()),
            );
          });
    } else {
      setState(() {
        filter = false;
        postsDisplayed = posts;
      });
    }
  }

  void _filterGroups(Group group) {
    setState(() {
      filter = true;
      postsDisplayed = posts
          .where((p) => p.group.where((g) => g.id == group.id).isNotEmpty)
          .toList();
      print(postsDisplayed);
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "Vous venez de filtrer les posts par ${group.name} ! Pour désactiver le filtre, appuyez à nouveau sur l'entonnoir"),
      backgroundColor: Colors.blue[300],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void publish(String content) {
    if (content.isNotEmpty) {
      print(content);
    }
  }

  Container _cardGroup(Group group) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorConvert('78' + group.color),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            Text(
              group.name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector tileGroup(Group group) {
    return GestureDetector(
        onTap: () {
          _filterGroups(group);
        },
        child: _cardGroup(group));
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    }

    return Colors.white;
  }

  Container _card(Post post, index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          children: [_tile(post, index)],
        ),
      ),
    );
  }

  Container _buttons(Post post) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _like(post);
            },
            icon: post.userLiked
                ? Icon(Icons.thumb_up)
                : Icon(Icons.thumb_up_outlined),
            color: Color(0xFF23439B),
          ),
          if (post.liked.isNotEmpty)
            Expanded(
              child: Wrap(children: [
                _liked(post.liked[0], post.liked.length),
              ]),
            )
        ],
      ),
    );
  }

  Container _filters() {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: IconButton(
        icon: filter
            ? Icon(
                Icons.filter_alt,
                color: Color(0xFF23439B),
              )
            : Icon(
                Icons.filter_alt_outlined,
                color: Color(0xFF23439B),
              ),
        onPressed: _displayFilters,
      ),
    );
  }

  Container _liked(UserPost.User user, int length) {
    if (length == 1) {
      return Container(
        child: Text(user.firstname + ' ' + user.lastname + ' a aimé ceci'),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(user.firstname +
            ' ' +
            user.lastname +
            ' et ' +
            length.toString() +
            ' autres personnes ont aimés ceci'),
      );
    }
  }

  Container _tag(Group group) {
    Color color = colorConvert('90' + group.color);

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

  Container _title(Post post) {
    post.user.picture ??= "";
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
  }

  Container _content(Post post) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 2),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          post.content ?? "",
          style: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
        ),
      ),
    );
  }

  Container _poll(Post post) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15),
      color: Colors.grey[100],
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

  ListTile _tile(Post post, index) => ListTile(
        title: _title(post),
        isThreeLine: true,
        subtitle: Column(
          children: [
            post.isPoll ? _poll(post) : _content(post),
            _buttons(post),
          ],
        ),
      );

  ListView _postsListView(data) {
    if (data == null) {
      return ListView();
    }
    return ListView.builder(
      // shrinkWrap: true,
      // scrollDirection: Axis.vertical,
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _card(data[index], index),
          ],
        );
      },
    );
  }

  Container _inputPost() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: Column(
        children: [
          TextField(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PostPage()));
            },
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Écrivez quelque chose !',
              contentPadding: EdgeInsets.only(left: 25, bottom: 25),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 0),
        child: Column(
          children: <Widget>[
            postsDisplayed.isEmpty
                ? (CircularProgressIndicator())
                : Expanded(
                    child: (RefreshIndicator(
                      child: _postsListView(postsDisplayed),
                      onRefresh: _getCurrentUser,
                    )),
                  )
          ],
        ),
      ),
    );
  }
}
