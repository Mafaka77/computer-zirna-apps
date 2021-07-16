import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: Center(
                  child: Image(
                    image: AssetImage('images/city.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                child: Center(
                    child: Text(
                  'MIZO TAWNGA COMPUTER ZIRNA',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                )),
              ),
              Container(
                child: Center(child: Text('Govt Approved Institution',style: TextStyle(fontSize: 16),)),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesome.phone_square,color: Colors.greenAccent,),
                        Text(' 9089527410')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(FontAwesome.map_marker,color: Colors.indigo,),
                        Text('Thakthing Bazar,Mission Veng')
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
