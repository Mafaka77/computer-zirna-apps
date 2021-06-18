import 'package:flutter/material.dart';
import '../widgets/CourseWidget.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
// class CarouselData {
//   final List<String> corousel;
//
//   CarouselData(this.corousel);
// }

class Data {
  final int id;
  final String name;
  final String description;
  final int price;
  final String intro_url;
  final String thumbnail_url;

  Data(this.id, this.name, this.description, this.intro_url, this.price,
      this.thumbnail_url);

//  Data.fromJson(Map<String, dynamic> json) {
//   return Data(
//       id: json['id'],
//     name: json['name'],
//     description: json['description'],
//     price: json['price'],
//       intro_url: json['intro_url'],
//     thumbnail_url: json['thumbnail_url'],
//   )
// }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  final storage = new FlutterSecureStorage();

  Future<List<Data>> _courseList() async {
    var auth_token = await storage.read(key: 'token');
    print(auth_token);
    final String token = 'uWb5qnuUnpBUPPutR0NAyHR6RqVrXP67xH3BWuhU';
    // await Future.delayed(Duration(seconds: 10));
    var url = Uri.parse(''
        'computerzirna.in/api/public/data');
    var data = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var jsonData = json.decode(data.body)['data']['courses'];
    List<Data> course = [];
    for (var u in jsonData) {
      Data da = Data(u['id'], u['name'], u['description'], u['intro_url'],
          u['price'], u['thumbnail_url']);
      course.add(da);
    }
    print('course');
    // print(hello);
    return course;
  }
  List<dynamic> slider=[];
  Future<List> _carData() async {
    var url = Uri.parse('http://computerzirna.in/api/public/data');
    var data = await http.get(url);
    var jsonData = jsonDecode(data.body)['data']['corousel'];
    print(jsonData[0]);

    for(var u in jsonData){
      slider.add(NetworkImage(u));
    }
    return jsonData;

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.greenAccent,
            child: FutureBuilder(
                  future: _carData(),
                  builder: (c,snapshot){
                    if(snapshot.hasData){
                      return Center(
                        child: SizedBox(
                          height: 200,
                          child: Carousel(
                            images: slider,
                            boxFit: BoxFit.cover,
                            animationCurve: Curves.fastOutSlowIn,
                            animationDuration: Duration(milliseconds: 1000),
                            showIndicator: false,

                          ),
                        ),
                      );
                    }else if(snapshot.hasError){
                      return Center(child:Text('Error'));
                    }
                    return Center(child: CircularProgressIndicator(),);

                  }
                )
            ),
          Container(
            margin: new EdgeInsets.only(top: 10),
            child: Text(
              'Hot Course',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 500,
            height: 3,
            color: Colors.redAccent,
          ),
          Container(
              margin: new EdgeInsets.only(top: 10),
              child: FutureBuilder(
                future: _courseList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot);
                  // var data=snapshot.data!;
                  if (snapshot.hasData) {
                    return Container(
                      height: 270,
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: CourseWidget(
                                snapshot.data[index].id,
                                snapshot.data[index].name,
                                snapshot.data[index].description,
                                snapshot.data[index].intro_url,
                                snapshot.data[index].price,
                                snapshot.data[index].thumbnail_url,
                              ),
                            );
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Promo Videos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 3,
            width: 500,
            color: Colors.amberAccent,
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (ctx, i) => Container(
                color: Colors.pink,
                margin: EdgeInsets.only(right: 10),
                width: 300,
                child: Text('Hello'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
