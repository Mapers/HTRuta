import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map_booking/DriverTaxiApp/theme/style.dart';

class ListsMenu extends StatelessWidget {
  @required final String title;
  @required final VoidCallback onPress;
  @required final IconData icon;
  @required final Color backgroundIcon;

  ListsMenu({this.title,this.onPress, this.icon, this.backgroundIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: new GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            border: const Border(
              bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
            ),
          ),
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.only(left: 10.0,),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: backgroundIcon,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Icon(icon,color: Colors.white,)
                  ),
                  SizedBox(width: 10.0,),
                  new Expanded(
                      flex: 7,
                      child: Text(
                        title,
                        style: textStyle,
                      )
                  ),
                  new Expanded(
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
