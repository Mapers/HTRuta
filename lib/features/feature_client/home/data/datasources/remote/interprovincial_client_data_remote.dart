
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/feature_client/home/entities/availables_routes_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/client_interprovicial_routes_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
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
  List<ProvinceDistrictClientEntity> provinces =[];

  Future<List<ProvinceDistrictClientEntity>> getProvincesClient() async{
    provinces = [
      ProvinceDistrictClientEntity(districtId: 1, provinceName: 'Huaura', districtName: 'Huacho'),
      ProvinceDistrictClientEntity(districtId: 2, provinceName: 'Lima', districtName: 'Huachipa'),
      ProvinceDistrictClientEntity(districtId: 3, provinceName: 'Chancay', districtName: 'Chancay'),
      ProvinceDistrictClientEntity(districtId: 4, provinceName: 'Trujillo', districtName: 'Trujillo'),
      ProvinceDistrictClientEntity(districtId: 5, provinceName: 'Santa', districtName: 'Chimbote'),
      ProvinceDistrictClientEntity(districtId: 6, provinceName: 'Huaraz', districtName: 'Caraz'),
    ];
    return provinces;
  }

  List<AvailablesRoutesEntity> availablesRoutes =[];
  Future<List<AvailablesRoutesEntity>> getAvailablesRoutes() async{
    availablesRoutes = [
      AvailablesRoutesEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteEntity.test()),
      AvailablesRoutesEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteEntity.test()),
      AvailablesRoutesEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteEntity.test()),
      AvailablesRoutesEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteEntity.test()),
      AvailablesRoutesEntity(id: 1, availableSeats: 50, documentId: 'asd', status: InterprovincialStatus.inRoute, routeStartDateTime: DateTime.now(), route: InterprovincialRouteEntity.test()),
    ];
    return availablesRoutes;
  }

}