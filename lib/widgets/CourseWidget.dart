import 'package:flutter/material.dart';
import '../screens/CourseDetailScreen.dart';
import '../screens/CourseDetails.dart';

class CourseWidget extends StatelessWidget {
  final int id;
  final String name;
  final String description;
  final int price;
  final String intro_url;
  final String thumbnail_url;

  CourseWidget(this.id, this.name, this.description, this.intro_url, this.price,
      this.thumbnail_url);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) =>
                CourseDetailScreen(id, name, price, description, intro_url)));
      },
      child: GridTile(
        // child: Image.network(
        //   thumbnail_url,
        //   fit: BoxFit.cover,
        // ),
        child: Text('sadsad'),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
