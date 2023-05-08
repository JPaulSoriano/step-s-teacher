import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/assignment_service.dart';
import 'package:stepteacher/services/user_service.dart';

class CreateAssignmentForm extends StatefulWidget {
  final String? roomKey;
  CreateAssignmentForm({this.roomKey});

  @override
  _CreateAssignmentFormState createState() => _CreateAssignmentFormState();
}

class _CreateAssignmentFormState extends State<CreateAssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _due_dateController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _gradingController = TextEditingController();
  final TextEditingController _allowed_submissionController =
      TextEditingController();
  static const List<String> list = <String>[
    'prelim',
    'midterm',
    'semi',
    'finals'
  ];
  String? dropdownValue;
  // create Assignment
  void _createAssignment() async {
    ApiResponse response = await createAssignment(
      widget.roomKey!,
      _titleController.text,
      _instructionsController.text,
      _due_dateController.text,
      _pointsController.text,
      _gradingController.text,
      _allowed_submissionController.text,
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
          'Create Assignment',
        ),
      ),
      body: Form(
        key: _formKey,
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
                controller: _instructionsController,
                validator: (val) =>
                    val!.isEmpty ? 'Instructions Required' : null,
                decoration: kInputDecoration('Instructions'),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Date Format: 09/05/2023 12:00 pm'),
              TextFormField(
                controller: _due_dateController,
                validator: (val) => val!.isEmpty ? 'Due Date Required' : null,
                decoration: kInputDecoration('Due Date'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _pointsController,
                validator: (val) => val!.isEmpty ? 'Points Required' : null,
                decoration: kInputDecoration('Points'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<String>(
                  value: dropdownValue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Grading Required';
                    }
                    return null;
                  },
                  decoration: kInputDecoration('Select Grading'),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      _gradingController.text = dropdownValue!;
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  menuMaxHeight: 350.0,
                  items: list.map<DropdownMenuItem<String>>((String value) {
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
                controller: _allowed_submissionController,
                validator: (val) =>
                    val!.isEmpty ? 'Allowed No of Submission Required' : null,
                decoration: kInputDecoration('Allowed No of Submission'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createAssignment();
                  }
                },
                child: Text('Create Assignment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
