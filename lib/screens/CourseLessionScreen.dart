import 'package:computer_zirna/main.dart';
import 'package:computer_zirna/widgets/CourseLessionWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Data {
  final int id;
  final String title;
  final String description;
  final String video_url;

  Data(this.id, this.title, this.description, this.video_url);
}

class MyLession extends StatefulWidget {
  final int id;
  final String name;

  MyLession(this.id, this.name);

  @override
  _MyLessionState createState() => _MyLessionState();
}

class _MyLessionState extends State<MyLession> {
  Future<List<Data>> _myCourses() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var c_id = this.widget.id;
    var url =
        Uri.parse('http://computerzirna.in/api/profile/courses/$c_id/videos');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.name),
      ),
      bottomSheet: Container(
        color: Colors.pinkAccent,
        width: 400,
        child: TextButton(
          onPressed: (){},
          child: Text('Study Materials',style: TextStyle(color: Colors.white,fontSize: 18),),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _myCourses(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) => CourseLessionWidget(
                    snapshot.data[i].id,
                    snapshot.data[i].title,
                    snapshot.data[i].description,
                    snapshot.data[i].video_url,
                    this.widget.name),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('No Internet'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
