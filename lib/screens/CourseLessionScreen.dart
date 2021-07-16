import 'package:computer_zirna/main.dart';
import 'package:computer_zirna/screens/StudyMaterialsScreen.dart';
import 'package:computer_zirna/widgets/CourseLessionWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class Subjects {
  final int id;
  final String title;
  final String description;

  Subjects(this.id, this.title, this.description);
}

class MyLession extends StatefulWidget {
  final int id;
  final String name;
  MyLession(this.id, this.name);

  @override
  _MyLessionState createState() => _MyLessionState();
}

class _MyLessionState extends State<MyLession> {
  int s_id=0;
  Future<List<Subjects>> _mySubjects() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var c_id = this.widget.id;
    var url = Uri.parse('http://computerzirna.in/api/courses/$c_id/subjects');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    List<Subjects> sub = [];
    var data = jsonDecode(response.body)['data'];
    for (var s in data) {
      Subjects n = Subjects(s['id'], s['title'], s['description']);
      sub.add(n);
    }
    return sub;
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
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>StudyMaterials(this.widget.id)));
          },
          child: Text(
            'Study Materials',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _mySubjects(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) =>
                    CourseLessionWidget(
                    snapshot.data[i].id,
                    snapshot.data[i].title,
                    snapshot.data[i].description,
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
