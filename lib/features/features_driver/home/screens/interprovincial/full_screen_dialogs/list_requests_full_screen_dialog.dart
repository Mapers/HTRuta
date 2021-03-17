import 'package:HTRuta/app/widgets/loading_fullscreen.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_firestore.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListRequestsFullScreenDialog extends StatefulWidget {
  final String documentId;
  final List<InterprovincialRequestEntity> interprovincialRequests;
  ListRequestsFullScreenDialog(this.interprovincialRequests, {Key key, @required this.documentId}) : super(key: key);

  @override
  _ListRequestsFullScreenDialogState createState() => _ListRequestsFullScreenDialogState();
}

class _ListRequestsFullScreenDialogState extends State<ListRequestsFullScreenDialog> {

  InterprovincialDataFirestore interprovincialDataFirestore = getIt<InterprovincialDataFirestore>();
  LoadingFullScreen _loadingFullScreen = LoadingFullScreen();
  List<InterprovincialRequestEntity> interprovincialRequests;

  @override
  void initState() { 
    super.initState();
    interprovincialRequests = widget.interprovincialRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
      ),
      body: ListView.separated(
        separatorBuilder: (ctx, i) => Divider(),
        itemCount: interprovincialRequests.length,
        padding: EdgeInsets.all(15),
        itemBuilder: (ctx, i) => getItem(i, interprovincialRequests[i])
      ),
    );
  }

  Widget getItem(int index, InterprovincialRequestEntity interprovincialRequest){
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.person, color: Colors.black87),
            SizedBox(width: 5),
            Expanded(
              child: Text(interprovincialRequest.fullNames),
            ),
            SizedBox(width: 15),
            Text('S/. ' +interprovincialRequest.price.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
            SizedBox(width: 15),
            IconButton(
              tooltip: 'Rechazar solicitud',
              icon: Icon(Icons.cancel, color: Colors.red,),
              onPressed: (){},
            )
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.trip_origin),
            SizedBox(width: 5),
            Expanded(
              child: Text(interprovincialRequest.from),
            ),
            SizedBox(width: 15),
            Icon(Icons.airline_seat_recline_normal_outlined, color: Colors.green),
            SizedBox(width: 5),
            Text(interprovincialRequest.seats.toString()),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.person_pin_circle_outlined, color: Colors.red),
            SizedBox(width: 5),
            Expanded(
              child: Text(interprovincialRequest.to),
            )
          ],
        ),
        SizedBox(height: 5),
        ButtonBar(
          children: [
            RaisedButton(
              onPressed: (){},
              child: Text('Contraofertar'),
            ),
            RaisedButton(
              onPressed: () => showAceptOfferDialog(index, interprovincialRequest),
              child: Text('Aceptar'),
            )
          ],
        ),
      ],
    );
  }

  void showAceptOfferDialog(int index, InterprovincialRequestEntity interprovincialRequest){
    DataInterprovincialDriverState data = BlocProvider.of<InterprovincialDriverBloc>(context).state;
    if(data.availableSeats < interprovincialRequest.seats){
      showDialogCantNotAccept();
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Estas seguro de aceptar la solicitud?'),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          RaisedButton(
            child: Text('Aceptar'),
            onPressed: () async{
              Navigator.of(ctx).pop();
              _loadingFullScreen.show(context, label: 'Aceptando solicitud...');
              int newAvailableSeats = await interprovincialDataFirestore.acceptRequest(documentId: widget.documentId, request: interprovincialRequest);
              _loadingFullScreen.close();
              if(newAvailableSeats == null){
                return;
              }
              setState(() => interprovincialRequests.removeAt(index));
              BlocProvider.of<InterprovincialDriverBloc>(context).add(SetLocalAvailabelSeatInterprovincialDriverEvent(newSeats: newAvailableSeats));
              if(interprovincialRequests.isEmpty){
                await Future.delayed(Duration(milliseconds: 100));
                Navigator.of(context).pop();
              }
            },
          )
        ],
      )
    );
  }

  void showDialogCantNotAccept(){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('No hay asientos suficientos para aceptar la solicitud'),
        actions: [
          RaisedButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      )
    );
  }
}