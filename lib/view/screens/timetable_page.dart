import 'package:flutter/material.dart';

class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAFBFC),
      body: Center(
        child: Text(
          'Timetable Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}