import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/sharedtopics_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/sharedtopics_service.dart';
import 'package:stepteacher/services/user_service.dart';
import 'dart:async';

class SharedTopicScreen extends StatefulWidget {
  @override
  _SharedTopicScreenState createState() => _SharedTopicScreenState();
}

class _SharedTopicScreenState extends State<SharedTopicScreen> {
  List<dynamic> _sharedtopicsList = [];
  bool _loading = true;
  int _currentIndex = 0;

  // Get Topics
  Future<void> _getSharedtopics() async {
    ApiResponse response = await getSharedtopics();

    if (response.error == null) {
      setState(() {
        _sharedtopicsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
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
    _getSharedtopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return _getSharedtopics();
            },
            child: ListView.builder(
                itemCount: _sharedtopicsList.length,
                itemBuilder: (BuildContext context, int index) {
                  SharedTopic sharedtopic = _sharedtopicsList[index];
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey),
                              child: Icon(
                                Icons.topic,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${sharedtopic.name ?? 'No Title'} by ${sharedtopic.owner ?? 'No Name'}',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Questions: ${sharedtopic.questionsCount ?? '0'} ',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Materials: ${sharedtopic.materialsCount ?? '0'} ',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
