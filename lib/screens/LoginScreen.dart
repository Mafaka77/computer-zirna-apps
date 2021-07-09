import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../screens/VerifyOtpScreen.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phoneNumber='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
        child: Center(

            child: Container(
              margin: EdgeInsets.only(top: 70),
              child: Form(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      // child: Text('LOGIN',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      child: Image.network('https://image.flaticon.com/icons/png/512/1791/1791961.png',fit: BoxFit.cover,)
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50,left: 40,right: 40),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Enter your mobile number',border: OutlineInputBorder(),prefixIcon: Icon(Icons.phone_iphone,color: Colors.red,)),
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        onChanged: (value){
                          setState(() {
                            phoneNumber=value;
                          });

                        },
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 300,
                        height: 50,
                        child: TextButton(
                          child: Text('Send OTP'),
                          onPressed: ()=>{sendOtp()},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
  void sendOtp() async{
    String mob=this.phoneNumber;
    var url=Uri.parse('http://computerzirna.in/api/auth/otp/send?phone_no=$mob');
    // Map data={'phone':this.phoneNumber};
    // var body=jsonEncode(data);
  print(url);
    var response=await http.get(url,headers: {HttpHeaders.contentTypeHeader:'Application/json'});
    //print(response);
    if(response.statusCode==200){
      var decode=jsonDecode(response.body);
      print(this.phoneNumber);
      Navigator.push(context, MaterialPageRoute(builder: (builder){
          return VerifyOtp(
            otp:decode['otp'].toString(),
            phone_no:this.phoneNumber
          );
      }));
    }else{
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Enter Phone Number'))
      );
    }
  }

}


