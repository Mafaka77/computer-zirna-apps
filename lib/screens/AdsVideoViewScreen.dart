
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Data{
  final String url;
  Data(this.url);
}

class AdsVideoView extends StatefulWidget {
  final String vid_id;
 AdsVideoView(this.vid_id);

  @override
  _AdsVideoViewState createState() => _AdsVideoViewState();
}

class _AdsVideoViewState extends State<AdsVideoView> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  late Future<List<Data>> vidList;
  late List<YoutubePlayerController> _controllersYoutube;
  List thumbnail=[];
  List ad=[];
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
      for(var a in thumbnail){
        ad.add(YoutubePlayer.convertUrlToId(a));
        print(ad);
      }
      _controllersYoutube=ad.map<YoutubePlayerController>((videoID){
        return YoutubePlayerController(
            initialVideoId: videoID,
            flags: const YoutubePlayerFlags(
              disableDragSeek: true,
              autoPlay: false,
              hideControls: true,
              isLive: false,
            )
        );
      }).toList();
    });

  }
  void clickVids(String url) async {
    setState(() {
      var kID;
      kID = YoutubePlayer.convertUrlToId(url);
      _controller.load(kID);
      thumbnail.remove(kID);
    });

    //print(youtube_id);
  }
  @override
  void initState() {
    _adsData();
    //print(this.widget.name);
    super.initState();
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    var vidID;
    vidID = YoutubePlayer.convertUrlToId(widget.vid_id);
    //print(c_id.toString());

    _controller = YoutubePlayerController(
      initialVideoId: vidID,
      flags: const YoutubePlayerFlags(
        useHybridComposition: true,
        hideThumbnail: true,
        mute: false,
        autoPlay: true,
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
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(

      // onExitFullScreen: (){
      //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      // },
      player: YoutubePlayer( thumbnail: Center(child: Icon(FontAwesome.play_circle),),
        //actionsPadding: EdgeInsets.only(top: 50),
        aspectRatio: 18/9,
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
      builder: (context,player)=>Scaffold(
        appBar: AppBar(title: Text('VIDEOS'),),
        body:  SingleChildScrollView(
          child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  player,
               Container(
                 margin: EdgeInsets.only(top: 10,left: 10),
                 child: Text('Promo Videos',style: TextStyle(fontSize: 20,color: Colors.pinkAccent),),
               ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 3,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.amberAccent,
                  ),
               Container(
                      margin: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                       physics: NeverScrollableScrollPhysics(),
                        itemCount: thumbnail.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) => GestureDetector(
                          onTap: (){
                            print(thumbnail[index]);
                            clickVids(thumbnail[index]);
                          },
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(right: 10,bottom: 10,left: 10),
                            height: 200,
                            child: YoutubePlayerBuilder(
                              builder: (c,i)=>Container(),
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

          ),
        ),
        // body: SingleChildScrollView(
        //   child: Container(
        //     margin: EdgeInsets.all(15),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         player
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
