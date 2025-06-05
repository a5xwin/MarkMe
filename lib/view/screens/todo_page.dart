import 'package:flutter/material.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAFBFC),
      body: Center(
        child: Text(
          'Todo Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}