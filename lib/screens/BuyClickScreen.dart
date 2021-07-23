import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/PaymentSuccessScreen.dart';

class BuyClickScreen extends StatefulWidget {
  // const BuyClickScreen({Key? key}) : super(key: key);
  final int id;

  BuyClickScreen(this.id);

  @override
  _BuyClickScreenState createState() => _BuyClickScreenState();
}

class _BuyClickScreenState extends State<BuyClickScreen> {
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        _dobController.value = _dobController.value.copyWith(
          text: currentDate.toString(),
          selection: TextSelection.collapsed(
            offset: _dobController.value.selection.baseOffset +
                currentDate.toString().length,
          ),
        );
      });
  }

  String order_id = '';
  int sub_id = 0;

  final _fullNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    'PLEASE FILL ALL THE FORMS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Student' 's Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _fatherNameController,
                  decoration: InputDecoration(
                    labelText: 'Father' 's Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 500,
                  height: 50,
                  child: TextButton(
                    onPressed: () => {submit()},
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pinkAccent),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {
    var a = this.widget.id;
    try {
      // print('hello');
      String fullName = _fullNameController.text;
      String fatherName = _fatherNameController.text;
      String address = _addressController.text;
      String dob = _dobController.text;
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: 'token');
      var url = Uri.parse('http://computerzirna.in/api/subscription/create');
      final response = await http.post(url, body: {
        'full_name': fullName,
        'father_name': fatherName,
        'address': address,
        'course_id': a.toString()
      }, headers: {
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        int sub_id = jsonDecode(response.body)['data']['id'];
        String order_id = jsonDecode(response.body)['data']['order_id'];
        //print(this.widget.id);
        this.setState(() {
          this.order_id = order_id;
          this.sub_id = sub_id;
        });
        openCheckout();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please fill all the forms')));
      }
    } catch (e) {
      print(e);
    }
    // print('Hello');
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_Pwezzwm3noTCIt',
      'amount': 2000,
      'name': 'Computer zirna',
      'order_id': order_id,
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse sresponse) {
    print('sign ' + sresponse.signature);
    print('my order id ' + order_id);
    print('th order id ' + sresponse.orderId);

    this.verifyPayment(
        sresponse.paymentId, sresponse.signature, sresponse.orderId);
  }

  void verifyPayment(var paymentId, var signature, var order) async {
    try {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: 'token');
      var url = Uri.parse('http://computerzirna.in/api/subscription/verify');
      var res = await http.post(url, body: {
        'razorpay_order_id': order,
        'subscription_id': sub_id.toString(),
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      }, headers: {
        'Authorization': 'Bearer $token'
      });
      if (res.statusCode == 200) {
        print(res.body);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (b) => PaymentSuccessScreen()));

        //Navigator.pop(context);
      } else {
        print(res.body.toString());
      }
    } catch (error) {
      print(error);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }
}
