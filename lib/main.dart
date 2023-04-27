import 'package:flutter/material.dart';
import 'package:stepteacher/screens/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STEP S TEACHER',
      home: Loading(),
    );
  }
}
