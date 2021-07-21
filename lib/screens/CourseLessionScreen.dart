import 'package:computer_zirna/screens/StudyMaterialsScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

var subject_id;

class Data {
  final int id;
  final String title;
  final String description;
  final String video_url;

  Data(this.id, this.title, this.description, this.video_url);
}

class MyLession extends StatefulWidget {
  final int id;
  final String title;
  final String intro_url;
  final int c_id;

  MyLession(this.id, this.title, this.intro_url, this.c_id);

  @override
  _MyLessionState createState() => _MyLessionState();
}

class _MyLessionState extends State<MyLession> {
  late Future<List<Data>> courses;
  late int tabbedIndex;
  String youtube_id = '';
  var vid;
  int s_id = 0;

  Future<List<Data>> _myCourses() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    //var a=this.widget.id;
    //print(subject_id);
    var id = this.widget.id;
    var url = Uri.parse('http://computerzirna.in/api/subjects/$id/videos');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    List<Data> vids = [];
    var data = jsonDecode(response.body)['data'];
    //print(data);
    for (var v in data) {
      Data da = Data(v['id'], v['title'], v['description'], v['video_url']);
      vids.add(da);
    }
    return vids;
  }

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    tabbedIndex = -1;
    courses = _myCourses();
    secureScreen();
    var vidID;
    vidID = YoutubePlayer.convertUrlToId(this.widget.intro_url);
    vid = vidID;
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
    // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void clickVids(String url) async {
    setState(() {
      var kID;
      kID = YoutubePlayer.convertUrlToId(url);
      _controller.load(kID);
    });

    print(youtube_id);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        //actionsPadding: EdgeInsets.only(top: 50),
        aspectRatio: 18 / 9,
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
        appBar: AppBar(
          title: Text(this.widget.title),
        ),
        bottomSheet: Container(
          color: Colors.pinkAccent,
          width: 400,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => StudyMaterials(this.widget.c_id)));
            },
            child: Text(
              'Study Materials',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                player,
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5),
                  child: Text(
                    this.widget.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 3,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.amberAccent,
                ),
                Container(
                  child: FutureBuilder(
                    future: courses,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (c, i) => Container(
                            margin: EdgeInsets.only(top: 10),
                            color: tabbedIndex == i
                                ? Colors.lightBlueAccent
                                : null,
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  tabbedIndex = i;
                                  clickVids(snapshot.data[i].video_url);
                                });
                              },
                              title: Text(snapshot.data[i].title),
                              subtitle: Text(snapshot.data[i].description),
                              trailing: Icon(
                                Icons.play_circle,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
