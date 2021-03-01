import 'package:flutter/material.dart';

class PositionedSeatManagerWidget extends StatelessWidget {
  final Widget child;
  const PositionedSeatManagerWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(top: 10, right: 10, bottom: 3, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)
          )
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 120,
                  child: OutlineButton.icon(
                    icon: Icon(Icons.exposure_minus_1),
                    label: Expanded(
                      child: Text('Asiento disponible', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ),
                    onPressed: (){},
                  )
                ),
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.green
                    ),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('9'),
                      Icon(Icons.airline_seat_recline_normal_rounded, color: Colors.green)
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: OutlineButton.icon(
                    icon: Icon(Icons.exposure_plus_1),
                    label: Expanded(
                      child: Text('Asiento disponible', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ),
                    onPressed: (){},
                  )
                ),
              ],
            ),
            child ?? Container()
          ],
        )
      )
    );
  }
}