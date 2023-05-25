import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/user_service.dart';
import 'package:stepteacher/services/vclinkservice.dart';

class UpdateVCLinkForm extends StatefulWidget {
  final String? roomKey;
  UpdateVCLinkForm({this.roomKey});

  @override
  _UpdateVCLinkFormState createState() => _UpdateVCLinkFormState();
}

class _UpdateVCLinkFormState extends State<UpdateVCLinkForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _VCLinkController = TextEditingController();

  // edit VC Link
  void _editVCLink() async {
    ApiResponse response =
        await editVCLink(widget.roomKey!, _VCLinkController.text);
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
          'Edit VC Link',
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
              Text('Example: https://meet.google.com/hqr-fnsk-hzp'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _VCLinkController,
                validator: (val) => val!.isEmpty ? 'VC Link Required' : null,
                decoration: kInputDecoration('VC Link'),
                keyboardType: TextInputType.url,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _editVCLink();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
