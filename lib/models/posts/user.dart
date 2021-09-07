class User {
  final String firstname;
  final String lastname;
  final String? id;
  String? picture;
  String? phone;

  User({
    this.id,
    this.picture,
    required this.firstname,
    required this.lastname,
    this.phone,
  });

  Map toJson() => {'firstname': firstname, 'lastname': lastname, '_id': id};

  //Method
  static List<User> userList(List<dynamic> body) {
    List<User> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      User post = User(
          id: value["_id"],
          picture: "",
          firstname: value["firstname"],
          lastname: value["lastname"],
          phone: value["phone"] == null ? "" : value["phone"]);
      l.add(post);
    });

    return l;
  }

  static User oneUser(Map<String, dynamic> body) {
    print(body.values);
    User user = new User(
        id: body["id"],
        picture: "",
        firstname: body["firstname"],
        lastname: body["lastname"],
        phone: body["phone"] == null ? "" : body["phone"]);
    return user;
  }
}
