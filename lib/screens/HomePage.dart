import 'package:flutter/material.dart';
import '../widgets/HomeScreenWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 40,
              child: Image.network(
            'https://image.flaticon.com/icons/png/512/4019/4019707.png',
            fit: BoxFit.contain,
          )),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(child: HomeScreenWidget()));
  }
}
