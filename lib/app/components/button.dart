import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final String text;
  final Function onPressed;
  final EdgeInsets margin;
  final MainAxisAlignment mainAxisAlignment;
  const Button({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.color,
    this.margin,
    this.mainAxisAlignment:MainAxisAlignment.center,
    this.height,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      child: Row(
        mainAxisAlignment: this.mainAxisAlignment,
        children: <Widget>[
          _getButton()
        ]
      ),
    );
  }

  Widget _getButton( ){
    double _width = this.width;
    double _height = this.height;
    return ConstrainedBox(
      constraints: new BoxConstraints(
        minWidth: _width == null ? 280 : _width ,
        minHeight: _height == null ? 45 : _height,
      ),
      child: RaisedButton(
        color: color,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: this.onPressed,
        child: Text(this.text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
      ),
    );
  }
}