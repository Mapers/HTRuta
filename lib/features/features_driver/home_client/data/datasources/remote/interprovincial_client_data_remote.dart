
import 'package:HTRuta/features/features_driver/home_client/entities/Client_interprovicial_routes_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InterprovincialClientRemoteDataSoruce {

  List<ClientInterporvincialRoutesEntity> routes =[];

  Future<List<ClientInterporvincialRoutesEntity>> getListRouterClient() async{
    routes = [
      ClientInterporvincialRoutesEntity(id: 1, nameDriver: 'samuel', from: 'Huacho' ,to: 'Lima',latLngfrom:LatLng(-11.1072, 77.6103),latLngto: LatLng(-12.0453, -77.0311)),
      ClientInterporvincialRoutesEntity(id: 2, nameDriver: 'juan', from:'Lima' ,to: 'Huacho',latLngfrom:LatLng(-12.0453, -77.0311),latLngto: LatLng(-11.1072, 77.6103)),
      ClientInterporvincialRoutesEntity(id: 3, nameDriver: 'luis', from:'Chiclayo' ,to: 'Lima',latLngfrom:LatLng(-6.77361, -79.84),latLngto: LatLng(-12.0453, -77.0311))
    ];
    return routes;
  }

}