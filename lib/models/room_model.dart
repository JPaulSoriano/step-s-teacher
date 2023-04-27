import 'user_model.dart';

class Room {
  int? id;
  String? name;
  String? section;
  String? key;
  String? vclink;

  Room({
    this.id,
    this.name,
    this.section,
    this.key,
    this.vclink,
  });

// map json to post model

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      section: json['section'],
      key: json['key'],
      vclink: json['vc_link'],
    );
  }
}
