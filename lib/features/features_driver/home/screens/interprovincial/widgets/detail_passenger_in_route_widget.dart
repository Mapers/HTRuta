import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_location_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatailPassengerInRouteWidget extends StatelessWidget {
  const DatailPassengerInRouteWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterprovincialDriverLocationBloc,
        InterprovincialDriverLocationState>(
      builder: (ctx, state) {
        DataInterprovincialDriverLocationState data = state;
        if (data.passengerSelected == null) {
          return Container();
        }
        PassengerEntity passenger = data.passengerSelected;
        LatLng passengerLatLang = passenger.toLocation.latLang;
        double distance = LocationUtil.calculateDistanceInKilometers(
            passengerLatLang, data.location.latLang);
        return Container(
          width: 300,
          child: Card(
            child: Stack(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(bottom: 8, left: 8, right: 12, top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                                height: 50,
                                width: 50,
                                color: Theme.of(context).primaryColor,
                                child: CachedNetworkImage(
                                    imageUrl: passenger.urlImage,
                                    fit: BoxFit.cover))),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text(passenger.fullNames,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                        SizedBox(width: 30),
                      ]),
                      SizedBox(height: 10),
                      Text(passenger.toLocation.streetName,
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54)),
                      SizedBox(height: 10),
                      Text('${distance.toStringAsFixed(2)}Km de distancia',
                          style: TextStyle(fontSize: 12, color: Colors.black54))
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      BlocProvider.of<InterprovincialDriverLocationBloc>(
                              context)
                          .add(
                              RemovePassengerSelectedInterprovincialDriverLocationEvent());
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
