import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  @override
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  final _key = UniqueKey();

  final String screenName = 'TERMS';
  bool initilized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuScreens(activeScreenName: screenName),
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: WebView(
        key: _key,
        initialUrl: 'https://flutter.dev/tos',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          if(!initilized){
            _controller.complete(webViewController);
            initilized = true;
          }
        },
      ),
    );
  }
}
