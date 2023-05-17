import 'package:flutter/material.dart';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/viewscore_model.dart';
import 'package:stepteacher/screens/login.dart';
import 'package:stepteacher/services/user_service.dart';
import 'package:stepteacher/services/viewscore_service.dart';

class ViewScoreSreen extends StatefulWidget {
  final int? assessmentId;

  ViewScoreSreen({this.assessmentId});

  @override
  _ViewScoreSreenState createState() => _ViewScoreSreenState();
}

class _ViewScoreSreenState extends State<ViewScoreSreen> {
  List<dynamic> _scoreList = [];
  bool _loading = true;

  Future<void> _getScores() async {
    ApiResponse response = await getScores(widget.assessmentId ?? 0);

    if (response.error == null) {
      setState(() {
        _scoreList = response.data as List<dynamic>;
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
    _getScores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Scores'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () {
                  return _getScores();
                },
                child: _scoreList.isEmpty
                    ? Center(child: Text('No one submitted yet.'))
                    : ListView.builder(
                        itemCount: _scoreList.length,
                        itemBuilder: (BuildContext context, int index) {
                          ViewScore scores = _scoreList[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                scores.name ?? '',
                              ),
                              subtitle: Text('${scores.score}'),
                            ),
                          );
                        },
                      ),
              )),
            ]),
    );
  }
}
