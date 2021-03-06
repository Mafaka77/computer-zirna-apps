// @dart=2.9
import 'package:computer_zirna/Providers/TemeModeManager.dart';
import 'package:computer_zirna/screens/BuyClickScreen.dart';
import 'package:computer_zirna/screens/CourseDetailScreen.dart';
import 'package:computer_zirna/screens/HomePage.dart';
import 'package:computer_zirna/screens/MainScreen.dart';
import 'package:computer_zirna/screens/PaymentSuccessScreen.dart';
import 'package:computer_zirna/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';
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
    return ThemeModeHandler(
         manager: ExampleThemeModeManager(),
        builder: (ThemeMode themeMode){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Computer zirna',
            themeMode:themeMode,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Colors.red,
                fontFamily: 'Poppins'
            ),
            darkTheme: ThemeData(brightness: Brightness.dark,fontFamily: 'Poppins'),
            // home:Valid()
            initialRoute: a==null?'login':'/',
            routes: {
              '/':(context)=>SplashScreen(),
              'login':(context)=>Login(),
              'splash':(context)=>PaymentSuccessScreen(),
              'main':(context)=>MainScreen(),
              '/buy-screen':(context)=>BuyClickScreen(),
              '/home':(context)=>HomePage(),
            },
          );
        },
        );
  }
//   print(a);

}