class Assessment {
  int? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? grading;
  String? exam_type;
  String? flow;
  String? status;
  int? duration;
  int? items;
  int? passing_score;
  int? questionCount;

  Assessment({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.grading,
    this.exam_type,
    this.flow,
    this.status,
    this.duration,
    this.items,
    this.passing_score,
    this.questionCount,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['assessment_dates'][0]['start_date'],
      endDate: json['assessment_dates'][0]['end_date'],
      grading: json['grading'],
      exam_type: json['exam_type'],
      flow: json['flow'],
      status: json['status'],
      duration: json['duration'],
      items: json['items'],
      passing_score: json['passing_score'],
      questionCount: json['questions_count'],
    );
  }
}
