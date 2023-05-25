class Question {
  int? id;
  String? name;

  Question({
    this.id,
    this.name,
  });

  // map json to comment model
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      name: json['question'],
    );
  }
}
