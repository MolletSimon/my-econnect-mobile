import 'package:my_econnect/models/posts/user.dart';

class Group {
  final String color;
  final String name;
  final String id;
  final User? responsable;

  Group(
      {required this.id,
      required this.color,
      required this.name,
      this.responsable});

  //Method
  static List<Group> groupsList(List<dynamic> body) {
    List<Group> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      Group post = Group(
          id: value["_id"],
          color: value["color"],
          name: value["name"],
          responsable: value["responsable"] == null
              ? null
              : User.oneUser(value["responsable"]));
      l.add(post);
    });

    return l;
  }

  // static User onePost(Map<String, dynamic> body) {
  //   User user = new User(
  //       id: body["_id"],
  //       firstname: body["firstname"].toString(),
  //       lastname: body["lastname"].toString(),
  //       groups: body["groups"],
  //       isSuperadmin: body["isSuperadmin"],
  //       mail: body["mail"],
  //       phone: body["phone"].toString());
  //   return user;
  // }
}
