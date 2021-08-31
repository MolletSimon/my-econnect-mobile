class User {
  final String id;
  final String firstname;
  final String lastname;
  final String mail;
  final List<dynamic> groups;
  final bool isSuperadmin;
  final String phone;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.groups,
    required this.isSuperadmin,
    required this.phone,
    required this.mail,
  });

  //Method
  static List<User> userList(List<dynamic> body) {
    List<User> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      User user = User(
          id: value["_id"],
          firstname: value["firstname"],
          lastname: value["lastname"],
          groups: value["groups"],
          isSuperadmin: value["isSuperadmin"],
          mail: value["mail"],
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
        groups: body["groups"],
        isSuperadmin: body["isSuperadmin"],
        mail: body["mail"],
        phone: body["phone"].toString());
    return user;
  }
}
