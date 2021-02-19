import 'package:flutter/material.dart';

class EmergingMessage {
  static void showWithBuildContext({@required BuildContext context, @required String message}){
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  static void showWithScaffoldState(GlobalKey<ScaffoldState> scaffoldKey, String message){
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
