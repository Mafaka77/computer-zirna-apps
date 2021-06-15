import 'package:flutter/material.dart';
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
              margin: EdgeInsets.only(top: 200),
              child: Form(
                child: Column(
                  children: [
                    Container(
                      child: Text('LOGIN',style: TextStyle(fontSize: 30),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20,left: 40,right: 40),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Enter your mobile number',border: OutlineInputBorder()),
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        onChanged: (value){
                          setState(() {
                            phoneNumber=value;
                          });

                        },
                      ),
                    ),
                    Container(
                      width: 200,
                      child: TextButton(
                        child: Text('Send OTP'),
                        onPressed: ()=>{sendOtp()},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
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
    var url=Uri.parse('http://computerzirna.in/api/auth/otp/send');
    // Map data={'phone':this.phoneNumber};
    // var body=jsonEncode(data);

    var response=await http.get(url,headers: {"authkey": "template_id"},);
    // ignore: unrelated_type_equality_checks
    if(response.statusCode=='Otp sent'){
      var decode=jsonDecode(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (builder){
          return VerifyOtp(
            otp:decode['otp'].toString(),
            phone_no:this.phoneNumber
          );
      }));
    }else{
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(this.phoneNumber))
      );
    }
  }

}


