import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Privacy Policy'),),
      body:const WebView(
        initialUrl: 'http://computerzirna.in/privacy',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
