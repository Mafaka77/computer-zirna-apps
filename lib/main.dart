// @dart=2.9
import 'package:computer_zirna/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'screens/LoginScreen.dart';
import 'screens/VerifyOtpScreen.dart';
import './screens/MainScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String b='';
  final storage = new FlutterSecureStorage();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    storage.read(key: 'token').then((value) => {
      b=value
    });
     print(b);
    // if(b==null){
    //   return MaterialApp(
    //       title: 'Flutter Demo',
    //       theme: ThemeData(
    //         primarySwatch: Colors.blue,
    //       ),
    //       home:Login()
    //   );
    // }else {
    //   return MaterialApp(
    //       title: 'Flutter Demo',
    //       theme: ThemeData(
    //         primarySwatch: Colors.blue,
    //       ),
    //       home:MainScreen()
    //   );
    // }
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
        b==null?
        Login():
        MainScreen()
    );
  }
}
