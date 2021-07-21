import 'package:computer_zirna/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../screens/MainScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerifyOtp extends StatefulWidget {
  final String otp;
  final String phone_no;

  VerifyOtp({required this.otp, required this.phone_no});

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  late String enteredOtp;
  bool loading = false;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Verify OTP'),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 50, left: 40, right: 40),
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //         hintText: 'Enter OTP', border: OutlineInputBorder()),
                    //     keyboardType: TextInputType.number,
                    //     onChanged: (value){
                    //       setState(() {
                    //
                    //       });
                    //     },
                    //   ),
                    // ),
                    Center(
                      child: Container(
                          width: 100,
                          margin: EdgeInsets.only(bottom: 20),
                          child: Image(
                            image: AssetImage('images/password.png'),
                          )),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Verification Code',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    PinPut(
                      fieldsCount: 4,
                      onSubmit: (String pin) => updateOtp(pin, context),
                      focusNode: _pinFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(5.0)),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                          border: Border.all(color: Colors.redAccent)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                resend();
                              },
                              child: Text(
                                'Resend?',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: SizedBox(
                          width: 500,
                          height: 50,
                          child: TextButton(
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 17),
                            ),
                            onPressed: () {
                              login();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
  void resend() async{
    String mob = this.widget.phone_no;
    var url =
    Uri.parse('http://computerzirna.in/api/auth/otp/resend?phone_no=$mob');
    // Map data={'phone':this.phoneNumber};
    // var body=jsonEncode(data);
    print(url);
    var response = await http
        .get(url, headers: {HttpHeaders.contentTypeHeader: 'Application/json'});
    //print(response);
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      //print(this.phoneNumber);
      // Navigator.push(context, MaterialPageRoute(builder: (builder) {
      //   return VerifyOtp(
      //       otp: decode['otp'].toString(), phone_no: this.phoneNumber);
      // }
      // ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Check OTP')));
    }
  }

  void click() {
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (c)=>MainScreen(),
    //     )
    // );
    print(this.widget.phone_no);
  }

  void login() async {
    // if(this.enteredOtp==this.widget.otp){
    //   setState(() {
    //     this.loading=true;
    //   });
    final storage = new FlutterSecureStorage();
    var url = Uri.parse('http://computerzirna.in/api/auth/otp/verify');
    var response = await http.post(
      url, body: {'phone_no': this.widget.phone_no, 'otp': this.enteredOtp},
      // headers: {'Content-Type': 'application/json','Accept':'application/json'}
    );
    setState(() {
      this.loading = false;
    });
    var decode = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      storage.write(key: 'token', value: decode['data'].toString());
      // var b=await storage.read(key: 'token');
      // print(b);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (c) => MainScreen(),
      ));
    } else {
      return null;
    }
  }

  void updateOtp(String pin, BuildContext context) {
    setState(() {
      this.enteredOtp = pin.toString();
    });
  }
}
