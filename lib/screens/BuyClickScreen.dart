import 'package:flutter/material.dart';

class BuyClickScreen extends StatefulWidget {
  const BuyClickScreen({Key? key}) : super(key: key);

  @override
  _BuyClickScreenState createState() => _BuyClickScreenState();
}

class _BuyClickScreenState extends State<BuyClickScreen> {
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
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Student''s Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child:TextField(
                  decoration: InputDecoration(
                    labelText: 'Father''s Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child:TextField(
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
                    onPressed: ()=>{},
                    child: Text('Save & Proceed to Checkout',style: TextStyle(fontSize: 20),),
                    style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.white)) ,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text('Important Notes:'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
