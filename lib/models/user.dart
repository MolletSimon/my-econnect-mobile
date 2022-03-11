import 'package:my_econnect/models/posts/group.dart';

class User {
  final String id;
  final String firstname;
  final String lastname;
  final String mail;
  List<Group> groups;
  bool? isSuperadmin;
  final String phone;
  String? img;

  User(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.groups, this.isSuperadmin,
      required this.phone,
      required this.mail,
      this.img});

  Map toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        '_id': id,
        'groups': groups,
        'isSuperadmin': isSuperadmin,
        'phone': phone,
        'mail': mail,
        'img': img
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
          img: value["img"],
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
        img: body["img"],
        phone: body["phone"].toString());
    return user;
  }
}
