import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/negotiation_entity.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/feature_client/home/presentation/home_client_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/interprovincial_client_screen.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/map_coordenation_passenger.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';


class TravelNegotationPage extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  const TravelNegotationPage({Key key, this.availablesRoutesEntity}) : super(key: key);

  @override
  _TravelNegotationPageState createState() => _TravelNegotationPageState();
}
class _TravelNegotationPageState extends State<TravelNegotationPage> {
  final formKey = GlobalKey<FormState>();
  bool expectedSteate = true;
  Session _session = Session();
  final _prefs = UserPreferences();
  TextEditingController amountController = TextEditingController();
  ServiceDataRemote serviceDataRemote = getIt<ServiceDataRemote>();
  InterprovincialRequestEntity request;
  String amount;
  bool newPassagger = false;
  @override
  void initState() {
    amountController.text = widget.availablesRoutesEntity.route.cost.toStringAsFixed(2);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Negociacion del viaje'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
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
              SizedBox(height: 15,),
              StreamBuilder<List<InterprovincialRequestEntity>>(
                stream: interprovincialClientDataFirebase.getStreamContraoferta(documentId: widget.availablesRoutesEntity.documentId),
                builder: (ctx, asyncSnapshot){
                  if(asyncSnapshot.connectionState == ConnectionState.active){
                    print( asyncSnapshot.data );
                    List<InterprovincialRequestEntity>  ds = asyncSnapshot.data;
                    for (InterprovincialRequestEntity item in ds) {
                      if(item.passengerFcmToken ==  _prefs.tokenPush){
                        request = item;
                      }
                    }
                    if(request == null){
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: (){
                                  amountController.text = (double.parse(amountController.text) - 1.00 ).toStringAsFixed(2);
                                },
                                icon: Icon(Icons.remove),
                              ),
                              SizedBox(width: 20,),
                              Card(
                                color: backgroundInputColor,
                                child: Container(
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: TextFormField(
                                      onSaved: (val)=> amount = val,
                                      controller: amountController,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20,),
                              IconButton(
                                onPressed: (){
                                  amountController.text = (double.parse(amountController.text)  + 1.00 ).toStringAsFixed(2);
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          PrincipalButton(
                            text: 'Negociar',
                            onPressed: ()async{
                              formKey.currentState.save();
                              //! Agregar modal de consulta
                              final user = await _session.get();
                              LocationEntity from = await LocationUtil.currentLocation();
                              DataAvailablesRoutes param = BlocProvider.of<AvailablesRoutesBloc>(context).state;
                              InterprovincialRequestEntity interprovincialRequest = InterprovincialRequestEntity(
                                condition: InterprovincialRequestCondition.offer,
                                documentId: null,
                                passengerFcmToken: _prefs.tokenPush,
                                from: from.streetName + ' ' + from.districtName + ' ' + from.provinceName,
                                to: param.distictTo.districtName,
                                passengerId: user.id,
                                fullNames: user.fullNames,
                                price: double.parse(amount),
                                seats: param.requiredSeats
                              );
                              String requestDocumentId =  await interprovincialClientDataFirebase.addRequestClient(documentId: widget.availablesRoutesEntity.documentId ,request: interprovincialRequest);
                              NegotiationEntity negotiation = NegotiationEntity(
                                serviceId: widget.availablesRoutesEntity.id,
                                passengerId: user.id,
                                cost: double.parse(amount),
                                seating: param.requiredSeats,
                                requestDocumentId: requestDocumentId,
                                from: from,
                                to: widget.availablesRoutesEntity.route.toLocation
                              );
                              BlocProvider.of<InterprovincialClientBloc>(context).add(SendDataSolicitudInterprovincialClientEvent(negotiationEntity: negotiation));
                              Navigator.of(context).pushAndRemoveUntil(Routes.toTravelNegotationPage(availablesRoutesEntity: widget.availablesRoutesEntity), (_) => false);
                            },
                          )
                        ],
                      );
                    }else{
                      return contitional(interprovincialClientDataFirebase: interprovincialClientDataFirebase, request: request, documentId: widget.availablesRoutesEntity.documentId);
                    }
                  }
                  return Container();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget contitional({InterprovincialClientDataFirebase interprovincialClientDataFirebase, InterprovincialRequestEntity request, String documentId} ){
    switch (request.condition) {
      case InterprovincialRequestCondition.rejected:
        return Center(
          child: Column(
            children: [
              Text( 'Tu oferta fue rechazada',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  PrincipalButton(
                    text: 'Ver otras rutas',
                    width: 100,
                    onPressed: () async {
                      await interprovincialClientDataFirebase.deleteRequest(request: request, documentId: documentId, notificationLaunch: false);
                      // DataClientServiceState param = BlocProvider.of<ClientServiceBloc>(context).state;
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeClientPage(rejected: true)), (Route<dynamic> route) => false);
                      BlocProvider.of<InterprovincialClientBloc>(context).add(SearchcInterprovincialClientEvent());
                    }
                  ),
                ],
              ),
            ],
          ),
        );
      break;
      case InterprovincialRequestCondition.offer:
          return Center(
            child: Column(
              children: [
                Text('S/. '+ request.price.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text('Esperado respuesta del interprovicial', style: TextStyle( fontWeight: FontWeight.bold,color:Colors.grey ),),
              ],
            ),
          );
        break;
      case InterprovincialRequestCondition.accepted:
          return Column(
            children: [
              Text('Oferta aceptada'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  PrincipalButton(
                    text: 'Ver ruta',
                    width: 100,
                    onPressed: () {
                      deleteRequestAndRedirectionalMap(documentId, request);
                    }
                  ),
                ],
              ),
            ],
          );
        break;
      case InterprovincialRequestCondition.counterOffer:
          return Column(
            children: [
              Text('S/. '+ request.price.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  PrincipalButton(
                    text: 'Declinar',
                    width: 100,
                    color:Colors.red,
                    onPressed: ()async{
                      final user = await _session.get();
                      await interprovincialClientDataFirebase.deleteRequest(request: request, documentId: documentId, notificationLaunch: true);
                      BlocProvider.of<InterprovincialClientBloc>(context).add(SearchcInterprovincialClientEvent());
                      NegotiationEntity negotiation = NegotiationEntity(
                        serviceId: widget.availablesRoutesEntity.id,
                        passengerId: user.id,
                        requestDocumentId: null
                      );
                      BlocProvider.of<InterprovincialClientBloc>(context).add(RejecDataSolicitudInterprovincialClientEvent(negotiationEntity:  negotiation));
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeClientPage(rejected: true)), (Route<dynamic> route) => false);
                    },
                  ),
                  SizedBox(width: 30,),
                  PrincipalButton(
                    text: 'Aceptar',
                    width: 100,
                    onPressed: () async{
                      final user = await _session.get();
                      _prefs.service_id = widget.availablesRoutesEntity.id.toString();
                      NegotiationEntity negotiation = NegotiationEntity(
                        serviceId: widget.availablesRoutesEntity.id,
                        passengerId: user.id,
                        requestDocumentId: null
                      );
                      BlocProvider.of<InterprovincialClientBloc>(context).add(AcceptDataSolicitudInterprovincialClientEvent(negotiationEntity: negotiation, serviceDocumentId: documentId,interprovincialRequest: request ));
                    }
                  ),
                ],
              )
            ],
          );
        break;
      default:
    }
    return Container();
  }

  void deleteRequestAndRedirectionalMap(String documentId, InterprovincialRequestEntity request ) async {
    InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
    openLoadingDialog(context);
    final user = await _session.get();
    String passengerDocumentId =  await interprovincialClientDataFirebase.deleteRequest(request: request, documentId: documentId, notificationLaunch: false);
    LocationEntity currentlocation =  await LocationUtil.currentLocation();
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> MapCoordenationDrivePage(
      widget.availablesRoutesEntity.documentId,
      availablesRoutesEntity: widget.availablesRoutesEntity,
      price: request.price,
      passengerDocumentId: passengerDocumentId,
      currentLocation: currentlocation,
      passengerPhone: user.cellphone,
    )), (_) => false);
  }
}