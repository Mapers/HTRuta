import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';

class PositionedActionsSideWidget extends StatelessWidget {
  final String documentId;
  final String serviceId;
  const PositionedActionsSideWidget({Key key, @required this.documentId, @required this.serviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InterprovincialDataDriverFirestore interprovincialDataFirestore = getIt<InterprovincialDataDriverFirestore>();
    return Positioned(
      right: 10,
      top: 200,
      child: Column(
        children: [
          StreamBuilder<List<PassengerEntity>>(
            stream: interprovincialDataFirestore.getStreamPassengers(documentId: documentId),
            builder: (ctx, asyncSnapshot){
              if(asyncSnapshot.connectionState == ConnectionState.active){
                int length = asyncSnapshot.data.length;
                return itemOption(
                  icon: Icons.group,
                  text: '$length Pasajero${length == 1 ? "" : "s"}',
                  onTap: length > 0 ? () {
                    Navigator.of(context).push(Routes.toListPassengersFullScreenDialog(documentId, serviceId));
                  } : null
                );
              }
              return Container();
            }
          ),
          StreamBuilder<List<InterprovincialRequestEntity>>(
            stream: interprovincialDataFirestore.getStreamEnabledRequests(documentId: documentId),
            builder: (ctx, asyncSnapshot){
              if(asyncSnapshot.connectionState == ConnectionState.active){
                int length = asyncSnapshot.data.length;
                return itemOption(
                  icon: Icons.assignment_ind,
                  text: '$length Solicitud${length == 1 ? "" : "es"}',
                  onTap: length > 0 ? () {
                    Navigator.of(context).push(Routes.toListInterprovincialRequestFullScreenDialog(documentId, serviceId));
                  } : null
                );
              }
              return Container();
            }
          )
        ],
      )
    );
  }

  Widget itemOption({@required IconData icon, @required String text, @required Function onTap}){
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Icon(icon, color: Colors.black87),
              SizedBox(width: 5),
              Text(text)
            ],
          )
        )
      ),
    );
  }
}