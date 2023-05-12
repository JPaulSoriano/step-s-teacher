import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/assessment_service.dart';
import 'package:stepteacher/services/assignment_service.dart';
import 'package:stepteacher/services/user_service.dart';

class CreateAssessmentForm extends StatefulWidget {
  final String? roomKey;
  CreateAssessmentForm({this.roomKey});

  @override
  _CreateAssessmentFormState createState() => _CreateAssessmentFormState();
}

class _CreateAssessmentFormState extends State<CreateAssessmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _start_dateController = TextEditingController();
  final TextEditingController _end_dateController = TextEditingController();
  final TextEditingController _gradingController = TextEditingController();
  final TextEditingController _exam_typeController = TextEditingController();
  final TextEditingController _flowController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _itemsController = TextEditingController();
  final TextEditingController _passing_scoreController =
      TextEditingController();
  static const List<String> Gradinglist = <String>[
    'prelim',
    'midterm',
    'semi',
    'finals'
  ];
  static const List<String> ExamTypelist = <String>[
    'exam',
    'long-quiz',
    'quiz',
    'seatwork',
    'homework'
  ];
  static const List<String> AssessmentTypelist = <String>[
    'several-pages',
    'standard',
    'per-page'
  ];

  String? gradingValue;
  String? exam_typeValue;
  String? assessment_typeValue;
  // create Assessment
  void _createAssessment() async {
    ApiResponse response = await createAssessment(
      widget.roomKey!,
      _titleController.text,
      _descriptionController.text,
      _start_dateController.text,
      _end_dateController.text,
      _gradingController.text,
      _exam_typeController.text,
      _flowController.text,
      _durationController.text,
      _itemsController.text,
      _passing_scoreController.text,
    );
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.data}'),
        ),
      );
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: new Text(
          'Create Assessment',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _titleController,
                  validator: (val) => val!.isEmpty ? 'Title Required' : null,
                  decoration: kInputDecoration('Title'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: (val) =>
                      val!.isEmpty ? 'Description Required' : null,
                  decoration: kInputDecoration('Description'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Date Format: 2023-01-31 00:00:00'),
                TextFormField(
                  controller: _start_dateController,
                  validator: (val) =>
                      val!.isEmpty ? 'Start Date Required' : null,
                  decoration: kInputDecoration('Start Date'),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _end_dateController,
                  validator: (val) => val!.isEmpty ? 'End Date Required' : null,
                  decoration: kInputDecoration('End Date'),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    value: gradingValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Grading Required';
                      }
                      return null;
                    },
                    decoration: kInputDecoration('Select Grading'),
                    onChanged: (String? newgradingValue) {
                      setState(() {
                        gradingValue = newgradingValue!;
                        _gradingController.text = gradingValue!;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    menuMaxHeight: 350.0,
                    items: Gradinglist.map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    value: assessment_typeValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Assessment Type Required';
                      }
                      return null;
                    },
                    decoration: kInputDecoration('Assessment Exam Type'),
                    onChanged: (String? newassessmenttypeValue) {
                      setState(() {
                        assessment_typeValue = newassessmenttypeValue!;
                        _flowController.text = assessment_typeValue!;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    menuMaxHeight: 350.0,
                    items: AssessmentTypelist.map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    value: exam_typeValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Exam Type Required';
                      }
                      return null;
                    },
                    decoration: kInputDecoration('Select Exam Type'),
                    onChanged: (String? newexamtypeValue) {
                      setState(() {
                        exam_typeValue = newexamtypeValue!;
                        _exam_typeController.text = exam_typeValue!;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    menuMaxHeight: 350.0,
                    items: ExamTypelist.map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _durationController,
                  validator: (val) => val!.isEmpty ? 'Duration Required' : null,
                  decoration: kInputDecoration('Duration'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _itemsController,
                  validator: (val) => val!.isEmpty ? 'Items Required' : null,
                  decoration: kInputDecoration('Items'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passing_scoreController,
                  validator: (val) =>
                      val!.isEmpty ? 'Passing Score Required' : null,
                  decoration: kInputDecoration('Passing Score'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createAssessment();
                    }
                  },
                  child: Text('Create Assessment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
