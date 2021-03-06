import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String phoneNumber = '';
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 80),
            child: Form(
              child: Column(
                children: [
                  Container(
                      width: 150,
                      // child: Text('LOGIN',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      child: Image(
                        image: AssetImage('images/locksmith.png'),
                      )),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text('LOGIN',
                          // style: TextStyle(
                          //   fontSize: 50,
                          //   fontWeight: FontWeight.bold,
                          //   color: Colors.black38,
                          //   letterSpacing: 7.0,
                          // ),
                          style: TextStyle(fontSize: 40, letterSpacing: 5)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 40, right: 40),
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                          hintText: 'Enter your mobile number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.phone_iphone,
                            color: Colors.red,
                          )),
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: TextButton(
                        child: Text(
                          'Send OTP',
                          style: TextStyle(fontSize: 17),
                        ),
                        onPressed: () => {
                          if (_phoneController.text.length != 10)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Enter valid mobile number'),
                                ),
                              )
                            }
                          else
                            {sendOtp()}
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
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

  void sendOtp() async {
    String mob = this.phoneNumber;
    var url =
        Uri.parse('http://computerzirna.in/api/auth/otp/send?phone_no=$mob');

    print(url);
    var response = await http
        .get(url, headers: {HttpHeaders.contentTypeHeader: 'Application/json'});

    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      print(this.phoneNumber);
      Navigator.push(context, MaterialPageRoute(builder: (builder) {
        return VerifyOtp(
            otp: decode['otp'].toString(), phone_no: this.phoneNumber);
      }));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please Enter Phone Number')));
    }
  }
}
