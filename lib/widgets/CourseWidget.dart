import 'package:flutter/material.dart';
import '../screens/CourseDetailScreen.dart';
import '../screens/CourseDetails.dart';
class CourseWidget extends StatelessWidget {
  final String id;
  final String name;
  final String details;
  final String imageUrl;
  final String price;
  final String vidUrl;

  CourseWidget(this.id, this.name, this.details, this.imageUrl,this.price,this.vidUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => CourseDetailScreen(id,price,details,vidUrl)));
        },
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
