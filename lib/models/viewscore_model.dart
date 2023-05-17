class ViewScore {
  int? id;
  String? name;
  int? score;

  ViewScore({
    this.id,
    this.name,
    this.score,
  });

  factory ViewScore.fromJson(Map<String, dynamic> json) {
    return ViewScore(
      id: json['id'],
      name: json['full_name'],
      score: json['assessments'][0]['assessment']['score'],
    );
  }
}
