import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/topics_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/screens/topic_detail.dart';
import 'package:stepteacher/services/topics_service.dart';
import 'package:stepteacher/services/user_service.dart';
import 'dart:async';

class TopicScreen extends StatefulWidget {
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List<dynamic> _topicsList = [];
  bool _loading = true;
  int _currentIndex = 0;

  // Get Topics
  Future<void> _getTopics() async {
    ApiResponse response = await getTopics();

    if (response.error == null) {
      setState(() {
        _topicsList = response.data as List<dynamic>;
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
    _getTopics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return _getTopics();
            },
            child: ListView.builder(
                itemCount: _topicsList.length,
                itemBuilder: (BuildContext context, int index) {
                  Topic topic = _topicsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TopicDetailScreen(
                                topic: topic,
                              )));
                    },
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
                                  '${topic.name ?? 'No Name'} ',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Questions: ${topic.questionsCount ?? '0'} ',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Materials: ${topic.materialsCount ?? '0'} ',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
