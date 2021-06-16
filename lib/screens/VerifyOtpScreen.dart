import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  final String otp;
  final String phone_no;

  VerifyOtp({required this.otp, required this.phone_no});

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Verify OTP'),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 100, left: 40, right: 40),
          child: Column(
            children: [
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter OTP', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10),
                width: 400,
                child: TextButton(
                  child: Text('Submit'),
                  onPressed: () => {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
