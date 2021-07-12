import 'package:flutter/material.dart';

class MyCourseList extends StatelessWidget {
  final int id;
  final String name;
  final String description;
  final String thumbnail_url;

  MyCourseList(this.id, this.name, this.description, this.thumbnail_url);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {},
        leading: Image.network(
          this.thumbnail_url,
          fit: BoxFit.cover,
        ),
        title: Text(
          this.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          this.description,
          style: TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
        ),
        trailing: Icon(
          Icons.play_arrow_outlined,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
