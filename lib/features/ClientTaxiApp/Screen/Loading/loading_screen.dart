import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/app_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/GPSPage/access_gps_page.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'dart:async';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/map_coordenation_passenger.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with WidgetsBindingObserver {

  final Session _session =  Session();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    
    if (  state == AppLifecycleState.resumed ) {
      if ( await Geolocator.isLocationServiceEnabled()  ) {
        _sendToPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasError) return Container();
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator(strokeWidth: 2 ) );
            case ConnectionState.none: return Center(child: CircularProgressIndicator(strokeWidth: 2 ) );
            case ConnectionState.active: 
            case ConnectionState.done:{
              final String result = snapshot.data as String; 
              if(result.isEmpty){
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/loading.png'),
                      fit: BoxFit.fitWidth
                    )
                  ),
                );
              }
              return createContent();
            }
          }
          return Container();
        },
      ),
   );
  }
  Widget createContent(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
          child: Text('Habilite el GPS y luego presione en actualizar', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
        ),
        Container(height: 20),
        MaterialButton(
          minWidth: MediaQuery.of(context).size.width * 0.6,
          color: Theme.of(context).primaryColor,
          onPressed: (){
            setState(() {});
          },
          child: Text( 'Actualizar', style: TextStyle(color: Colors.white))
        ),
      ],
    );
  } 

  Future checkGpsYLocation( BuildContext context ) async {
    // PermisoGPS
    final permisoGPS = await Permission.location.isGranted;
    // GPS está activo
    final gpsActivo  = await Geolocator.isLocationServiceEnabled();
    if ( permisoGPS && gpsActivo ) {
      await _sendToPage();
      return '';
    } else if ( !permisoGPS ) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccessGpsPage()));  
      return 'Es necesario el permiso de GPS';
    } else {
      return 'Active el GPS';
    }
  }
  Future<void> _sendToPage() async{
    ServiceDataRemote serviceDataRemote = getIt<ServiceDataRemote>();
    ServiceInCourseEntity serviceInCourse = await serviceDataRemote.getServiceInCourse();
    final data = await _session.get();
    loadService();
    if(serviceInCourse == null){
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
      Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
      return;
    }
    if(serviceInCourse.entityType == TypeEntityEnum.driver){
      BlocProvider.of<DriverServiceBloc>(context).add(ChangeDriverServiceEvent(type: serviceInCourse.serviceType));
      Navigator.of(context).pushAndRemoveUntil(Routes.toHomeDriverPage(serviceInCourse: serviceInCourse), (_) => false);
    }else if(serviceInCourse.entityType == TypeEntityEnum.passenger){
      if(serviceInCourse.passengerDocumentId == null  ){
        BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: serviceInCourse.serviceType));
        Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
      }else{
        InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
        DataNecessaryRetrieve dataNecessaryRetrieve = await interprovincialClientDataFirebase.getDataNecessaryRetrieve( documentId: serviceInCourse.serviceDocumentId,passengerDocumentId: serviceInCourse.passengerDocumentId);
        InterprovincialRouteInServiceEntity interprovincialRouteInServiceEntity = await serviceDataRemote.getInterprovincialRouteInServiceById( dataNecessaryRetrieve.serviceId );
        AvailableRouteEntity availableRouteEntity = AvailableRouteEntity(
          availableSeats:  int.parse(interprovincialRouteInServiceEntity.id),
          route: interprovincialRouteInServiceEntity,
          documentId: serviceInCourse.serviceDocumentId,
          fcm_token: null,
          id: null,
          routeStartDateTime: interprovincialRouteInServiceEntity.dateStart,
          status: toInterprovincialStatusFromString(dataNecessaryRetrieve.status),
          vehicleSeatLayout: null,
          serviceId: dataNecessaryRetrieve.serviceId
        );
        if( serviceInCourse.passengerDocumentId != null ){
          LocationEntity currentlocation =  await LocationUtil.currentLocation();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MapCoordenationDrivePage(
            serviceInCourse.serviceDocumentId,
            availablesRoutesEntity: availableRouteEntity,
            price: dataNecessaryRetrieve.negotiatedPrice,
            passengerDocumentId:serviceInCourse.passengerDocumentId,
            currentLocation: currentlocation,
            seats: dataNecessaryRetrieve.seats,
            passengerPhone: data.cellphone,
          )), (_) => false);
        }else{
          Navigator.of(context).pushAndRemoveUntil(Routes.toTravelNegotationPage( availablesRoutesEntity: availableRouteEntity, ), (_) => false);
        }
      }
    }
  }
  void loadService(){
    final appServicesProvider = Provider.of<AppServicesProvider>(context, listen: false);
    if(appServicesProvider.taxiAvailable){
      BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: TypeServiceEnum.taxi));
      return;
    }
    if(appServicesProvider.interprovincialAvailable){
      BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: TypeServiceEnum.interprovincial));
      return;
    }
    if(appServicesProvider.heavyLoadAvailable){
      BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: TypeServiceEnum.cargo));
      return;
    }
  }
}