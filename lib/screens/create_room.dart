import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/courses_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/course_service.dart';
import 'package:stepteacher/services/room_service.dart';
import 'package:stepteacher/services/user_service.dart';

class CreateRoomForm extends StatefulWidget {
  @override
  _CreateRoomFormState createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends State<CreateRoomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String? _selectedCourse;
  List<dynamic> _courseList = [];
  bool _loading = true;

  // create room
  void _createRoom() async {
    ApiResponse response = await createRoom(_subjectController.text,
        _sectionController.text, _courseController.text, _yearController.text);

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

  // get all courses
  Future<void> retrieveCourses() async {
    ApiResponse response = await getCourses();
    if (response.error == null) {
      setState(() {
        _courseList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveCourses();
    super.initState();
  }

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: new Text(
          'Create Room',
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
                controller: _subjectController,
                validator: (val) => val!.isEmpty ? 'Subject Required' : null,
                decoration: kInputDecoration('Subject'),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _sectionController,
                validator: (val) => val!.isEmpty ? 'Section Required' : null,
                decoration: kInputDecoration('Section'),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _yearController,
                validator: (val) => val!.isEmpty ? 'Year Required' : null,
                decoration: kInputDecoration('Year'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<String>(
                  value: _selectedCourse,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Course Required';
                    }
                    return null;
                  },
                  decoration: kInputDecoration('Select Course'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCourse = newValue;
                      _courseController.text = _selectedCourse!;
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  menuMaxHeight: 350.0,
                  items: _courseList.map((dynamic course) {
                    return DropdownMenuItem<String>(
                      value: course.name,
                      child:
                          Text(course.name!, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createRoom();
                  }
                },
                child: Text('Create Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
