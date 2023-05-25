// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'package:stepteacher/palette.dart';

const baseURL = 'http://143.198.213.49/api';
const loginURL = baseURL + '/teacher/login';
const logoutURL = baseURL + '/teacher/logout';
const userURL = baseURL + '/teacher/user';
const roomsURL = baseURL + '/teacher/rooms';
const CommentUrl = baseURL + '/teacher/announcements';
const AnnounceUrl = baseURL + '/teacher/rooms';
const createRoomURL = baseURL + '/teacher/rooms/create';
const coursesURL = baseURL + '/teacher/courses';
const createAssignmentURL = baseURL + '/teacher/rooms';
const createAssessmentURL = baseURL + '/teacher/rooms';
const viewscoretURL = baseURL + '/teacher/assessments';
const topicsURL = baseURL + '/teacher/topics';
const sharedtopicsURL = baseURL + '/teacher/sharedtopics';
const createAttendanceURL = baseURL + '/teacher/rooms';
const editVCLinkURL = baseURL + '/teacher/rooms';
const createTopicURL = baseURL + '/teacher/topics/create';
// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

// button
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Palette.kToDark),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
  );
}

// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
          child: Text(label, style: TextStyle(color: Colors.blue)),
          onTap: () => onTap())
    ],
  );
}
