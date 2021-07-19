import 'package:computer_zirna/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => MainScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Container(
              child: Text(
                'CITY COMPUTER CENTER',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text('MIZO TAWNGA COMPUTER ZIRNA'),
            ),
            Container(
              height: 400,
              margin: EdgeInsets.only(left: 100, right: 100, top: 120),
              child: Center(
                  child: Image(
                image: AssetImage('images/city.png'),
                fit: BoxFit.contain,
              )),
            ),
            Container(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
