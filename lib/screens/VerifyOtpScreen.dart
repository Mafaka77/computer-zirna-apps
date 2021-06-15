import 'package:flutter/material.dart';
class VerifyOtp extends StatefulWidget {
  final String otp;
  final String phone_no;

  VerifyOtp({
    required this.otp,
    required this.phone_no
});

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('OTP'),
      ),
    );
  }
}
