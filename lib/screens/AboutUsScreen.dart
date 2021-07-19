import 'package:computer_zirna/screens/PrivacyPolicyScreen.dart';
import 'package:computer_zirna/screens/TermsScreen.dart';
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
                child: Center(child:const Text('Govt Approved Institution',style: TextStyle(fontSize: 16),)),
              ),
              Container(
                child: Center(child:const Text('Afilliated to MSCTE',style: TextStyle(fontSize: 16),)),
              ),
              Container(
                color: Colors.black12,
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesome.phone_square,color: Colors.greenAccent,),
                        const Text(' 9089527410',style: TextStyle(fontSize: 15),)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(FontAwesome.map_marker,color: Colors.indigo,),
                       const Text('Thakthing Bazar,Mission Veng',style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>PrivacyPolicy()));
                  },
                  child: ListTile(
                    title:const Text('Privacy Policy'),
                  ),
                ),
              ),
              Container(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>TermsScreen()));
                  },
                  child: ListTile(
                    title:const Text('Terms & Conditions'),
                  ),
                ),
              ),
              Container(
                child: ListTile(
                  title:const Text('Payment Terms'),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
