import 'package:my_econnect/models/posts/answers.dart';

class Poll {
  final List<Answer>? answers;
  final String? content;
  bool? hasVoted;

  Poll({
    this.answers,
    this.content,
    this.hasVoted,
  });

  Map toJson() => {
        'answers': answers,
        'content': content,
        'hasVoted': hasVoted,
      };

  //Method
  static List<Poll> pollsList(List<dynamic> body) {
    List<Poll> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      Poll post = Poll(
        answers: Answer.answersList(value["answers"]),
        content: value["content"],
        hasVoted: value["hasVoted"],
      );
      l.add(post);
    });

    return l;
  }

  static Poll onePoll(Map<String, dynamic> body) {
    Poll poll = new Poll(
      answers: Answer.answersList(body["answers"]),
      content: body["content"],
      hasVoted: body["hasVoted"],
    );
    return poll;
  }
}
