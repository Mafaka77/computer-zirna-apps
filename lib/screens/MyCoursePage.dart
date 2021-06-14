import 'package:flutter/material.dart';

class MyCoursePage extends StatelessWidget {
  const MyCoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Course'),
      ),
      body: Center(
        child: Text('My Course'),
      ),
    );
  }
}
