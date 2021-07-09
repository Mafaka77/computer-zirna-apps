import 'package:computer_zirna/screens/BuyClickScreen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/subject.dart';
import '../widgets/CourseDetailWidget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
class Data{
  final int id;
  final String title;
  final String description;
  Data(this.id,this.title,this.description);
}

class CourseDetailScreen extends StatefulWidget {
  final int id;
  final String name;
  final int price;
  final String description;
  final String intro_url;

  CourseDetailScreen(this.id,this.name, this.price, this.description, this.intro_url);

  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetailScreen> {
  
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
    var vidID;
    vidID = YoutubePlayer.convertUrlToId(widget.intro_url);

    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: vidID,
      flags: const YoutubePlayerFlags(
        hideThumbnail: false,
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
    super.dispose();
  }

  Future<List<Data>> _myData() async{
    final storage=new FlutterSecureStorage();
    var token=await storage.read(key: 'token');
    print(token);
    String t='11|xNx58VPbw3it4YJbV62nmnlvJI88vXikJsFzu1NH';
    String id=widget.id.toString();
    print(id);
    var url=Uri.parse('http://computerzirna.in/api/courses/$id/show');
    var response=await http.get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':'Bearer $t'
    });
    var jsonData=json.decode(response.body)['data']['videos'];
    List<Data> les=[];
    for(var u in jsonData){
      Data da= Data(u['id'],u['title'],u['description']);
      les.add(da);
    }
    print('Data a ni e');
    return les;
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
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
        // onEnded: (data) {
        //   _controller
        //       .load(widget.vidUrl[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
        // },
      ),
      builder: (context, player) => Scaffold(
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
                  child: Text(
                    '₹  ${widget.price.toString()}',
                    // style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    style: GoogleFonts.saira(fontSize: 30,fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 500,
                  margin: EdgeInsets.only(top: 10),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>BuyClickScreen()))
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    'Course Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 500,
                  height: 5,
                  color: Colors.blueAccent,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(widget.description),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    'Course Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 500,
                  height: 5,
                  color: Colors.blueAccent,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child:FutureBuilder(
                    future: _myData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      print(snapshot);
                      if(snapshot.hasData){
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (c, i) =>
                              CourseDetailWidget(
                                snapshot.data[i].id,
                                snapshot.data[i].title,
                                snapshot.data[i].description
                              ),
                        );
                      }else if(snapshot.hasError){
                        return Center(child: Text('Error'),);
                      }
                      return Center(child: CircularProgressIndicator(),);
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
