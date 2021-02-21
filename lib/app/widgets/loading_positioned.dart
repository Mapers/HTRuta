import 'package:flutter/material.dart';

class LoadingPositioned extends StatelessWidget {
  final String label;
  const LoadingPositioned({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            label != null ? Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(label, style: TextStyle(fontSize: 14, color: Colors.white))
            ) : Container()
          ],
        ),
      ),
    );
  }
}