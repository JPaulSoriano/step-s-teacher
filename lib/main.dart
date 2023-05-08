import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stepteacher/palette.dart';
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
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}
