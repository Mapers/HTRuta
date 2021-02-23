import 'package:flutter/material.dart';

class LoadingFullScreen {
  BuildContext _contextPopup;

  void show(BuildContext _parentContext, {String label}) async {
    _contextPopup = _parentContext;
    showDialog(
      context: _parentContext,
      barrierDismissible: false,
      child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
            ),
            label != null ? Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(label, style: TextStyle(fontSize: 14, color: Colors.white))
            ) : Container()
          ]
        )
      )
    );
  }

  void close(){
    if(_contextPopup != null){
      Navigator.of(_contextPopup).pop();
      _contextPopup = null;
    }
  }
}
