import 'package:computer_zirna/screens/CourseLessionScreen.dart';
import 'package:flutter/material.dart';
import 'package:computer_zirna/main.dart';
import 'package:computer_zirna/screens/StudyMaterialsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class Subjects {
  final int id;
  final String title;
  final String description;

  Subjects(this.id, this.title, this.description);
}

class MyCourseList extends StatefulWidget {
  final int id;
  final String name;
  final String description;
  final String thumbnail_url;
  final String intro_url;

  MyCourseList(
      this.id, this.name, this.description, this.thumbnail_url, this.intro_url);

  @override
  _MyCourseListState createState() => _MyCourseListState();
}

class _MyCourseListState extends State<MyCourseList> {
  late int tabbedIndex;
  late Future<List<Subjects>> subjects;

  Future<List<Subjects>> _mySubjects() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var c_id = this.widget.id;
    var url = Uri.parse('http://computerzirna.in/api/courses/$c_id/subjects');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    List<Subjects> sub = [];
    var data = jsonDecode(response.body)['data'];
    // print(data);
    for (var s in data) {
      Subjects n = Subjects(s['id'], s['title'], s['description']);
      sub.add(n);
    }
    //print(sub);
    return sub;
  }

  @override
  void initState() {
    // TODO: implement initState
    subjects = _mySubjects();
    tabbedIndex = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        leading: Image.network(
          this.widget.thumbnail_url,
          fit: BoxFit.cover,
        ),
        title: Text(
          this.widget.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          this.widget.description,
          style: TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
        ),
        children: [
          Container(
            child: Text(
              'SUBJECT LIST',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: new FutureBuilder(
              future: subjects,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (c, i) => InkWell(
                            onTap: () {},
                            child: Container(
                              color: tabbedIndex == i
                                  ? Colors.lightBlueAccent
                                  : null,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    tabbedIndex = i;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (builder) => MyLession(
                                                snapshot.data[i].id,
                                                snapshot.data[i].title,
                                                this.widget.intro_url,
                                                this.widget.id)));
                                  });
                                },
                                title: Text(snapshot.data[i].title),
                                subtitle: Text(snapshot.data[i].description),
                                trailing: Icon(
                                  FontAwesome.chevron_right,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          )
                      //     MyLessionWidget(
                      //     snapshot.data[i].id,
                      //     snapshot.data[i].title,
                      //     snapshot.data[i].description,
                      //     snapshot.data[i].video_url
                      // )
                      );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('No item'),
                  );
                }
                return Center(
                  child: Text('No data'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
