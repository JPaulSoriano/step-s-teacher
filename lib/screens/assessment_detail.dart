import 'package:flutter/material.dart';
import 'package:stepteacher/models/assessment_model.dart';

class AssessmentDetailScreen extends StatefulWidget {
  final Assessment assessment;
  const AssessmentDetailScreen({Key? key, required this.assessment})
      : super(key: key);

  @override
  State<AssessmentDetailScreen> createState() => _AssessmentDetailScreenState();
}

class _AssessmentDetailScreenState extends State<AssessmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(widget.assessment.title?.isEmpty ?? true
            ? 'No Title'
            : widget.assessment.title!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.assessment.title ?? 'No Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Text(
                widget.assessment.status ?? '',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Due: ${widget.assessment.endDate!}',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '${widget.assessment.grading} | ${widget.assessment.exam_type} | ${widget.assessment.flow}',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '${widget.assessment.duration} Minutes | ${widget.assessment.items} Items | ${widget.assessment.passing_score}% Passing Score',
                style: TextStyle(color: Colors.grey),
              ),
              Divider(),
              Text(
                widget.assessment.description ?? 'No Description',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
