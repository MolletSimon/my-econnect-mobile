class User {
  final String firstname;
  final String lastname;
  final String? id;

  User({
    this.id,
    required this.firstname,
    required this.lastname,
  });

  //Method
  static List<User> userList(List<dynamic> body) {
    List<User> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      User post = User(
        id: value["_id"],
        firstname: value["firstname"],
        lastname: value["lastname"],
      );
      l.add(post);
    });

    return l;
  }

  static User oneUser(Map<String, dynamic> body) {
    User user = new User(
      id: body["_id"],
      firstname: body["firstname"],
      lastname: body["lastname"],
    );
    return user;
  }
}
