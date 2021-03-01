
import 'package:HTRuta/features/feature_client/home/entities/availables_routes_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/client_interprovicial_routes_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/privince_client_entity.dart';
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
  List<ProvincesClientEntity> provinces =[];

  Future<List<ProvincesClientEntity>> getProvincesClient() async{
    provinces = [
      ProvincesClientEntity(id: 1, nameProvince: 'Huaura'),
      ProvincesClientEntity(id: 2, nameProvince: 'Lima'),
      ProvincesClientEntity(id: 2, nameProvince: 'Chancay'),
      ProvincesClientEntity(id: 2, nameProvince: 'Trujillo'),
      ProvincesClientEntity(id: 2, nameProvince: 'Chimbote'),
      ProvincesClientEntity(id: 2, nameProvince: 'Huaraz'),
    ];
    return provinces;
  }

  List<AvailablesRoutesEntity> availablesRoutes =[];
  Future<List<AvailablesRoutesEntity>> getAvailablesRoutes() async{
    availablesRoutes = [
      AvailablesRoutesEntity(id: 1,origin: 'lima',destination: 'huacho',costo: 'S/. 300',state: false, street: 'av. Las flores',nameDriver: 'Richar david perez', time: '02:20 PM' ,date: '28/02/2021'),
      AvailablesRoutesEntity(id: 1,origin: 'lima',destination: 'huacho',costo: 'S/. 300',state: true, street: 'av. Las flores',nameDriver: 'Richar david perez', time: '02:20 PM' ,date: '28/02/2021'),
      AvailablesRoutesEntity(id: 1,origin: 'lima',destination: 'huacho',costo: 'S/. 300',state: false, street: 'av. Las flores',nameDriver: 'Richar david perez', time: '02:20 PM' ,date: '28/02/2021'),
      AvailablesRoutesEntity(id: 1,origin: 'lima',destination: 'huacho',costo: 'S/. 300',state: true, street: 'av. Las flores',nameDriver: 'Richar david perez', time: '02:20 PM' ,date: '28/02/2021'),
      AvailablesRoutesEntity(id: 1,origin: 'lima',destination: 'huacho',costo: 'S/. 300',state: false, street: 'av. Las flores',nameDriver: 'Richar david perez', time: '02:20 PM' ,date: '28/02/2021'),
    ];
    return availablesRoutes;
  }

}