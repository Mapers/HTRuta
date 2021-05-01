import 'package:HTRuta/app/components/qualification_widget.dart';
import 'package:HTRuta/app/widgets/loading_fullscreen.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPassengersFullScreenDialog extends StatefulWidget {
  final String serviceId;
  final String documentId;
  ListPassengersFullScreenDialog({Key key, @required this.documentId, @required this.serviceId}) : super(key: key);

  @override
  _ListPassengersFullScreenDialogState createState() => _ListPassengersFullScreenDialogState();
}

class _ListPassengersFullScreenDialogState extends State<ListPassengersFullScreenDialog> {

  LoadingFullScreen _loadingFullScreen = LoadingFullScreen();

  @override
  Widget build(BuildContext context) {
    InterprovincialDataDriverFirestore interprovincialDataFirestore = getIt<InterprovincialDataDriverFirestore>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Pasajeros'),
      ),
      body: StreamBuilder<List<PassengerEntity>>(
        stream: interprovincialDataFirestore.getStreamPassengers(documentId: widget.documentId),
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
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.person, color: Colors.black87),
            SizedBox(width: 5),
            Expanded(
              child: Text(passenger.fullNames),
            )
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.trip_origin, color: Colors.black45),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(passenger.toLocation.streetName, style: TextStyle(fontSize: 13)),
                  Text(passenger.toLocation.addressAdministrative, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54, fontSize: 12)),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.person_pin_circle_outlined),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(passenger.currentLocation.streetName, style: TextStyle(fontSize: 13)),
                  Text(passenger.currentLocation.addressAdministrative, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text('10Km', style: TextStyle(fontSize: 13)),
                  Text('a 15 mins', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
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
          onAccepted: (start,commentary)async{
            //!la calificacion tiene que ir a el back-end
            print(start);
            print(commentary);
          },
          onSkip: (){
            //!la calificacion tiene que ir a el back-end
          },
        );
      }
    );
  }

  Future<void> removePassenger(int index, PassengerEntity passenger) async{
    InterprovincialDataDriverFirestore interprovincialDataFirestore = getIt<InterprovincialDataDriverFirestore>();
    InterprovincialDriverDataRemote interprovincialDriverDataRemote = getIt<InterprovincialDriverDataRemote>();
    _loadingFullScreen.show(context, label: 'Liberando asientos...');
    int newAvailableSeats = await interprovincialDataFirestore.releaseSeatsFromPasenger(documentId: widget.documentId, passenger: passenger);
    interprovincialDriverDataRemote.releaseSeats(passengerId: passenger.id, serviceId: widget.serviceId);
    _loadingFullScreen.close();
    if(newAvailableSeats == null){
      return;
    }
    BlocProvider.of<InterprovincialDriverBloc>(context).add(SetLocalAvailabelSeatInterprovincialDriverEvent(newSeats: newAvailableSeats));
  }
}