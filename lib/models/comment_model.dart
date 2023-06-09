import 'package:stepteacher/models/user_model.dart';

class Comment {
  int? id;
  String? body;
  String? created;
  User? user;
  int? commentCount;

  Comment({
    this.id,
    this.body,
    this.created,
    this.user,
    this.commentCount,
  });

  // map json to comment model
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      body: json['body'],
      created: json['created_at'],
      user: User(
        id: json['user']['id'],
        name: json['user']['full_name'],
        avatar: json['user']['avatar'],
      ),
      commentCount: json['comment_count'],
    );
  }
}
