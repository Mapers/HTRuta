import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/models/minutes_response.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';

class InformationDriveNegotation extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  InformationDriveNegotation({Key key, this.availablesRoutesEntity}) : super(key: key);

  @override
  _CardInformationDriveState createState() => _CardInformationDriveState();
}

class _CardInformationDriveState extends State<InformationDriveNegotation> {
  final pickUpApi = PickupApi();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15,),
              Text(widget.availablesRoutesEntity.route.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(Icons.face, color: Colors.black87),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(widget.availablesRoutesEntity.route.driverName,
                        style: TextStyle(color: Colors.black87, fontSize: 14)),
                  ),
                ],
              ),
              Row(
                    children: [
                      Icon(Icons.trip_origin, color: Colors.amber),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                            widget.availablesRoutesEntity.route.fromLocation.streetName,
                            style: TextStyle(color: Colors.black87, fontSize: 14)),
                      ),
                    ],
                  ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.availablesRoutesEntity.route.toLocation.streetName,
                      style: TextStyle(color: Colors.black87, fontSize: 14)
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.airline_seat_recline_normal_rounded, color: Colors.green),
                  SizedBox(width: 8),
                  Text(widget.availablesRoutesEntity.availableSeats.toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.black87),
                  SizedBox(width: 5),
                  Text(
                    widget.availablesRoutesEntity.routeStartDateTime.formatOnlyTimeInAmPM,
                    style: TextStyle(color: Colors.black87, fontSize: 14)
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.calendar_today, color: Colors.black87),
                  SizedBox(width: 5),
                  Text(
                    widget.availablesRoutesEntity.routeStartDateTime.formatOnlyDate,
                    style: TextStyle(color: Colors.black87, fontSize: 14)
                  ),
                ],
              ),
              FutureBuilder(
                future: pickUpApi.calculateMinutes( widget.availablesRoutesEntity.route.fromLocation.latLang.latitude, widget.availablesRoutesEntity.route.fromLocation.latLang.longitude, widget.availablesRoutesEntity.route.toLocation.latLang.latitude, widget.availablesRoutesEntity.route.toLocation.latLang.longitude),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasError) return Container();
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting: return Container();
                    case ConnectionState.none: return Container();
                    case ConnectionState.active: {
                      final AproxElement element = snapshot.data;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/image/tracking.png',width: 22,height: 22,),
                              SizedBox(width: 8,),
                              Text(element.distance.text),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset('assets/image/pngwing.png',width: 22,height: 22,),
                              SizedBox(width: 8,),
                              Text(element.duration.text),
                            ],
                          ),
                        ]
                      );
                    }
                    case ConnectionState.done: {
                      final AproxElement element = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/image/tracking.png',width: 22,height: 22,),
                                SizedBox(width: 8,),
                                Text(element.distance.text),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset('assets/image/pngwing.png',width: 22,height: 22,),
                                SizedBox(width: 8,),
                                Text(element.duration.text),
                              ],
                            ),
                          ]
                        ),
                      );
                    }
                  }
                  return Container();
                }
              ),
              SizedBox(height: 15,),
      ],
    );
  }
}