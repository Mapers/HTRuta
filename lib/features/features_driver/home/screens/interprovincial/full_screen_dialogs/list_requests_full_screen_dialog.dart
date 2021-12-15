import 'package:HTRuta/app/widgets/calculate_total.dart';
import 'package:HTRuta/app/widgets/loading_fullscreen.dart';
import 'package:HTRuta/app/widgets/poin_meeting_client_await.dart';
import 'package:HTRuta/data/remote/interprovincial_remote_firestore.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/point_meeting_drive_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/point_meeting_drive_negotation.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/entities/location_entity.dart';

class ListRequestsFullScreenDialog extends StatefulWidget {
  final String documentId;
  final String serviceId;
  ListRequestsFullScreenDialog({Key key, @required this.documentId, @required this.serviceId}) : super(key: key);

  @override
  _ListRequestsFullScreenDialogState createState() => _ListRequestsFullScreenDialogState();
}

class _ListRequestsFullScreenDialogState extends State<ListRequestsFullScreenDialog> {

  ServiceDataRemote serviceDataRemote = getIt<ServiceDataRemote>();
  InterprovincialDriverDataRemote interprovincialDriverDataRemote = getIt<InterprovincialDriverDataRemote>();
  InterprovincialDataDriverFirestore interprovincialDataDriverFirestore = getIt<InterprovincialDataDriverFirestore>();
  InterprovincialDataFirestore interprovincialDataFirestore = getIt<InterprovincialDataFirestore>();
  LoadingFullScreen _loadingFullScreen = LoadingFullScreen();
  LocationEntity location = LocationEntity.initalPeruPosition();

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  Future<void> getPosition() async {
    location = await LocationUtil.currentLocation();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
      ),
      body: StreamBuilder<List<InterprovincialRequestEntity>>(
        stream: interprovincialDataDriverFirestore.getStreamEnabledRequests(documentId: widget.documentId),
        builder: (ctx, asyncSnapshot){
          if(asyncSnapshot.connectionState == ConnectionState.active){
            List<InterprovincialRequestEntity> interprovincialRequests = asyncSnapshot.data;
            if(interprovincialRequests.isEmpty){
              return Center(
                child: Text('- Sin solicitudes -', style: TextStyle(fontStyle: FontStyle.italic)),
              );
            }
            return ListView.separated(
              separatorBuilder: (ctx, i) => Divider(),
              itemCount: interprovincialRequests.length,
              padding: EdgeInsets.all(15),
              itemBuilder: (ctx, i) => getItem(i, interprovincialRequests[i], interprovincialRequests.length)
            );
          }
          return Container();
        }
      )
    );
  }

  Widget getItem(int index, InterprovincialRequestEntity interprovincialRequest, int requestsNumber){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.person, color: Colors.black87),
            SizedBox(width: 5),
            Expanded(
              child: Text(interprovincialRequest.fullNames),
            ),
            SizedBox(width: 15),
            Text('PEN ' +interprovincialRequest.price.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
            SizedBox(width: 15),
            interprovincialRequest.condition == InterprovincialRequestCondition.offer ? 
            TextButton(
              onPressed: () => showRejectRequestDialog(index, interprovincialRequest),
              child: Text('Cancelar', style: TextStyle(color: Colors.red, fontSize: 16))
            ): Container()
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Puntos de encuentro', style: TextStyle(fontWeight: FontWeight.bold ),),
        ),
        PointMeetingClient(
          geoPoint: interprovincialRequest.pointMeeting,
          icon: Icons.location_on,
          withMap: true,
          currentLocation: location,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CalculateTotal(price: interprovincialRequest.price  ,seating: interprovincialRequest.seats ,),
        ),
        getActionButtons(index, interprovincialRequest, requestsNumber)
      ],
    );
  }

  Widget getActionButtons(int index, InterprovincialRequestEntity interprovincialRequest, int requestsNumber){
    if(interprovincialRequest.condition == InterprovincialRequestCondition.offer){
      return ButtonBar(
        children:  [
          RaisedButton(
            onPressed: () => showPrepareContraofferDialog(index, interprovincialRequest),
            child: Text('Contraofertar'),
          ),
          RaisedButton(
            onPressed: () => showAcceptOfferDialog(index, interprovincialRequest, requestsNumber),
            child: Text('Aceptar'),
          )
        ]
      );
    }else if(interprovincialRequest.condition == InterprovincialRequestCondition.counterOffer){
      return Container(
        margin: EdgeInsets.only(top: 15),
        child: Text('- En espera de aceptación de contraoferta -', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54))
      );
    }
    return Container();
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
              final _prefs = UserPreferences();
              await Future.wait([
                interprovincialDataFirestore.rejectRequest(documentId: widget.documentId, request: interprovincialRequest, driverFcmToken: _prefs.tokenPush, origin: InterprovincialDataFirestoreOrigin.driver),
                serviceDataRemote.rejectRequest(widget.serviceId, interprovincialRequest.passengerId)
              ]);
              _loadingFullScreen.close();
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
        content: ListView(
          shrinkWrap: true,
          children: [
            PointMeetingDriveNegotation(interprovincialRequest: interprovincialRequest,),
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
                SizedBox(width: 20),
                Expanded(child: TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                )),
                SizedBox(width: 20),
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
            SizedBox(height: 20),
            Text('Si el pasajero acepta la contraoferta, este automaticamente se convertirá en pasajero.', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic), textAlign: TextAlign.center,)
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
              DataPointMeetingDriveSatete param = BlocProvider.of<PointMeetingDriveBloc>(context).state;
              GeoPoint newPointMeetingp = GeoPoint( param.pointMeeting.latLang.latitude, param.pointMeeting.latLang.longitude);
              await Future.wait([
                interprovincialDataDriverFirestore.sendCounterOfferInRequest(documentId: widget.documentId, request: interprovincialRequest, newPrice: newPrice,newPointMeetingp: newPointMeetingp ),
                interprovincialDriverDataRemote.sendCounterOffertInRequest(cost: newPrice, passengerId: interprovincialRequest.passengerId, serviceId: widget.serviceId)
              ]);
              _loadingFullScreen.close();
              setState(() {});
            },
          )
        ],
      )
    );
  }

  void showAcceptOfferDialog(int index, InterprovincialRequestEntity interprovincialRequest, int requestsNumber){
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
              final onAcceptedRequest = await interprovincialDataFirestore.acceptRequest(documentId: widget.documentId, request: interprovincialRequest, origin: InterprovincialDataFirestoreOrigin.driver);
              if(onAcceptedRequest != null){
                await serviceDataRemote.acceptRequest(widget.serviceId, interprovincialRequest.passengerId, onAcceptedRequest.passenger.documentId);
                _loadingFullScreen.close();
                if(onAcceptedRequest.availableSeats == null) return;
                BlocProvider.of<InterprovincialDriverBloc>(context).add(SetLocalAvailabelSeatInterprovincialDriverEvent(newSeats: onAcceptedRequest.availableSeats));
              }else{
                _loadingFullScreen.close();
              }
              // if(requestsNumber == 1){
                Navigator.pop(context);
              // }
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