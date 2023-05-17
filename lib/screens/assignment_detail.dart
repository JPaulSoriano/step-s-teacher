import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stepteacher/models/assignment_model.dart';
import 'package:stepteacher/screens/create_room.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Assignment assignment;
  const AssignmentDetailScreen({Key? key, required this.assignment})
      : super(key: key);

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(widget.assignment.title?.isEmpty ?? true
            ? 'No Title'
            : widget.assignment.title!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.assignment.title?.isEmpty ?? true
                    ? 'No Title'
                    : widget.assignment.title!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text(
                'Due ${DateFormat.yMMMMd().format(DateTime.parse(widget.assignment.due!))}',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '${widget.assignment.points.toString()} Points',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Resubmission Count: ${widget.assignment.submission.toString()}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                '${widget.assignment.instructions!.replaceAll(RegExp('<p>|</p>|<br />'), '')}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 18),
              Divider(),
              SizedBox(height: 18),
              Text(
                'Attachments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    if (widget.assignment.url != null) {
                      downloadFile(widget.assignment.url!);
                    }
                  },
                  child: Text(widget.assignment.file ?? 'No Attachments'),
                ),
              ),
              Divider(),
              SizedBox(height: 18),
              Text(
                'Submitted',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 18),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.assignment.studentAssignments?.length,
                itemBuilder: (BuildContext context, int index) {
                  var studentAssignment =
                      widget.assignment.studentAssignments![index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        studentAssignment.name!,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentAssignment.Studentfile!,
                          ),
                          SizedBox(
                              height:
                                  5), // add some spacing between the subtitle and the new text
                          Text(
                            '${DateFormat.yMMMMd().format(DateTime.parse(studentAssignment.created_at!))}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
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

  Future<void> downloadFile(String url) async {
    // Check if permission is granted
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      // Request permission
      await Permission.storage.request();
    }
    try {
      var request = await http.get(Uri.parse(url));
      var bytes = request.bodyBytes;
      String fileName = url.split('/').last;
      String dir = '/storage/emulated/0/Download';
      File file = File('$dir/$fileName');
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${fileName} Downloaded Successfully'),
      ));
    } catch (e) {
      print(e);
    }
  }
}
