import 'package:flutter/material.dart';

class LoadingPositioned extends StatelessWidget {
  final String label;
  const LoadingPositioned({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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