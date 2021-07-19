import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions'),),
      body: const WebView(
        initialUrl: 'http://computerzirna.in/toc',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
