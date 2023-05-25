import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/attendace_service.dart';
import 'package:stepteacher/services/user_service.dart';

class CreateAttendanceForm extends StatefulWidget {
  final String? roomKey;
  CreateAttendanceForm({this.roomKey});

  @override
  _CreateAttendanceFormState createState() => _CreateAttendanceFormState();
}

class _CreateAttendanceFormState extends State<CreateAttendanceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gradingController = TextEditingController();
  final TextEditingController _attendance_dateController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expiry_dateController = TextEditingController();
  final TextEditingController _expiry_timeController = TextEditingController();
  static const List<String> list = <String>[
    'prelim',
    'midterm',
    'semi',
    'finals'
  ];
  String? dropdownValue;
  // create Attendance
  void _createAttendance() async {
    ApiResponse response = await createAttendance(
      widget.roomKey!,
      _gradingController.text,
      _attendance_dateController.text,
      _descriptionController.text,
      _expiry_dateController.text,
      _expiry_timeController.text,
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
          'Create Attendace',
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
              Text('Date Format: YYYY-MM-DD'),
              TextFormField(
                controller: _attendance_dateController,
                validator: (val) => val!.isEmpty ? 'Date Required' : null,
                decoration: kInputDecoration('Date'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _descriptionController,
                validator: (val) =>
                    val!.isEmpty ? 'Description Required' : null,
                decoration: kInputDecoration('Description'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Date Format: YYYY-MM-DD'),
              TextFormField(
                controller: _expiry_dateController,
                validator: (val) =>
                    val!.isEmpty ? 'Expiry Date Required' : null,
                decoration: kInputDecoration('Expiry Date'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Time Format: 24:00:00'),
              TextFormField(
                controller: _expiry_timeController,
                validator: (val) =>
                    val!.isEmpty ? 'Expiry Time Required' : null,
                decoration: kInputDecoration('Expiry Time'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createAttendance();
                    }
                  },
                  child: Text('Create Attendance'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
