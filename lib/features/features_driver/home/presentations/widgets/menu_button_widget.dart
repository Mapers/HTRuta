import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  const MenuButtonWidget({Key key, @required this.parentScaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 10,
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(100.0),),
        ),
        child: IconButton(
          icon: Icon(Icons.menu,size: 20.0,color: blackColor),
          onPressed: () => parentScaffoldKey.currentState.openDrawer(),
        ),
      )
    );
  }
}