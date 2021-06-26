// @dart=2.9
import 'package:computer_zirna/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'screens/LoginScreen.dart';
import 'screens/VerifyOtpScreen.dart';
import './screens/MainScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
String a;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage=FlutterSecureStorage();
  a=await storage.read(key: 'token');
  runApp(MyApp());

}
//
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:Valid()
      initialRoute: a==null?'login':'/',
      routes: {
        '/':(context)=>MainScreen(),
        'login':(context)=>Login()
      },
    );
  }
//   print(a);

}