import 'package:computer_zirna/widgets/MaterialWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Data {
  final int id;
  final String title;
  final String description;
  final String path;
  final String category;

  Data(this.id, this.title, this.description, this.path, this.category);
}

class StudyMaterials extends StatefulWidget {
  final int id;

  StudyMaterials(this.id);

  @override
  _StudyMaterialsState createState() => _StudyMaterialsState();
}

class _StudyMaterialsState extends State<StudyMaterials> {
  late Future<List<Data>> materials;

  Future<List<Data>> _myMaterials() async {
    final storage = FlutterSecureStorage();
    final int s_id = this.widget.id;
    var token = await storage.read(key: 'token');
    var url = Uri.parse('http://computerzirna.in/api/courses/$s_id/materials');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    List<Data> mat = [];
    List<Data> met = [];
    var data = jsonDecode(response.body)['data'];
    for (var a in data) {
      Data da =
          Data(a['id'], a['title'], a['description'], a['path'], a['category']);
      mat.add(da);
    }
    var l = mat.where((element) => element.category == 'study material');
    print(l);
    for (var o in l) {
      met.add(o);
    }
    print(met);
    return met;
  }

  late Future<List<Data>> getcat;

  Future<List<Data>> getCat() async {
    final storage = FlutterSecureStorage();
    final int s_id = this.widget.id;
    var token = await storage.read(key: 'token');
    var url = Uri.parse('http://computerzirna.in/api/courses/$s_id/materials');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    List<Data> cat = [];
    List<Data> cet = [];
    var data = jsonDecode(response.body)['data'];
    for (var a in data) {
      Data m =
          Data(a['id'], a['title'], a['description'], a['path'], a['category']);
      cat.add(m);
    }
    var ad = cat.where((element) => element.category == 'practical assignment');
    for (var o in ad) {
      cet.add(o);
    }
    return cet;
  }

  @override
  void initState() {
    getcat = getCat();
    materials = _myMaterials();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materials'),
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            ExpansionTile(
              title: Text('Suggestion'),
              children: [
                Container(
                  child: FutureBuilder(
                    future: materials,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (c, i) => MaterialWidget(
                                snapshot.data[i].id,
                                snapshot.data[i].title,
                                snapshot.data[i].description,
                                snapshot.data[i].path,
                                snapshot.data[i].category));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('No Data'),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Practical Assignment'),
              children: [
                Container(
                  child: FutureBuilder(
                    future: getcat,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            itemBuilder: (c, i) => MaterialWidget(
                                snapshot.data[i].id,
                                snapshot.data[i].title,
                                snapshot.data[i].description,
                                snapshot.data[i].path,
                                snapshot.data[i].category));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('No Data'),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      )

          // Container(
          //   child: FutureBuilder(
          //     future: getCat(),
          //     builder: (BuildContext context,AsyncSnapshot snapshot){
          //       if(snapshot.hasData){
          //         return ListView.builder(
          //           shrinkWrap: true,
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: snapshot.data.length,
          //           itemBuilder: (c,i)=>MaterialWidget(
          //             // snapshot.data[i].id,
          //             // snapshot.data[i].title,
          //             // snapshot.data[i].description,
          //             // snapshot.data[i].path,
          //             snapshot.data[i].category
          //           )
          //         );
          //       }else if(snapshot.hasError){
          //         return Center(child: Text('No Data'),);
          //       }return Center(child: CircularProgressIndicator(),);
          //     },
          //   ),
          // ),
          ),
    );
  }
}
