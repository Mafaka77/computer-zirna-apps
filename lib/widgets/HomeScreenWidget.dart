import 'package:computer_zirna/screens/AdsVideoViewScreen.dart';
import 'package:flutter/material.dart';
import '../widgets/CourseWidget.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class Data {
  final int id;
  final String name;
  final String description;
  final int price;
  final String intro_url;
  final String thumbnail_url;

  Data(this.id, this.name, this.description, this.intro_url, this.price,
      this.thumbnail_url);
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  final storage = new FlutterSecureStorage();
  late Future<List<Data>> courseList;

  Future<List<Data>> _courseList() async {
    var auth_token = await storage.read(key: 'token');
    print(auth_token);
    final String token = 'uWb5qnuUnpBUPPutR0NAyHR6RqVrXP67xH3BWuhU';
    // await Future.delayed(Duration(seconds: 10));
    var url = Uri.parse('http://computerzirna.in/api/public/data');
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

    return course;
  }

  List<dynamic> slider = [];

  Future<List> _carData() async {
    var url = Uri.parse('http://computerzirna.in/api/public/data');
    var data = await http.get(url);
    var jsonData = jsonDecode(data.body)['data']['corousel'];
    //print(jsonData[0]);

    for (var u in jsonData) {
      slider.add(NetworkImage(u));
    }
    //print(slider);
    return jsonData;
  }

  List ad = [];
  List thumbnail = [];
  late List<YoutubePlayerController> _controllersYoutube;
  List<dynamic> ads = [];

  Future _adsData() async {
    var url = Uri.parse('http://computerzirna.in/api/public/data');
    var data = await http.get(url);
    var jsonData = jsonDecode(data.body)['data']['banners'];
    // var con=YoutubePlayer.convertUrlToId(jsonData);
    print(jsonData);
    setState(() {
      for (var u in jsonData) {
        thumbnail.add(u['url']);
      }
      for (var a in thumbnail) {
        ad.add(YoutubePlayer.convertUrlToId(a));
        print(ad);
      }
      _controllersYoutube = ad.map<YoutubePlayerController>((videoID) {
        return YoutubePlayerController(
            initialVideoId: videoID,
            flags: const YoutubePlayerFlags(
              disableDragSeek: true,
              autoPlay: false,
              hideControls: true,
              isLive: false,
            ));
      }).toList();
    });
  }

  @override
  void initState() {
    _adsData();
    courseList = _courseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: Colors.greenAccent,
              child: FutureBuilder(
                  future: _carData(),
                  builder: (c, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          height: 200,
                          child: Carousel(
                            images: slider,
                            boxFit: BoxFit.cover,
                            animationCurve: Curves.bounceInOut,
                            animationDuration: Duration(milliseconds: 1000),
                            showIndicator: false,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error'));
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
          Container(
            margin: new EdgeInsets.only(top: 10),
            child: const Text(
              'Our Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 3,
            color: Colors.redAccent,
          ),
          Container(
              margin: new EdgeInsets.only(top: 10),
              child: FutureBuilder(
                future: courseList,
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
            child: const Text(
              'Promo Videos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(),
            height: 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.amberAccent,
          ),
          Container(
            height: 200,
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              itemCount: thumbnail.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  print(thumbnail[index]);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => AdsVideoView(thumbnail[index])));
                },
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(right: 10),
                  width: 300,
                  child: YoutubePlayerBuilder(
                    builder: (c, i) => Container(),
                    player: YoutubePlayer(
                      thumbnail: Icon(Icons.play_circle),
                      key: ObjectKey(_controllersYoutube[index]),
                      controller: _controllersYoutube[index],
                      actionsPadding: const EdgeInsets.only(left: 16.0),
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                        const SizedBox(width: 10.0),
                        RemainingDuration(),
                        FullScreenButton()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
