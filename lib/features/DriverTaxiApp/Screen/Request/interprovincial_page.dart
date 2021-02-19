import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/interprovincial_model.dart';
import 'package:flutter/material.dart';

class InterprovincialPage extends StatefulWidget {
  final InterprovincialModel interprovincial;
  InterprovincialPage({Key key, @required this.interprovincial}) : super(key: key);

  @override
  _InterprovincialPageState createState() => _InterprovincialPageState();
}

class _InterprovincialPageState extends State<InterprovincialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solicitud Interprovincial',
          style: TextStyle(color: blackColor),
        ),
        elevation: 2.0,
        iconTheme: IconThemeData(color: blackColor)
      ),
    );
  }
}