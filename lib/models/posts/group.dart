class Group {
  final String? color;
  final String? name;
  final String? id;

  Group({
    this.id,
    this.color,
    this.name,
  });

  //Method
  static List<Group> groupsList(List<dynamic> body) {
    List<Group> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      Group post = Group(
        id: value["_id"],
        color: value["color"],
        name: value["name"],
      );
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
