import 'package:my_econnect/models/posts/group.dart';
import 'package:my_econnect/models/posts/poll.dart';
import 'package:my_econnect/models/posts/user.dart';

class Post {
  final String? content;
  final DateTime date;
  final List<Group> group;
  final bool? isPined;
  final bool isPoll;
  final List<User> liked;
  final User user;
  final String? id;
  final Poll? poll;

  Post(
      {this.id,
      this.content,
      required this.date,
      required this.group,
      this.isPined,
      required this.isPoll,
      required this.liked,
      required this.user,
      this.poll});

  //Method
  static List<Post> postsList(List<dynamic> body) {
    List<Post> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      Post post = Post(
          id: value["_id"],
          content: value["content"],
          date: DateTime.parse(value["date"]),
          group: Group.groupsList(value["group"]),
          isPined: value["isPined"],
          isPoll: value["isPoll"],
          liked: User.userList(value["liked"]),
          user: User.oneUser(value["user"]),
          poll: Poll.onePoll(value["poll"]));
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
