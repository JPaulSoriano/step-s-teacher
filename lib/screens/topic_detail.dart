import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/material_model.dart';
import 'package:stepteacher/models/question_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/topics_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/materials_service.dart';
import 'package:stepteacher/services/questions_service.dart';
import 'package:stepteacher/services/user_service.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;

  TopicDetailScreen({required this.topic});

  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  List<dynamic> _questionsList = [];
  List<dynamic> _materialsList = [];
  bool _loading = true;
  int _currentIndex = 0;

  // Get Questions
  Future<void> _getQuestions() async {
    ApiResponse response = await getQuestions(widget.topic.id ?? 0);

    if (response.error == null) {
      setState(() {
        _questionsList = response.data as List<dynamic>;
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

  // Get Materials
  Future<void> _getMaterials() async {
    ApiResponse response = await getMaterials(widget.topic.id ?? 0);

    if (response.error == null) {
      setState(() {
        _materialsList = response.data as List<dynamic>;
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
    _getQuestions();
    _getMaterials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.topic.name ?? ''}',
        ),
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Materials',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildQuestions();
      case 1:
        return _buildMaterials();
      default:
        return Container();
    }
  }

  Widget _buildQuestions() {
    return RefreshIndicator(
      onRefresh: () {
        return _getQuestions();
      },
      child: _questionsList.isEmpty
          ? Center(child: Text('No questions'))
          : ListView.builder(
              itemCount: _questionsList.length,
              itemBuilder: (BuildContext context, int index) {
                Question question = _questionsList[index];
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
                              Icons.question_mark,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${question.name ?? ''}',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMaterials() {
    return RefreshIndicator(
      onRefresh: () {
        return _getMaterials();
      },
      child: _materialsList.isEmpty
          ? Center(child: Text('No materials'))
          : ListView.builder(
              itemCount: _materialsList.length,
              itemBuilder: (BuildContext context, int index) {
                TopicMaterial material = _materialsList[index];
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
                              Icons.edit_document,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${material.title ?? ''}',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
