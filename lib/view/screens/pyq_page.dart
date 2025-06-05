import 'package:flutter/material.dart';

class PyqPage extends StatelessWidget {
  const PyqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAFBFC),
      body: Center(
        child: Text(
          'PYQ Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
