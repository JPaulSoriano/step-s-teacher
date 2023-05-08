class Course {
  String? name;

  Course({this.name});

  // function to convert json data to user model
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'],
    );
  }
}
