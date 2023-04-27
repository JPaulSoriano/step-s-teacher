import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/announcement_model.dart';
import 'package:stepteacher/models/people_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/room_model.dart';
import 'package:stepteacher/screens/comment.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/announcement_service.dart';
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
  bool _loading = true;
  int userId = 0;
  int _currentIndex = 0;
  TextEditingController _txtAnnouncementController = TextEditingController();

  // create Announcements
  void _createAnnouncement() async {
    ApiResponse response = await createAnnouncement(
        widget.room.key!, _txtAnnouncementController.text);

    if (response.error == null) {
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

  googleMeet() async {
    final url = widget.room.vclink ?? 'https://meet.google.com/';
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    _getAnnouncements();
    _getPeople();
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
}
