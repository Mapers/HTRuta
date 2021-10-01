import 'dart:io';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

 class NavigationPage extends StatefulWidget {
   @override
   NavigationPageState createState() => NavigationPageState();
 }

 class NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();
        // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return WebView(
       initialUrl: 'https://waze.com/ul?ll=-13.169017,-74.213279&navigate=yes',
    );
   }
 }