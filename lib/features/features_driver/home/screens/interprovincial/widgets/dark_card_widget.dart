import 'package:flutter/material.dart';

class DarkCardWidget extends StatelessWidget {
  final double top;
  final String text;
  const DarkCardWidget({Key key, this.top = 120, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: Card(
        color: Colors.black,
        elevation: 20,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 320,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(text, style: TextStyle(color: Colors.white)),
        )
      ),
    );
  }
}