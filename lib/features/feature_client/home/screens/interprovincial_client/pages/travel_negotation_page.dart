import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/data/remote/interprovincial_remote_firestore.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/negotiation_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/map_coordenation_drive.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TravelNegotationPage extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  const TravelNegotationPage({Key key, this.availablesRoutesEntity}) : super(key: key);

  @override
  _TravelNegotationPageState createState() => _TravelNegotationPageState();
}

class _TravelNegotationPageState extends State<TravelNegotationPage> {
  final formKey = GlobalKey<FormState>();
  bool expectedSteate = true;
  TextEditingController amountController = TextEditingController();
  String amount;
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
        child: Column(
          children: [
            SizedBox(height: 15,),
            Text(widget.availablesRoutesEntity.route.name,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 15,),
            Text( widget.availablesRoutesEntity.route.nameDriver ),
            SizedBox(height: 15,),
            StreamBuilder<List<InterprovincialRequestEntity>>(
              stream: interprovincialClientDataFirebase.getStreamContraoferta(documentId: widget.availablesRoutesEntity.documentId),
              builder: (ctx, asyncSnapshot){
                if(asyncSnapshot.connectionState == ConnectionState.active){
                  if(asyncSnapshot.data.isEmpty){
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (){
                                amountController.text = (double.parse(amountController.text)  - 1.00 ).toStringAsFixed(2);
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
                            final _prefs = UserPreferences();
                            Session _session = Session();
                            final user = await _session.get();
                            LocationEntity from = await LocationUtil.currentLocation();
                            DataAvailablesRoutes param = BlocProvider.of<AvailablesRoutesBloc>(context).state;
                            InterprovincialRequestEntity interprovincialRequest = InterprovincialRequestEntity(
                              condition: InterprovincialRequestCondition.offer,
                              documentId: null,
                              passengerFcmToken: _prefs.tokenPush,
                              from: from.streetName + ' ' + from.districtName + ' ' + from.provinceName,
                              to: param.distictTo,
                              passengerId: int.parse(user.id) ,
                              fullNames: user.fullNames,
                              price: double.parse(amount),
                              seats: param.requiredSeats
                            );
                            NegotiationEntity negotiation = NegotiationEntity(
                              service_id: widget.availablesRoutesEntity.id,
                              passenger_id: int.parse(user.id),
                              cost: double.parse(amount),
                              seating: param.requiredSeats,
                            );
                            await interprovincialClientDataFirebase.addRequestClient(documentId: widget.availablesRoutesEntity.documentId ,request: interprovincialRequest,fcmTokenDriver: widget.availablesRoutesEntity.fcm_token );
                            BlocProvider.of<InterprovincialClientBloc>(context).add(SendDataSolicitudInterprovincialClientEvent(negotiationEntity: negotiation));
                            Navigator.of(context).pushAndRemoveUntil(Routes.toTravelNegotationPage(availablesRoutesEntity: widget.availablesRoutesEntity), (_) => false);
                          },
                        )
                      ],
                    );
                  }else{
                    return contitional(interprovincialClientDataFirebase: interprovincialClientDataFirebase, request: asyncSnapshot.data.first, documentId: widget.availablesRoutesEntity.documentId,fcmTokenDriver: widget.availablesRoutesEntity.fcm_token);
                  }
                }
                return Container();
              }
            ),
          ],
        ),
      ),
    );
  }
  Widget contitional({InterprovincialClientDataFirebase interprovincialClientDataFirebase, InterprovincialRequestEntity request, String documentId, String fcmTokenDriver} ){
    InterprovincialDataFirestore interprovincialDataFirestore = getIt<InterprovincialDataFirestore>();
    switch (request.condition) {
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
                      acceptService(documentId, request);
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
              Text('S/. '+ request.price.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  PrincipalButton(
                    text: 'Declinar',
                    width: 100,
                    color:Colors.red,
                    onPressed: ()async{
                      Navigator.of(context).pop();
                      await interprovincialClientDataFirebase.messageRequestdFirebase(request: request , documentId: documentId, fcmTokenDriver: fcmTokenDriver);
                    },
                  ),
                  SizedBox(width: 30,),
                  PrincipalButton(
                    text: 'Aceptar',
                    width: 100,
                    onPressed: () async{
                      await interprovincialDataFirestore.acceptRequest(documentId: documentId, request: request, origin: InterprovincialDataFirestoreOrigin.client);
                      acceptService(documentId, request);
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

  void acceptService(String documentId, InterprovincialRequestEntity request) async {
    LocationEntity currenActual = await LocationUtil.currentLocation();
    InterprovincialDataFirestore interprovincialDataFirestore = getIt<InterprovincialDataFirestore>();
    interprovincialDataFirestore.seeRoute(documentId: widget.availablesRoutesEntity.documentId, request: request);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> MapCoordenationDrivePage(widget.availablesRoutesEntity.documentId, currenActual: currenActual, availablesRoutesEntity: widget.availablesRoutesEntity, interprovincialRequest: request,)), (_) => false);
  }
}