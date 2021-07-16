import 'package:computer_zirna/screens/YoutubeVideoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
class MyLessionWidget extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String video_url;
  MyLessionWidget(this.id,this.title,this.description,this.video_url);

  @override
  _MyLessionWidgetState createState() => _MyLessionWidgetState();
}

class _MyLessionWidgetState extends State<MyLessionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: (){
           Navigator.of(context).push(MaterialPageRoute(builder: (c)=>YoutubeVideos(this.widget.video_url)));
        },
        child: ListTile(
          title: Text(this.widget.title,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(this.widget.description),
          trailing: Icon(FontAwesome5.play_circle,color: Colors.blueAccent,),
        ),
      ),
    );
  }
}
