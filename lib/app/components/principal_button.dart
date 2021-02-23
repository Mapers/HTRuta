import 'package:flutter/material.dart';

class PrincipalButton extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final String text;
  final Function onPressed;
  final EdgeInsets margin;
  final MainAxisAlignment mainAxisAlignment;
  const PrincipalButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.color,
    this.margin,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.height,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          _getButton()
        ]
      ),
    );
  }

  Widget _getButton( ){
    double _width = width;
    double _height = height;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: _width ?? 280,
        minHeight: _height ?? 45,
      ),
      child: RaisedButton(
        color: color,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
      ),
    );
  }
}