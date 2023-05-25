class Attendance {
  int? id;
  String? date;
  String? description;
  String? edate;
  String? etime;
  List<StudentAttendances>? studentAttendances;

  Attendance(
      {this.id,
      this.date,
      this.description,
      this.edate,
      this.etime,
      this.studentAttendances});

  // map json to comment model
  factory Attendance.fromJson(Map<String, dynamic> json) {
    List<StudentAttendances>? studentAttendances =
        (json['students'] as List<dynamic>)
            .map((e) => StudentAttendances.fromJson(e))
            .toList();
    return Attendance(
      id: json['id'],
      date: json['attendance_date'],
      description: json['description'],
      edate: json['expiry_date'],
      etime: json['expiry_time'],
      studentAttendances: studentAttendances,
    );
  }
}

class StudentAttendances {
  String? name;
  StudentAttendances({
    this.name,
  });
  factory StudentAttendances.fromJson(Map<String, dynamic> json) {
    return StudentAttendances(
      name: json['full_name'],
    );
  }
}
