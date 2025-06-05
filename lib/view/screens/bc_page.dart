import 'package:flutter/material.dart';

class BcPage extends StatelessWidget {
  const BcPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAFBFC),
      body: Center(
        child: Text(
          'Bunk Calculator Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
