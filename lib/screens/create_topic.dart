import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/topics_service.dart';
import 'package:stepteacher/services/user_service.dart';

class CreateTopicForm extends StatefulWidget {
  @override
  _CreateTopicFormState createState() => _CreateTopicFormState();
}

class _CreateTopicFormState extends State<CreateTopicForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  // create room
  void _createTopic() async {
    ApiResponse response = await createTopic(_nameController.text);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: new Text(
          'Create Topic',
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
                controller: _nameController,
                validator: (val) => val!.isEmpty ? 'Name Required' : null,
                decoration: kInputDecoration('Name'),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createTopic();
                    }
                  },
                  child: Text('Create Topic'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
