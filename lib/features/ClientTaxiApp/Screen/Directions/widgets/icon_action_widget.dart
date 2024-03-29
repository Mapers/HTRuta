import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';

class IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  IconAction({this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 10.0,
        color: Colors.white,
        shape: CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: SizedBox(
              height: 65,
              width: 65,
              child: Icon(
                icon,
                size: 30,
                color: blackColor,
              )
          ),
        ),
      ),
    );
  }
}
