import 'package:flutter/material.dart';

class InterprovincialScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  InterprovincialScreen({Key key, @required this.parentScaffoldKey}) : super(key: key);

  @override
  _InterprovincialScreenState createState() => _InterprovincialScreenState();
}

class _InterprovincialScreenState extends State<InterprovincialScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('Esto es para interprovincial');
  }
}