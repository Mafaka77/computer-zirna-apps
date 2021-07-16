import 'package:computer_zirna/screens/LoginScreen.dart';
import 'package:computer_zirna/screens/MyCoursePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/HomeScreenWidget.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final storage = new FlutterSecureStorage();
  var mobile='';
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
      var d=jsonDecode(response.body)['data']['phone_no'];
      setState(() {
        mobile=d.toString();
      });
      print(mobile);
    } else {
      throw Exception('Failed to load ');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myData();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        endDrawer: new Drawer(
          child: ListView(
            children: [
             Container(
               color:Colors.greenAccent,
               child: DrawerHeader(
                 child: Column(
                   children: [
                     Container(
                       margin:EdgeInsets.only(top:10),
                       child: Text('Welcome',style: TextStyle(fontSize: 20),),
                     ),
                     Container(
                       child: Text(mobile,style: TextStyle(fontSize: 30),),
                     ),
                     Container(
                       width: 120,
                       child: TextButton(
                         onPressed: (){
                           storage.delete(key: 'token');
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Login()));
                         },
                         child: Text('Logout'),
                         style: ButtonStyle(
                           foregroundColor: MaterialStateProperty.all(Colors.white),
                           backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                         ),
                       )
                     )
                   ],
                 ),
               ),
             ),
              Container(
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (c)=>MyCoursePage()));
                  },
                  child: ListTile(
                    title: Text('My Courses'),
                    trailing: Icon(FontAwesome.arrow_circle_o_right,color: Colors.greenAccent,),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: (){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coming Soon')));
                  },
                  child: ListTile(
                    title: Text('Apply for Examination'),
                    trailing: Icon(FontAwesome.arrow_circle_o_right,color: Colors.greenAccent,),
                  ),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: (){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coming Soon')));
                  },
                  child: ListTile(
                    title: Text('Queries'),
                    trailing: Icon(FontAwesome.arrow_circle_o_right,color: Colors.greenAccent,),
                  ),
                ),
              )
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
                    FontAwesome5.user_circle,
                    color: Colors.redAccent,
                  ),
                )),
            // Icon(Icons.window,color: Colors.redAccent,)
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(child: HomeScreenWidget()));
  }
}
