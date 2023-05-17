class Topic {
  int? id;
  String? name;

  Topic({
    this.name,
    this.id,
  });

  // function to convert json data to user model
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
    );
  }
}
