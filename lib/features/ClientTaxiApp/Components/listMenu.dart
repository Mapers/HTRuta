import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListsMenu extends StatelessWidget {
  @required final String title;
  @required final VoidCallback onPress;

  ListsMenu({this.title,this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
              bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
            ),
          ),
          height: 44.0,
          child: Padding(
            padding: EdgeInsets.only(left: 10.0,),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 7,
                      child: Text(
                        title,
                        style: textStyle,
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Icon(
                        CupertinoIcons.forward,
                        color: CupertinoColors.lightBackgroundGray,
                        size: 28.0,)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
