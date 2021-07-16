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

  Data(this.id, this.title, this.description, this.path);
}

class StudyMaterials extends StatefulWidget {
  final int id;
  StudyMaterials(this.id);

  @override
  _StudyMaterialsState createState() => _StudyMaterialsState();
}

class _StudyMaterialsState extends State<StudyMaterials> {

  Future<List<Data>> _myMaterials() async {
    final storage=FlutterSecureStorage();
    final int s_id=this.widget.id;
    var token=await storage.read(key: 'token');
    var url= Uri.parse('http://computerzirna.in/api/courses/$s_id/materials');
    var response=await http.get(url,headers: {
      'Authorization':'Bearer $token'
    });
    List<Data> mat=[];
    var data=jsonDecode(response.body)['data'];
    for(var a in data){
      Data da= Data(a['id'], a['title'], a['description'], a['path']);
      mat.add(da);
    }
    return mat;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materials'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
            future: _myMaterials(),
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (c,i)=>MaterialWidget(
                    snapshot.data[i].id,
                    snapshot.data[i].title,
                    snapshot.data[i].description,
                    snapshot.data[i].path
                  )
                );
              }else if(snapshot.hasError){
                return Center(child: Text('No Data'),);
              }return Center(child: CircularProgressIndicator(),);
            },
          ),
        ),
      ),
    );
  }
}
