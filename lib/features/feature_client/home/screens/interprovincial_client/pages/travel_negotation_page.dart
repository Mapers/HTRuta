import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/widgets/calculate_total.dart';
import 'package:HTRuta/app/widgets/poin_meeting_client_await.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/meetin_drive_and_passenger_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/negotiation_entity.dart';
import 'package:HTRuta/features/feature_client/home/presentation/home_client_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/meeting_drive_and_passenger_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/map_coordenation_passenger.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/information_drive_negotation.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/point_meeting.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/view_whereabout.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TravelNegotationPage extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  final Place fromLocation;
  final Place toLocation;
  const TravelNegotationPage(
      {Key key,
      this.availablesRoutesEntity,
      this.fromLocation,
      this.toLocation})
      : super(key: key);

  @override
  _TravelNegotationPageState createState() => _TravelNegotationPageState();
}

class _TravelNegotationPageState extends State<TravelNegotationPage> {
  final formKey = GlobalKey<FormState>();
  bool expectedSteate = true;
  Session _session = Session();
  final _prefs = UserPreferences();
  final pickUpApi = PickupApi();
  // AproxElement element;
  LocationEntity location = LocationEntity.initalPeruPosition();
  LocationEntity whereAbouthOneLocation,
      whereAbouthTwoLocation,
      whereAbouthTheeLocation;
  TextEditingController amountController = TextEditingController();
  ServiceDataRemote serviceDataRemote = getIt<ServiceDataRemote>();
  InterprovincialRequestEntity request;
  Map<PolylineId, Polyline> polylines = {};
  String amount;
  String amountTotal;
  bool newPassagger = false;
  int seating = 0;
  @override
  void initState() {
    whereAbouthOneLocation = LocationEntity(
        streetName: '',
        districtName: '',
        provinceName: '',
        regionName: '',
        latLang: null);
    whereAbouthTwoLocation = LocationEntity(
        streetName: '',
        districtName: '',
        provinceName: '',
        regionName: '',
        latLang: null);
    whereAbouthTheeLocation = LocationEntity(
        streetName: '',
        districtName: '',
        provinceName: '',
        regionName: '',
        latLang: null);
    amountTotal = '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      location = await LocationUtil.currentLocation();
      DataAvailablesRoutes param =
          BlocProvider.of<AvailablesRoutesBloc>(context).state;
      seating = param.requiredSeats;
      amountTotal = (seating * widget.availablesRoutesEntity.route.cost)
          .toStringAsFixed(2);
      BlocProvider.of<MeetingDriveAndPassengerBloc>(context).add(
          GetMeetingDriveAndPassengerEvent(
              amountTotal: seating * widget.availablesRoutesEntity.route.cost));
      getWhereAboutLocation(
          id: 1,
          latlong: widget.availablesRoutesEntity.route.whereAboutstOne.latLang,
          title: 'Punto de encuentro 1',
          isSelect: true);
      getWhereAboutLocation(
          id: 2,
          latlong: widget.availablesRoutesEntity.route.whereAboutstTwo.latLang,
          title: 'Punto de encuentro 2',
          isSelect: false);
      setState(() {});
    });
    amountController.text =
        widget.availablesRoutesEntity.route.cost.toStringAsFixed(2);
    super.initState();
  }

  void getWhereAboutLocation(
      {LatLng latlong, String title, bool isSelect, int id}) async {
    try {
      List<Placemark> whereAbouthOne =
          await placemarkFromCoordinates(latlong.latitude, latlong.longitude);
      Placemark placemark = whereAbouthOne.first;
      LocationEntity location = LocationEntity(
          streetName: placemark.thoroughfare,
          districtName: placemark.locality,
          provinceName: placemark.subAdministrativeArea,
          regionName: placemark.administrativeArea,
          latLang: latlong);
      MeetingDriveAndPassengerEntity mettingpon =
          MeetingDriveAndPassengerEntity(
              id: id, pointMeeting: location, isSelect: isSelect);
      BlocProvider.of<MeetingDriveAndPassengerBloc>(context)
          .add(AddMeetingDriveAndPassengerEvent(meetingPoint: mettingpon));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    InterprovincialClientDataFirebase interprovincialClientDataFirebase =
        getIt<InterprovincialClientDataFirebase>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Negociación del viaje'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                InformationDriveNegotation(
                  availablesRoutesEntity: widget.availablesRoutesEntity,
                ),
                Row(
                  children: [
                    Text(
                      'Número de asientos solicitados: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(seating.toString()),
                  ],
                ),
                StreamBuilder<List<InterprovincialRequestEntity>>(
                    stream:
                        interprovincialClientDataFirebase.getStreamContraoferta(
                            documentId:
                                widget.availablesRoutesEntity.documentId),
                    builder: (ctx, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.active) {
                        List<InterprovincialRequestEntity> ds =
                            asyncSnapshot.data;
                        for (InterprovincialRequestEntity item in ds) {
                          if (item.passengerFcmToken == _prefs.tokenPush) {
                            request = item;
                          }
                        }
                        if (request == null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Puntos de encuentro:'),
                                  IconButton(
                                      icon: Icon(Icons.push_pin),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewWhereabouth(
                                                      whereAbouthOneLocation: widget
                                                          .availablesRoutesEntity
                                                          .route
                                                          .whereAboutstOne,
                                                      whereAbouthTwoLocation: widget
                                                          .availablesRoutesEntity
                                                          .route
                                                          .whereAboutstTwo,
                                                      currentLocation: location,
                                                    )));
                                      })
                                ],
                              ),
                              PointMeeting(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (amountController.text == '0.00') {
                                        return;
                                      }
                                      amountController.text =
                                          (double.parse(amountController.text) -
                                                  1.00)
                                              .toStringAsFixed(2);
                                      BlocProvider.of<
                                                  MeetingDriveAndPassengerBloc>(
                                              context)
                                          .add(
                                              SubtractAmoutTotalMeetingDriveAndPassengerEvent(
                                                  amoutTotal: double.parse(
                                                          amountController
                                                              .text) *
                                                      seating));
                                    },
                                    icon: Icon(Icons.remove),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Card(
                                    color: backgroundInputColor,
                                    child: Container(
                                      width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          onSaved: (val) => amount = val,
                                          controller: amountController,
                                          onChanged: (val) {
                                            BlocProvider.of<
                                                        MeetingDriveAndPassengerBloc>(
                                                    context)
                                                .add(
                                                    SubtractAmoutTotalMeetingDriveAndPassengerEvent(
                                                        amoutTotal:
                                                            double.parse(val) *
                                                                seating));
                                          },
                                          decoration: InputDecoration(
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      amountController.text =
                                          (double.parse(amountController.text) +
                                                  1.00)
                                              .toStringAsFixed(2);
                                      BlocProvider.of<
                                                  MeetingDriveAndPassengerBloc>(
                                              context)
                                          .add(
                                              AddAmoutTotalMeetingDriveAndPassengerEvent(
                                                  amoutTotal: double.parse(
                                                          amountController
                                                              .text) *
                                                      seating));
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                ],
                              ),
                              PrincipalButton(
                                text: 'Negociar',
                                onPressed: () async {
                                  formKey.currentState.save();
                                  //! Agregar modal de consulta
                                  final user = await _session.get();
                                  LocationEntity from =
                                      await LocationUtil.currentLocation();
                                  if (from == null) return;
                                  DataAvailablesRoutes param =
                                      BlocProvider.of<AvailablesRoutesBloc>(
                                              context)
                                          .state;
                                  DataMeetingDriveAndPassengerState
                                      paramPointMetting = BlocProvider.of<
                                                  MeetingDriveAndPassengerBloc>(
                                              context)
                                          .state;
                                  LocationEntity poinMeeting;
                                  for (MeetingDriveAndPassengerEntity item
                                      in paramPointMetting.meetingPoints) {
                                    if (item.isSelect) {
                                      poinMeeting = item.pointMeeting;
                                    }
                                  }
                                  InterprovincialRequestEntity
                                      interprovincialRequest =
                                      InterprovincialRequestEntity(
                                          condition:
                                              InterprovincialRequestCondition
                                                  .offer,
                                          documentId: null,
                                          passengerFcmToken: _prefs.tokenPush,
                                          from: widget.fromLocation.name,
                                          to: widget.toLocation.name,
                                          passengerId: user.id,
                                          fullNames: user.fullNames,
                                          price: double.parse(amount),
                                          seats: param.requiredSeats,
                                          pointMeeting: GeoPoint(
                                              poinMeeting.latLang.latitude,
                                              poinMeeting.latLang.longitude));
                                  String requestDocumentId =
                                      await interprovincialClientDataFirebase
                                          .addRequestClient(
                                              documentId: widget
                                                  .availablesRoutesEntity
                                                  .documentId,
                                              request: interprovincialRequest,
                                              names: user.fullNames);
                                  NegotiationEntity negotiation =
                                      NegotiationEntity(
                                          //UPDATE: CAMBIO POR EL SERVICEID
                                          serviceId: widget
                                              .availablesRoutesEntity.route.id,
                                          passengerId: user.id,
                                          cost: double.parse(amount),
                                          seating: param.requiredSeats,
                                          requestDocumentId: requestDocumentId,
                                          from: from,
                                          to: widget.availablesRoutesEntity
                                              .route.toLocation);
                                  BlocProvider.of<InterprovincialClientBloc>(
                                          context)
                                      .add(
                                          SendDataSolicitudInterprovincialClientEvent(
                                              negotiationEntity: negotiation));
                                  Navigator.of(context).pushAndRemoveUntil(
                                      Routes.toTravelNegotationPage(
                                          availablesRoutesEntity:
                                              widget.availablesRoutesEntity,
                                          fromLocation: widget.fromLocation,
                                          toLocation: widget.toLocation),
                                      (_) => false);
                                },
                              ),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          );
                        } else {
                          return contitional(
                              interprovincialClientDataFirebase:
                                  interprovincialClientDataFirebase,
                              request: request,
                              documentId:
                                  widget.availablesRoutesEntity.documentId);
                        }
                      }
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Cargando...')
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contitional(
      {InterprovincialClientDataFirebase interprovincialClientDataFirebase,
      InterprovincialRequestEntity request,
      String documentId}) {
    switch (request.condition) {
      case InterprovincialRequestCondition.rejected:
        return Center(
          child: Column(
            children: [
              Text(
                'Tu oferta fue rechazada',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrincipalButton(
                      text: 'Ver otras rutas',
                      width: 100,
                      onPressed: () async {
                        await interprovincialClientDataFirebase.deleteRequest(
                            request: request,
                            documentId: documentId,
                            notificationLaunch: false);
                        // DataClientServiceState param = BlocProvider.of<ClientServiceBloc>(context).state;
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeClientPage(rejected: true)),
                            (Route<dynamic> route) => false);
                        BlocProvider.of<InterprovincialClientBloc>(context)
                            .add(SearchcInterprovincialClientEvent());
                      }),
                ],
              ),
            ],
          ),
        );
        break;
      case InterprovincialRequestCondition.offer:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PointMeetingClient(
                geoPoint: request.pointMeeting, currentLocation: location),
            SizedBox(
              height: 10,
            ),
            Text(
              'Precio por pasajero: PEN ' + request.price.toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            CalculateTotal(
              price: request.price,
              seating: request.seats,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '- Esperado respuesta del interprovicial -',
                  style: TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        );
        break;
      case InterprovincialRequestCondition.accepted:
        return Column(
          children: [
            Text('Oferta aceptada'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrincipalButton(
                    text: 'Ver ruta',
                    width: 100,
                    onPressed: () {
                      deleteRequestAndRedirectionalMap(documentId, request);
                    }),
              ],
            ),
          ],
        );
        break;
      case InterprovincialRequestCondition.counterOffer:
        double amountTotal = request.price * request.seats;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PointMeetingClient(geoPoint: request.pointMeeting),
            SizedBox(
              height: 10,
            ),
            Text(
              'Precio por pasajero: PEN ' + request.price.toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Monto total a pagar : PEN ' + amountTotal.toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrincipalButton(
                  text: 'Declinar',
                  width: 100,
                  color: Colors.red,
                  onPressed: () async {
                    final user = await _session.get();
                    await interprovincialClientDataFirebase.deleteRequest(
                        request: request,
                        documentId: documentId,
                        notificationLaunch: true);
                    BlocProvider.of<InterprovincialClientBloc>(context)
                        .add(SearchcInterprovincialClientEvent());
                    NegotiationEntity negotiation = NegotiationEntity(
                        serviceId: widget.availablesRoutesEntity.id,
                        passengerId: user.id,
                        requestDocumentId: null);
                    BlocProvider.of<InterprovincialClientBloc>(context).add(
                        RejecDataSolicitudInterprovincialClientEvent(
                            negotiationEntity: negotiation));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeClientPage(rejected: true)),
                        (Route<dynamic> route) => false);
                  },
                ),
                SizedBox(
                  width: 30,
                ),
                PrincipalButton(
                    text: 'Aceptar',
                    width: 100,
                    onPressed: () async {
                      final user = await _session.get();
                      _prefs.service_id =
                          widget.availablesRoutesEntity.id.toString();
                      NegotiationEntity negotiation = NegotiationEntity(
                          serviceId: widget.availablesRoutesEntity.id,
                          passengerId: user.id,
                          requestDocumentId: null);
                      BlocProvider.of<InterprovincialClientBloc>(context).add(
                          AcceptDataSolicitudInterprovincialClientEvent(
                              negotiationEntity: negotiation,
                              serviceDocumentId: documentId,
                              interprovincialRequest: request));
                    }),
              ],
            )
          ],
        );
        break;
      default:
    }
    return Container();
  }

  void deleteRequestAndRedirectionalMap(
      String documentId, InterprovincialRequestEntity request) async {
    InterprovincialClientDataFirebase interprovincialClientDataFirebase =
        getIt<InterprovincialClientDataFirebase>();
    openLoadingDialog(context);
    final user = await _session.get();
    String passengerDocumentId =
        await interprovincialClientDataFirebase.deleteRequest(
            request: request,
            documentId: documentId,
            notificationLaunch: false);
    LocationEntity currentlocation = await LocationUtil.currentLocation();
    if (currentlocation == null) return;
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => MapCoordenationDrivePage(
                  widget.availablesRoutesEntity.documentId,
                  availablesRoutesEntity: widget.availablesRoutesEntity,
                  price: request.price,
                  passengerDocumentId: passengerDocumentId,
                  currentLocation: currentlocation,
                  passengerPhone: user.cellphone,
                  seats: request.seats,
                )),
        (_) => false);
  }
}
