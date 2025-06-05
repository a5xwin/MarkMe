import 'package:flutter/material.dart';

class GpaPage extends StatelessWidget {
  const GpaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAFBFC),
      body: Center(
        child: Text(
          'GPA Calculator Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
