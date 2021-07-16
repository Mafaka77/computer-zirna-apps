import 'package:computer_zirna/screens/YoutubeVideoScreen.dart';
import 'package:computer_zirna/widgets/MyLessionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Data {
  final int id;
  final String title;
  final String description;
  final String video_url;

  Data(this.id, this.title, this.description, this.video_url);
}
class CourseLessionWidget extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String name;

  CourseLessionWidget(
      this.id, this.title, this.description, this.name);

  @override
  _CourseLessionWidgetState createState() => _CourseLessionWidgetState();
}

class _CourseLessionWidgetState extends State<CourseLessionWidget> {
  Future<List<Data>> _myCourses() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var c_id = this.widget.id;
    var url =
    Uri.parse('http://computerzirna.in/api/subjects/$c_id/videos');
    var response =
    await http.get(url, headers: {'Authorization': 'Bearer $token'});
    List<Data> vids = [];
    var data = jsonDecode(response.body)['data'];
    for (var v in data) {
      Data da = Data(v['id'], v['title'], v['description'], v['video_url']);
      vids.add(da);
    }
    //print(vids.toString());
    return vids;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (builder) => YoutubeVideos(this.widget.video_url)));
        },
        child: ExpansionTile(
          title: Text(this.widget.title),
          subtitle: Text(this.widget.description),
          children: [
            Container(
              child: new FutureBuilder(
                future: _myCourses(),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (c,i)=>MyLessionWidget(
                        snapshot.data[i].id,
                        snapshot.data[i].title,
                        snapshot.data[i].description,
                        snapshot.data[i].video_url
                      )
                    );
                  }else if(snapshot.hasError){
                    return Center(child: Text('No item'),);
                  }
                  return Center(child: Text('No data'),);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
