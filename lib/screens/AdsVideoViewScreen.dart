import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  @override
  void initState() {
    //print(this.widget.name);
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
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
      player: YoutubePlayer(
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
        body: player,
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
