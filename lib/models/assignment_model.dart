class Assignment {
  int? id;
  String? title;
  int? points;
  int? submission;
  String? due;
  String? instructions;
  String? url;
  String? file;
  List<StudentAssignment>? studentAssignments;

  Assignment({
    this.id,
    this.title,
    this.points,
    this.submission,
    this.due,
    this.instructions,
    this.url,
    this.file,
    this.studentAssignments,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    List<StudentAssignment>? studentAssignments =
        (json['student_assignments'] as List<dynamic>)
            .map((e) => StudentAssignment.fromJson(e))
            .toList();
    return Assignment(
      id: json['id'],
      title: json['title'],
      points: json['points'],
      submission: json['allowed_submission'],
      due: json['due_date'],
      instructions: json['instructions'],
      url: json['url'],
      file: json['file'],
      studentAssignments: studentAssignments,
    );
  }
}

class StudentAssignment {
  String? Studentfile;
  String? Studenturl;
  String? created_at;
  String? name;
  StudentAssignment({
    this.Studentfile,
    this.Studenturl,
    this.created_at,
    this.name,
  });
  factory StudentAssignment.fromJson(Map<String, dynamic> json) {
    return StudentAssignment(
      Studentfile: json['file'],
      Studenturl: json['url'],
      created_at: json['created_at'],
      name: json['student']['full_name'],
    );
  }
}
