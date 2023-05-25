class SharedTopic {
  int? id;
  String? name;
  int? questionsCount;
  int? materialsCount;
  String? owner;

  SharedTopic({
    this.name,
    this.id,
    this.questionsCount,
    this.materialsCount,
    this.owner,
  });

  // function to convert json data to user model
  factory SharedTopic.fromJson(Map<String, dynamic> json) {
    return SharedTopic(
      id: json['id'],
      name: json['name'],
      questionsCount: json['questions_count'],
      materialsCount: json['materials_count'],
      owner: json['owner']['full_name'],
    );
  }
}
