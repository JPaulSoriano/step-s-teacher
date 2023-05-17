class SharedTopic {
  int? id;
  String? name;

  SharedTopic({
    this.name,
    this.id,
  });

  // function to convert json data to user model
  factory SharedTopic.fromJson(Map<String, dynamic> json) {
    return SharedTopic(
      id: json['id'],
      name: json['name'],
    );
  }
}
