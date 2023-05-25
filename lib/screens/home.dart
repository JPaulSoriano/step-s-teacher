import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/user_model.dart';
import 'package:stepteacher/palette.dart';
import 'package:stepteacher/screens/create_room.dart';
import 'package:stepteacher/screens/create_topic.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/screens/rooms.dart';
import 'package:stepteacher/screens/sharedtopics.dart';
import 'package:stepteacher/screens/topics.dart';
import 'package:stepteacher/services/user_service.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  User? user;

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
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
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('STEP S TEACHER'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${user?.name}'),
              accountEmail: Text('${user?.email}'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.avatar != null
                    ? CachedNetworkImageProvider(user!.avatar!)
                    : null,
                child: user?.avatar == null
                    ? Text(
                        '${user?.name?[1]}',
                        style: TextStyle(fontSize: 40.0),
                      )
                    : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Rooms'),
              onTap: () {
                setState(() {
                  currentIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.topic),
              title: Text('Topics'),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.topic_outlined),
              title: Text('Shared Topics'),
              onTap: () {
                setState(() {
                  currentIndex = 2;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Login()),
                          (route) => false)
                    });
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          RoomScreen(),
          TopicScreen(),
          SharedTopicScreen(),
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
            child: Icon(Icons.home),
            foregroundColor: Colors.white,
            backgroundColor: Palette.kToDark,
            label: 'Create Room',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateRoomForm()));
            },
            closeSpeedDialOnPressed: true,
          ),
          SpeedDialChild(
            child: Icon(Icons.topic),
            foregroundColor: Colors.white,
            backgroundColor: Palette.kToDark,
            label: 'Create Topic',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateTopicForm()));
            },
            closeSpeedDialOnPressed: true,
          ),
          //  Your other SpeedDialChildren go here.
        ],
      ),
    );
  }
}
