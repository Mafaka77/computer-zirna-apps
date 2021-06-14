import 'package:flutter/material.dart';
class CourseDetailWidget extends StatelessWidget {
  final String subName;
  final String subDetails;

  CourseDetailWidget(this.subName,this.subDetails);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(subName),
        subtitle: Text(subDetails),
      ),
    );
  }
}
