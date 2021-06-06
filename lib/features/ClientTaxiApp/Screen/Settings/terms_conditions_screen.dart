import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/app_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  @override
  _TermsConditionsScreenState createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  final _key = UniqueKey();

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  final String screenName = 'TERMS';
  bool initilized = false;

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              final _state = _sideMenuKey.currentState;
              if (_state.isOpened)
                _state.closeSideMenu(); // close side menu
              else
                _state.openSideMenu();// open side menu
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
      )
    );
  }
}
