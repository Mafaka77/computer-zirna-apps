import 'package:computer_zirna/screens/LoginScreen.dart';
import 'package:computer_zirna/screens/MyCoursePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
import 'package:theme_mode_handler/theme_picker_dialog.dart';
import '../widgets/HomeScreenWidget.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final storage = new FlutterSecureStorage();
  var mobile = '';

  void _myData() async {
    var auth_token = await storage.read(key: 'token');
    // print(auth_token);
    // var token='70|sblqr7H2YVsJaM64qCHVvna8lEpV89OrQ3SYqUN2';
    var url = Uri.parse('http://computerzirna.in/api/profile/me');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $auth_token'
    });
    if (response.statusCode == 200) {
      var d = jsonDecode(response.body)['data']['phone_no'];
      setState(() {
        mobile = d.toString();
      });
      print(mobile);
    } else {
      throw Exception('Failed to load ');
    }
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
              hideControls: false,
              isLive: false,
            ));
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adsData();
    _myData();
  }

  void _selectThemeMode(BuildContext context) async {
    final newThemeMode = await showThemePickerDialog(context: context);
    print(newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ThemeModeHandler.of(context)?.themeMode;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      endDrawer: new Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.greenAccent,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text('Dark/Light Mode:'),
                        ),
                        Container(
                          child: IconButton(
                            onPressed: (){
                              _selectThemeMode(context);
                            },
                            icon: Icon(Icons.wb_sunny,color: Colors.redAccent,),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      //margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Welcome:' + mobile,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    // Container(
                    //   child: Text(
                    //     mobile,
                    //     style: TextStyle(fontSize: 20),
                    //   ),
                    // ),
                    Center(
                      child: Container(
                        width: 200,
                        child: TextButton(
                          onPressed: () {
                            storage.delete(key: 'token');
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (builder) => Login()));
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'login', (route) => false);
                          },
                          child: Text('Logout'),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (c) => MyCoursePage()));
                },
                child: ListTile(
                  title: Text('My Courses'),
                  trailing: Icon(
                    FontAwesome.arrow_circle_o_right,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Coming Soon'),
                    duration: Duration(seconds: 1),
                  ));
                },
                child: ListTile(
                  title: Text('Apply for Examination'),
                  trailing: Icon(
                    FontAwesome.arrow_circle_o_right,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Coming Soon')));
                },
                child: ListTile(
                  title: Text('Queries'),
                  trailing: Icon(
                    FontAwesome.arrow_circle_o_right,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // title: SizedBox(
        //   height: 40,
        //     child: Image.network(
        //   'https://image.flaticon.com/icons/png/512/4019/4019707.png',
        //   fit: BoxFit.contain,
        // )),
        title: Container(
          height: 150,
          child:
              Image.network('http://computerzirna.in/storage/media/city.png'),
        ),
        //title: Text('Computer Zirna',style: TextStyle(color: Colors.black),),
        actions: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: IconButton(
                onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                icon: Icon(
                  FontAwesome.user,
                  color: Colors.redAccent,
                ),
              )),
          // Icon(Icons.window,color: Colors.redAccent,)
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: HomeScreenWidget(),
      ),
    );
  }
}
