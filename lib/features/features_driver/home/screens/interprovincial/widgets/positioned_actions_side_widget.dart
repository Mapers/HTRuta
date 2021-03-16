import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_firestore.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';

class PositionedActionsSideWidget extends StatelessWidget {
  final String documentId;
  const PositionedActionsSideWidget({Key key, @required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InterprovincialDataFirestore interprovincialDataFirestore = getIt<InterprovincialDataFirestore>();
    return Positioned(
      right: 10,
      top: 180,
      child: Column(
        children: [
          StreamBuilder<List<PassengerEntity>>(
            stream: interprovincialDataFirestore.getListenerPassengers(documentId: documentId),
            builder: (ctx, asyncSnapshot){
              if(asyncSnapshot.connectionState == ConnectionState.active){
                int length = asyncSnapshot.data.length;
                return itemOption(
                  icon: Icons.group,
                  text: '$length Pasajero${length == 1 ? "" : "s"}',
                  onTap: () {
                    print('Pasajeros');
                  }
                );
              }
              return Container();
            }
          ),
          itemOption(
            icon: Icons.assignment_ind,
            text: 'Solicitudes',
            onTap: () {
              print('Solicitudes');
            }
          ),
        ],
      )
    );
  }

  Widget itemOption({@required IconData icon, @required String text, @required Function onTap}){
    return Card(
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