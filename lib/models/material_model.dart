class TopicMaterial {
  int? id;
  String? title;

  TopicMaterial({
    this.id,
    this.title,
  });

  // map json to comment model
  factory TopicMaterial.fromJson(Map<String, dynamic> json) {
    return TopicMaterial(
      id: json['id'],
      title: json['title'],
    );
  }
}
