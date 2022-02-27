import 'package:my_econnect/models/posts/user.dart';

class Answer {
  final String? name;
  final int? nbVote;
  final int? id;
  final List<User>? usersWhoVoted;

  Answer({
    this.id,
    this.name,
    this.nbVote,
    this.usersWhoVoted,
  });

  //Method
  static List<Answer> answersList(List<dynamic> body) {
    List<Answer> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      Answer answer = Answer(
          name: value["name"],
          nbVote: value["nbVote"],
          id: value["id"],
          usersWhoVoted: User.userList(value["usersWhoVoted"]));
      l.add(answer);
    });

    return l;
  }
}
