import 'package:computer_zirna/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 200, left: 80, right: 80),
                  child: Image(
                    image: AssetImage('images/credit-card.png'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    'Payment Successful',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 250,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (builder) => MainScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Return to Home',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
