class User {
  final String firstname;
  final String lastname;
  final String? id;
  String? img;
  String phone;

  User({
    this.id,
    this.img,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  Map toJson() => {'firstname': firstname, 'lastname': lastname, 'id': id, 'img': img};

  //Method
  static List<User> userList(List<dynamic> body) {
    List<User> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      User post = User(
          id: value["id"],
          img: value["img"],
          firstname: value["firstname"],
          lastname: value["lastname"],
          phone: value["phone"] == null ? "" : value["phone"]);
      l.add(post);
    });

    return l;
  }

  static User oneUser(Map<String, dynamic> body) {
    User user = new User(
        id: body["id"],
        img: body["img"],
        firstname: body["firstname"],
        lastname: body["lastname"],
        phone: body["phone"] == null ? "" : body["phone"]);
    return user;
  }
}
