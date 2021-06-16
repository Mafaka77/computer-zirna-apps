import 'package:flutter/material.dart';
import '../widgets/HomeScreenWidget.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false,
      ),
      body:SingleChildScrollView(child: HomeScreenWidget())
    );
  }
}
