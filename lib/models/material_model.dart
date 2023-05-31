class TopicMaterial {
  int? id;
  String? title;
  String? description;

  TopicMaterial({
    this.id,
    this.title,
    this.description,
  });

  // map json to comment model
  factory TopicMaterial.fromJson(Map<String, dynamic> json) {
    return TopicMaterial(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
