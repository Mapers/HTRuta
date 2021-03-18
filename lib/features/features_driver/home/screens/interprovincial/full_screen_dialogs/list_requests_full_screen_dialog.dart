import 'package:HTRuta/app/widgets/loading_fullscreen.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_firestore.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            interprovincialRequest.condition == InterprovincialRequestCondition.offer ? IconButton(
              tooltip: 'Rechazar solicitud',
              icon: Icon(Icons.cancel, color: Colors.red,),
              onPressed: () => showRejectRequestDialog(index, interprovincialRequest),
            ) : Container()
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
        getActionButtons(index, interprovincialRequest)
      ],
    );
  }

  Widget getActionButtons(int index, InterprovincialRequestEntity interprovincialRequest){
    if(interprovincialRequest.condition == InterprovincialRequestCondition.offer){
      ButtonBar(
        children:  [
          RaisedButton(
            onPressed: () => showPrepareContraofferDialog(index, interprovincialRequest),
            child: Text('Contraofertar'),
          ),
          RaisedButton(
            onPressed: () => showAcceptOfferDialog(index, interprovincialRequest),
            child: Text('Aceptar'),
          )
        ]
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Text('- En espera de aceptación de contraoferta -', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54))
    );
  }

  void showRejectRequestDialog(int index, InterprovincialRequestEntity interprovincialRequest){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Estas seguro de rechazar esta oferta?'),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          RaisedButton(
            child: Text('Sí, rechazar'),
            onPressed: () async{
              Navigator.of(ctx).pop();
              _loadingFullScreen.show(context, label: 'Rechazando solicitud...');
              bool status = await interprovincialDataFirestore.rejectRequest(documentId: widget.documentId, request: interprovincialRequest);
              _loadingFullScreen.close();
              if(status){
                setState(() => interprovincialRequests.removeAt(index));
                if(interprovincialRequests.isEmpty){
                  await Future.delayed(Duration(milliseconds: 100));
                  Navigator.of(context).pop();
                }
              }
            },
          )
        ],
      )
    );
  }

  void showPrepareContraofferDialog(int index, InterprovincialRequestEntity interprovincialRequest){
    TextEditingController textController = TextEditingController();
    textController.text = interprovincialRequest.price.toStringAsFixed(2);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enviar confraoferta'),
        content: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: (){
                    double newPrice = double.tryParse(textController.text);
                    newPrice ??= interprovincialRequest.price;
                    newPrice--;
                    textController.text = newPrice.toStringAsFixed(2);
                  },
                ),
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    double newPrice = double.tryParse(textController.text);
                    newPrice ??= interprovincialRequest.price;
                    newPrice++;
                    textController.text = newPrice.toStringAsFixed(2);
                  },
                ),
              ],
            ),
            Text('Si el pasajero acepta la contraoferta, este automaticamente se convertirá en pasajero.')
          ],
        ),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          RaisedButton(
            child: Text('Enviar contraoferta'),
            onPressed: () async{
              double newPrice = double.tryParse(textController.text);
              newPrice ??= interprovincialRequest.price;
              if(interprovincialRequest.price == newPrice){
                Fluttertoast.showToast(msg: 'La contrapropuesta es la misma que el precio ofertado por el pasajero.', toastLength: Toast.LENGTH_LONG);
                return ;
              }
              Navigator.of(ctx).pop();
              _loadingFullScreen.show(context, label: 'Enviando contraoferta...');
              bool status = await interprovincialDataFirestore.sendCounterOfferInRequest(documentId: widget.documentId, request: interprovincialRequest, newPrice: newPrice);
              _loadingFullScreen.close();
              if(status){
                setState((){
                  interprovincialRequests.removeAt(index);
                  interprovincialRequests.insert(index, interprovincialRequest.copyWith(
                    price: newPrice,
                    condition: InterprovincialRequestCondition.counterOffer
                  ));
                });
              }
            },
          )
        ],
      )
    );
  }

  void showAcceptOfferDialog(int index, InterprovincialRequestEntity interprovincialRequest){
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
              if(newAvailableSeats == null) return;
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