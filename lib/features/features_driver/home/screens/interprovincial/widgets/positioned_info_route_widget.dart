import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PositionedInfoRouteWidget extends StatelessWidget {
  final InterprovincialRouteInServiceEntity route;
  final DateTime routeStartDateTime;
  final bool showDataTime;
  const PositionedInfoRouteWidget({Key key, @required this.route, @required this.routeStartDateTime, this.showDataTime = true}) : super(key: key);

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
                  Expanded(
                    child: Text(route.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.trip_origin, color: Colors.black45, size: 19),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      children: [
                        Text(route.fromLocation.streetName, style: TextStyle(fontSize: 12)),
                        Text('${route.fromLocation.districtName} - ${route.fromLocation.provinceName}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54, fontSize: 11))
                      ],
                    ),
                  )
                ],
              ),
              Icon(Icons.more_vert, size: 15, color: Colors.black26),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.red, size: 19),
                  SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      children: [
                        Text(route.toLocation.streetName, style: TextStyle(fontSize: 12),),
                        Text('${route.toLocation.districtName} - ${route.toLocation.provinceName}', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54, fontSize: 11))
                      ],
                    ),
                  )
                ],
              ),
              BlocBuilder<InterprovincialDriverBloc, InterprovincialDriverState>(
                builder: (ctx, state){
                  DataInterprovincialDriverState data = state;
                  return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${toStringFirebaseIntHumanStatus(data.status)}', style: TextStyle(fontWeight: FontWeight.w600),),
                      ],
                    ),
                  );
                }
              ),
              SizedBox(height: showDataTime ? 10 : 0),
              showDataTime ? Row(
                children: [
                  Icon(Icons.departure_board),
                  SizedBox(width: 5),
                  Text('${routeStartDateTime.formatOnlyTimeInAmPM} ${routeStartDateTime.formatOnlyDate}', style: TextStyle(color: Colors.black54)),
                ],
              ) : Container()
            ],
          )
        ),
      )
    );
  }
}