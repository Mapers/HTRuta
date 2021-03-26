import 'package:HTRuta/app/widgets/loading_fullscreen.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPassengersFullScreenDialog extends StatefulWidget {
  final String documentId;
  final List<PassengerEntity> passengers;
  ListPassengersFullScreenDialog(this.passengers, {Key key, @required this.documentId}) : super(key: key);

  @override
  _ListPassengersFullScreenDialogState createState() => _ListPassengersFullScreenDialogState();
}

class _ListPassengersFullScreenDialogState extends State<ListPassengersFullScreenDialog> {

  List<PassengerEntity> passengers;
  LoadingFullScreen _loadingFullScreen = LoadingFullScreen();

  @override
  void initState() { 
    super.initState();
    passengers = widget.passengers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pasajeros'),
      ),
      body: ListView.separated(
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: passengers.length,
        padding: EdgeInsets.all(15),
        itemBuilder: (ctx, i) => getItem(i, passengers[i])
      ),
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
            Icon(Icons.person_pin_circle_outlined),
            SizedBox(width: 5),
            Expanded(
              child: Text(passenger.destination),
            )
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
            onPressed: (){
              removePassenger(index, passenger);
              Navigator.of(ctx).pop();
            },
            child: Text('Liberar asientos'),
          )
        ]
      )
    );
  }

  Future<void> removePassenger(int index, PassengerEntity passenger) async{
    InterprovincialDataDriverFirestore interprovincialDataFirestore = getIt<InterprovincialDataDriverFirestore>();
    _loadingFullScreen.show(context, label: 'Liberando asientos...');
    int newAvailableSeats = await interprovincialDataFirestore.releaseSeatsFromPasenger(documentId: widget.documentId, passenger: passenger);
    _loadingFullScreen.close();
    if(newAvailableSeats == null){
      return;
    }
    setState(() => passengers.removeAt(index));
    BlocProvider.of<InterprovincialDriverBloc>(context).add(SetLocalAvailabelSeatInterprovincialDriverEvent(newSeats: newAvailableSeats));
    if(passengers.isEmpty){
      await Future.delayed(Duration(milliseconds: 100));
      Navigator.of(context).pop();
    }
  }
}