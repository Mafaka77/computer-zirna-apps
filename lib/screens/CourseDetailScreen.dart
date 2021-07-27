import 'package:computer_zirna/screens/BuyClickScreen.dart';
import 'package:computer_zirna/screens/MyCoursePage.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/CourseDetailWidget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class Data {
  final int id;
  final String title;
  final String description;

  Data(this.id, this.title, this.description);
}

class CourseDetailScreen extends StatefulWidget {
  final int id;
  final String name;
  final int price;
  final String description;
  final String intro_url;

  CourseDetailScreen(
      this.id, this.name, this.price, this.description, this.intro_url);

  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetailScreen> {
  late Future<List<Data>> courses;
  int c_id = 0;
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    courses = _myData();
    //print(this.widget.name);
    var vidID;
    vidID = YoutubePlayer.convertUrlToId(widget.intro_url);
    loadMe();
    //print(c_id.toString());
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: vidID,
      flags: const YoutubePlayerFlags(
        useHybridComposition: true,
        hideThumbnail: true,
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void loadMe() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    var url = Uri.parse('http://computerzirna.in/api/profile/courses');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var app = jsonDecode(response.body)['data'];
      //print(course_id);
      var myList = [];
      for (var a in app) {
        myList.add(a['id']);
        if (myList.contains(this.widget.id)) {
          this.setState(() {
            this.c_id = this.widget.id;
          });
        }
      }
      // setState(() {
      //   this.c_id=course_id;
      // });
      print(c_id.toString());
    }
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  Future<List<Data>> _myData() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    //print(token);
    //String t='11|xNx58VPbw3it4YJbV62nmnlvJI88vXikJsFzu1NH';
    String id = widget.id.toString();
    //print(id);
    var url = Uri.parse('http://computerzirna.in/api/courses/$id/subjects');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var jsonData = json.decode(response.body)['data'];
    List<Data> les = [];
    for (var u in jsonData) {
      Data da = Data(u['id'], u['title'], u['description']);
      les.add(da);
    }
    //print('Data a ni e');
    return les;
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      },
      player: YoutubePlayer(
        // thumbnail: Center(child: CircularProgressIndicator(),),
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player,
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('₹ ${widget.price.toString()}',
                      // style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      style: GoogleFonts.saira(
                        fontSize: 30),
                  ),
                ),
                Container(
                  width: 500,
                  margin: EdgeInsets.only(top: 10),
                  child: this.widget.id == c_id
                      ? TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.redAccent),
                          ),
                          child: Text(
                            'View Course',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          onPressed: () => {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (builder) => MyCoursePage()))
                          },
                        )
                      : TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.pinkAccent),
                          ),
                          child: Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          onPressed: () => {
                            Navigator.of(context).pushNamed(
                                // MaterialPageRoute(
                                // builder: (builder) =>
                                //     BuyClickScreen(this.widget.id))
                              '/buy-screen',arguments: {
                                'id':this.widget.id
                            }
                            ),
                          },
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: const Text(
                    'Course Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 3,
                  color: Color.fromRGBO(25, 0, 51, 230.0),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(widget.description),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: const Text(
                    'Course Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 3,
                  color: Color.fromRGBO(25, 0, 51, 230.0),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: FutureBuilder(
                    future: courses,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print(snapshot);
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (c, i) => CourseDetailWidget(
                              snapshot.data[i].id,
                              snapshot.data[i].title,
                              snapshot.data[i].description),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error'),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
