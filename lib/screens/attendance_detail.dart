import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stepteacher/models/attendance_model.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final Attendance attendance;
  const AttendanceDetailScreen({Key? key, required this.attendance})
      : super(key: key);

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(widget.attendance.date ?? 'Attendace'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.attendance.description ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text(
                'Attendance will end on ${DateFormat.yMMMMd().format(DateTime.parse(widget.attendance.edate!))} at ${widget.attendance.etime!}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 18),
              Text(
                'Present',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 18),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.attendance.studentAttendances?.length,
                itemBuilder: (BuildContext context, int index) {
                  var studentAssignment =
                      widget.attendance.studentAttendances![index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        studentAssignment.name!,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
