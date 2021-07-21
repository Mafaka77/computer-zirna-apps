import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Data {
  final int id;
  final String name;
  final String email;
  final String phone_no;

  Data(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone_no});

  factory Data.formJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone_no: json['phone_no']);
  }
}

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final storage = new FlutterSecureStorage();

  Future<Data> _myData() async {
    var auth_token = await storage.read(key: 'token');
    // print(auth_token);
    // var token='70|sblqr7H2YVsJaM64qCHVvna8lEpV89OrQ3SYqUN2';
    var url = Uri.parse('http://computerzirna.in/api/profile/me');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $auth_token'
    });
    if (response.statusCode == 200) {
      return Data.formJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load ');
    }
  }

  late Future<Data> futureData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureData = _myData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Data>(
          future: futureData,
          builder: (BuildContext context, snapshot) {
            //print(snapshot.data!.phone_no);
            if (snapshot.hasData) {
              return Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          radius: 100,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          (snapshot.data!.name) == null
                              ? 'Welcome:Users'
                              : 'Welcome :${snapshot.data!.name}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          'Mobile:${snapshot.data!.phone_no}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: TextButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.pinkAccent),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.greenAccent)),
                          onPressed: () => {},
                          child: Text('Update Account'),
                        ),
                      ),
                    ),
                    Container()
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
