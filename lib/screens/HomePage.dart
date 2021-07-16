import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/HomeScreenWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        endDrawer:new Drawer() ,
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
              child:IconButton(
                onPressed: ()=>_scaffoldKey.currentState!.openEndDrawer(),
                icon: Icon(FontAwesome5.user_circle,color: Colors.redAccent,),
              )
            ),
            // Icon(Icons.window,color: Colors.redAccent,)
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(child: HomeScreenWidget()));
  }
}
