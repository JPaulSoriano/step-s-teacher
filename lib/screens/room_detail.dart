import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/announcement_model.dart';
import 'package:stepteacher/models/assessment_model.dart';
import 'package:stepteacher/models/assignment_model.dart';
import 'package:stepteacher/models/people_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/room_model.dart';
import 'package:stepteacher/palette.dart';
import 'package:stepteacher/screens/assessment_detail.dart';
import 'package:stepteacher/screens/assignment_detail.dart';
import 'package:stepteacher/screens/comment.dart';
import 'package:stepteacher/screens/create_assessment.dart';
import 'package:stepteacher/screens/create_assignment.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/announcement_service.dart';
import 'package:stepteacher/services/assessment_service.dart';
import 'package:stepteacher/services/assignment_service.dart';
import 'package:stepteacher/services/people%20service.dart';
import 'package:stepteacher/services/user_service.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;

  RoomDetailScreen({required this.room});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final List<String> roomImages = [
    'images/b1.jpg',
    'images/b2.jpg',
    'images/b3.jpg',
    'images/b4.jpg',
    'images/b5.jpg',
    'images/b6.jpg',
    'images/b7.jpg',
    'images/b8.jpg',
    'images/b9.jpg',
    'images/b10.jpg',
  ];
  Random random = new Random();
  List<dynamic> _announcementsList = [];
  List<dynamic> _peopleList = [];
  List<dynamic> _assignmentsList = [];
  List<dynamic> _assessmentsList = [];
  bool _loading = true;
  int userId = 0;
  int _currentIndex = 0;
  TextEditingController _txtAnnouncementController = TextEditingController();

  // create Announcements
  void _createAnnouncement() async {
    ApiResponse response = await createAnnouncement(
        widget.room.key!, _txtAnnouncementController.text);

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.data}'),
        ),
      );
      _txtAnnouncementController.clear();
      _getAnnouncements();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Get Announcements
  Future<void> _getAnnouncements() async {
    userId = await getUserId();
    ApiResponse response = await getAnnouncements(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _announcementsList = response.data as List<dynamic>;
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

  // Get People
  Future<void> _getPeople() async {
    userId = await getUserId();
    ApiResponse response = await getPeople(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _peopleList = response.data as List<dynamic>;
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

  // Get Assignments
  Future<void> _getAssignments() async {
    userId = await getUserId();
    ApiResponse response = await getAssignments(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _assignmentsList = response.data as List<dynamic>;
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

  // Get Assessments
  Future<void> _getAssessments() async {
    userId = await getUserId();
    ApiResponse response = await getAssessments(widget.room.id ?? 0);

    if (response.error == null) {
      setState(() {
        _assessmentsList = response.data as List<dynamic>;
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

  googleMeet() async {
    final url = widget.room.vclink ?? 'https://meet.google.com/';
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    _getAnnouncements();
    _getPeople();
    _getAssignments();
    _getAssessments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.room.name!,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () => googleMeet(),
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                margin: EdgeInsets.all(15),
                child: Image(
                  image:
                      AssetImage(roomImages[random.nextInt(roomImages.length)]),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 30),
                width: 220,
                child: Text(
                  '${widget.room.name}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 58, left: 30),
                child: Text(
                  '${widget.room.section}',
                  style: TextStyle(
                      fontSize: 14, color: Colors.white, letterSpacing: 1),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 80, left: 30),
                child: Text(
                  '${widget.room.key}',
                  style: TextStyle(
                      fontSize: 14, color: Colors.white, letterSpacing: 1),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Form(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: kInputDecoration('Announce something..'),
                      controller: _txtAnnouncementController,
                      onFieldSubmitted: (value) {
                        if (_txtAnnouncementController.text.isNotEmpty) {
                          setState(() {
                            _loading = true;
                          });

                          _createAnnouncement();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        closedForegroundColor: Palette.kToDark,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Palette.kToDark,
        labelsBackgroundColor: Colors.white,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.assignment_add),
            foregroundColor: Colors.white,
            backgroundColor: Palette.kToDark,
            label: 'Create Assigment',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateAssignmentForm(
                        roomKey: widget.room.key,
                      )));
            },
            closeSpeedDialOnPressed: true,
          ),
          SpeedDialChild(
            child: Icon(Icons.assessment),
            foregroundColor: Colors.white,
            backgroundColor: Palette.kToDark,
            label: 'Create Assessment',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateAssessmentForm(
                        roomKey: widget.room.key,
                      )));
            },
            closeSpeedDialOnPressed: true,
          ),
          //  Your other SpeedDialChildren go here.
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
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Assessments',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildAnnouncements();
      case 1:
        return _buildPeople();
      case 2:
        return _buildAssignments();
      case 3:
        return _buildAssessments();
      default:
        return Container();
    }
  }

  Widget _buildAnnouncements() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAnnouncements();
      },
      child: ListView.builder(
          itemCount: _announcementsList.length,
          itemBuilder: (BuildContext context, int index) {
            Announcement announcement = _announcementsList[index];
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 0)
                ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(left: 15, top: 15, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              CircleAvatar(
                                backgroundImage:
                                    announcement.user?.avatar != null
                                        ? CachedNetworkImageProvider(
                                            '${announcement.user!.avatar}')
                                        : null,
                                child: announcement.user?.avatar == null
                                    ? Text(
                                        announcement.user?.name?[0] ?? '',
                                        style: TextStyle(fontSize: 24),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 10),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${announcement.user!.name}',
                                      style: TextStyle(),
                                    ),
                                    Text(
                                      '${DateFormat.yMMMMd().format(DateTime.parse(announcement.created!))}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.only(left: 15, top: 15, bottom: 10),
                      child: Text(
                        '${announcement.title ?? 'No Title'}',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      margin: EdgeInsets.only(left: 12, top: 15, bottom: 10),
                      child: Text(
                          '${announcement.body?.replaceAll(RegExp('<p>|</p>|<br />'), '') ?? 'No Body'}'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentScreen(
                                  announcementID: announcement.id,
                                )));
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 40,
                        width: MediaQuery.of(context).size.width - 30,
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          "Class Comments",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    )
                  ],
                ));
          }),
    );
  }

  Widget _buildPeople() {
    return RefreshIndicator(
      onRefresh: () {
        return _getPeople();
      },
      child: ListView.separated(
        itemCount: _peopleList.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          People people = _peopleList[index];
          if (people.staff != null) {
            return _buildStaffRow(people.staff!);
          } else if (people.student != null) {
            return _buildStudentRow(people.student!);
          } else {
            return Container(); // return an empty container if there's no staff or student
          }
        },
      ),
    );
  }

  Widget _buildStaffRow(Staff staff) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${staff.name}',
                  style: TextStyle(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Teacher',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentRow(Student student) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.name}',
                  style: TextStyle(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Student',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignments() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAssignments();
      },
      child: ListView.builder(
          itemCount: _assignmentsList.length,
          itemBuilder: (BuildContext context, int index) {
            Assignment assignment = _assignmentsList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AssignmentDetailScreen(assignment: assignment),
                  ),
                );
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
                          Icons.assignment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${assignment.title ?? 'No Title'} ',
                            style: TextStyle(
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Due: ${DateFormat.yMMMMd().format(DateTime.parse(assignment.due!))}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
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

  Widget _buildAssessments() {
    return RefreshIndicator(
      onRefresh: () {
        return _getAssessments();
      },
      child: ListView.builder(
          itemCount: _assessmentsList.length,
          itemBuilder: (BuildContext context, int index) {
            Assessment assessment = _assessmentsList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AssessmentDetailScreen(assessment: assessment),
                  ),
                );
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
                          Icons.assignment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${assessment.title ?? 'No Title'} ',
                                style: TextStyle(
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                '${assessment.status}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Start: ${assessment.startDate}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Due: ${assessment.endDate}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
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
