import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/qualification_widget.dart';
import 'package:HTRuta/app/widgets/card_informativa_location.dart';
import 'package:HTRuta/app/widgets/loading_fullscreen.dart';
import 'package:HTRuta/core/utils/extensions/double_extension.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/entities/qualification_entity.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ListPassengersFullScreenDialog extends StatefulWidget {
  final String serviceId;
  final String documentId;
  ListPassengersFullScreenDialog({Key key, @required this.documentId, @required this.serviceId}) : super(key: key);

  @override
  _ListPassengersFullScreenDialogState createState() => _ListPassengersFullScreenDialogState();
}

class _ListPassengersFullScreenDialogState extends State<ListPassengersFullScreenDialog> {

  LoadingFullScreen _loadingFullScreen = LoadingFullScreen();
  void lauchWhasApp({String number, String message})async{
    var url = 'whatsapp://send?phone=51$number&text=$message';
    await  canLaunch(url)? launch(url): print('Cantdsds');
  }

  @override
  Widget build(BuildContext context) {
    InterprovincialDataDriverFirestore interprovincialDataFirestore = getIt<InterprovincialDataDriverFirestore>();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text('Pasajeros'),
      ),
      body: StreamBuilder<List<PassengerEntity>>(
        stream: interprovincialDataFirestore.getStreamActivePassengers(documentId: widget.documentId),
        builder: (ctx, asyncSnapshot){
          if(asyncSnapshot.connectionState == ConnectionState.active){
            List<PassengerEntity> passengers = asyncSnapshot.data;
            if(passengers.isEmpty){
              return Center(
                child: Text('- Sin pasajeros -', style: TextStyle(fontStyle: FontStyle.italic)),
              );
            }
            return ListView.separated(
              separatorBuilder: (ctx, i) => Divider(),
              itemCount: passengers.length,
              padding: EdgeInsets.all(15),
              itemBuilder: (ctx, i) => getItem(i, passengers[i])
            );
          }
          return Container();
        }
      )
    );
  }

  Widget getItem(int index, PassengerEntity passenger){
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.black87),
                SizedBox(width: 5),
                Expanded(
                  child: Text(passenger.fullNames),
                ),
                passenger.cellPhone == null ? Container():IconButton(
                  icon: Icon(Icons.call, color: Colors.blue,),
                  onPressed: ()async{
                    await launch('tel:+51'+ passenger.cellPhone);
                  }
                ),
                passenger.cellPhone == null ? Container():IconButton(
                  icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green, ),
                  onPressed: (){
                    lauchWhasApp(number: passenger.cellPhone, message: 'Hola querido pasajero');
                  }
                ),
                IconButton(
                  icon: Icon(Icons.map,color: Colors.orange,),
                  onPressed: (){
                    //? Codigo dari
                  }
                ),
              ],
            ),
            SizedBox(height: 5),
            // Row(
            //   children: [
            //     Icon(Icons.trip_origin),
            //     SizedBox(width: 5),
            //     Expanded(
            //       flex: 2,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(passenger.currentLocation?.streetName ?? 'Sin mapear', style: TextStyle(fontSize: 13)),
            //           Text(passenger.currentLocation?.addressAdministrative ?? 'Esperando información...', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54, fontSize: 12)),
            //         ],
            //       ),
            //     ),
            //     Expanded(
            //       flex: 1,
            //       child: Column(
            //         children: [
            //           // Text(passenger.distanceInMinutes.toTimeString(), style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black54)),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(passenger.distanceInMeters.toDistanceString(), style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black54)),
            ),
            CardInformationLocation(location: passenger.currentLocation,icon: Icons.trip_origin, iconColor: Colors.amber,),
            SizedBox(height: 5),
            CardInformationLocation(location: passenger.toLocation,icon: Icons.location_on,iconColor: Colors.red,),
            SizedBox(height: 5),
            // Row(
            //   children: [
            //     Icon(Icons.person_pin_circle_outlined, color: Colors.black45),
            //     SizedBox(width: 5),
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(passenger.toLocation.streetName, style: TextStyle(fontSize: 13)),
            //           Text(passenger.toLocation.addressAdministrative, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54, fontSize: 12)),
            //         ],
            //       ),
            //     )
            //   ],
            // ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.airline_seat_recline_normal_outlined, color: Colors.green),
                SizedBox(width: 5),
                Text(passenger.seats.toString()),
                Spacer(),
                RaisedButton(
                  onPressed: () => questionRemovePassenger(index, passenger),
                  child: Text('Liberar asientos'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void questionRemovePassenger(int index, PassengerEntity passenger){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Liberar asientos'),
        content: Text('Esta acción hará que se liberen los asientos, aumentando la cantidad de asientos disponibles.'),
        actions: [
          OutlineButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar'),
          ),
          RaisedButton(
            onPressed: ()async{
              await removePassenger(index, passenger);
              Navigator.of(ctx).pop();
              qualificationShowDialog(passenger: passenger);
            },
            child: Text('Sí, liberar asientos'),
          )
        ]
      )
    );
  }
  void qualificationShowDialog({@required PassengerEntity passenger}){
    showDialog(
      context: context,
      builder: (context) {
        return QualificationWidget(
          title: 'Califica al pasajero',
          nameUserQuelify: passenger.fullNames,
          routeTraveled: passenger.destination,
          onAccepted: (start, commentary) async{
            await getIt<InterprovincialClientRemoteDataSoruce>().qualificationRequest(qualification: QualificationEntity(
              passengerId: passenger.id,
              comment: commentary,
              starts: start,
              serviceId: widget.serviceId,
              qualifying_person: TypeEntityEnum.driver
            ));
          },
          onSkip: (){},
        );
      }
    );
  }

  Future<void> removePassenger(int index, PassengerEntity passenger) async{
    InterprovincialDataDriverFirestore interprovincialDataFirestore = getIt<InterprovincialDataDriverFirestore>();
    InterprovincialDriverDataRemote interprovincialDriverDataRemote = getIt<InterprovincialDriverDataRemote>();
    _loadingFullScreen.show(context, label: 'Liberando asientos...');
    int newAvailableSeats = await interprovincialDataFirestore.releaseSeatsFromPasenger(documentId: widget.documentId, passenger: passenger);
    interprovincialDriverDataRemote.releaseSeats(serviceId: widget.serviceId, seats: passenger.seats);
    _loadingFullScreen.close();
    if(newAvailableSeats == null){
      return;
    }
    BlocProvider.of<InterprovincialDriverBloc>(context).add(SetLocalAvailabelSeatInterprovincialDriverEvent(newSeats: newAvailableSeats));
  }
}