import 'package:flutter/material.dart';

class CourseDetailWidget extends StatelessWidget {
  final int id;
  final String title;
  final String description;

  CourseDetailWidget(this.id, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
