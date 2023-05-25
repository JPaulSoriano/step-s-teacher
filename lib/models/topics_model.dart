class Topic {
  int? id;
  String? name;
  int? questionsCount;
  int? materialsCount;

  Topic({
    this.id,
    this.name,
    this.questionsCount,
    this.materialsCount,
  });

  // function to convert json data to user model
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      questionsCount: json['questions_count'],
      materialsCount: json['materials_count'],
    );
  }
}
