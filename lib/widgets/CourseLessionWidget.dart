import 'package:computer_zirna/screens/YoutubeVideoScreen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CourseLessionWidget extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String video_url;
  final String name;

  CourseLessionWidget(
      this.id, this.title, this.description, this.video_url, this.name);

  @override
  _CourseLessionWidgetState createState() => _CourseLessionWidgetState();
}

class _CourseLessionWidgetState extends State<CourseLessionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (builder) => YoutubeVideos(this.widget.video_url)));
        },
        child: ListTile(
          //leading: Text(this.widget.name),
          title: Text(this.widget.title),
          subtitle: Text(
            this.widget.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
          trailing: Icon(
            Icons.play_arrow_outlined,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
