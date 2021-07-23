import 'package:computer_zirna/widgets/MyCourseListWidget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class Data {
  final int id;
  final String name;
  final String description;
  final String thumbnail_url;
  final String intro_url;

  Data(
      this.id, this.name, this.description, this.thumbnail_url, this.intro_url);
}

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({Key? key}) : super(key: key);

  @override
  _MyCoursePageState createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  late Future<List<Data>> courses;

  Future<List<Data>> _courseData() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var url = Uri.parse('http://computerzirna.in/api/profile/courses');
    var data = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var response = json.decode(data.body)['data'];
    List<Data> course = [];
    for (var u in response) {
      Data da = Data(u['id'], u['name'], u['description'], u['thumbnail_url'],
          u['intro_url']);
      course.add(da);
    }
    return course;
  }

  @override
  void initState() {
    // TODO: implement initState
    courses = _courseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Course'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
            child: FutureBuilder(
          future: courses,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) => MyCourseList(
                    snapshot.data[i].id,
                    snapshot.data[i].name,
                    snapshot.data[i].description,
                    snapshot.data[i].thumbnail_url,
                    snapshot.data[i].intro_url),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('No Course'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )),
    );
  }
}
