import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:flutter/material.dart';

class PositionedInfoRouteWidget extends StatelessWidget {
  final InterprovincialRouteEntity route;
  const PositionedInfoRouteWidget({Key key, @required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 65,
      top: 0,
      right: 65,
      child: Container(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 2),
                      borderRadius: BorderRadius.circular(50)
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(route.fromLocation.name),
                  )
                ],
              ),
              Icon(Icons.more_vert, size: 15, color: Colors.black26,),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.red, size: 18),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(route.toLocation.name),
                  )
                ],
              ),
            ],
          )
        ),
      )
    );
  }
}