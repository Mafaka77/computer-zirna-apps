import 'package:flutter/material.dart';
class CourseDetails extends StatelessWidget {
  final String id;
  CourseDetails(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id),
      ),
    );
  }
}
