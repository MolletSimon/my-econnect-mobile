import 'package:my_econnect/models/posts/group.dart';

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String mail;
  List<Group> groups;
  final bool isSuperadmin;
  final String phone;
  String? picture;

  User(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.groups,
      required this.isSuperadmin,
      required this.phone,
      required this.mail,
      this.picture});

  Map toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        '_id': id,
        'groups': groups,
        'isSuperadmin': isSuperadmin,
        'phone': phone,
        'mail': mail,
        'pictures': picture
      };

  //Method
  static List<User> userList(List<dynamic> body) {
    List<User> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      User user = User(
          id: value["_id"],
          firstname: value["firstname"],
          lastname: value["lastname"],
          groups: Group.groupsList(value["groups"]),
          isSuperadmin: value["isSuperadmin"],
          mail: value["mail"],
          picture: value["pictures"],
          phone: value["phone"].toString());
      l.add(user);
    });

    return l;
  }

  static User oneUser(Map<String, dynamic> body) {
    User user = new User(
        id: body["_id"],
        firstname: body["firstname"].toString(),
        lastname: body["lastname"].toString(),
        groups: Group.groupsList(body["groups"]),
        isSuperadmin: body["isSuperadmin"],
        mail: body["mail"],
        picture: body["pictures"],
        phone: body["phone"].toString());
    return user;
  }
}
