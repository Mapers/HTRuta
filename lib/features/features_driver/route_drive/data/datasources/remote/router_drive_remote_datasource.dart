import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouterDriveRemoteDataSoruce {
  final RequestHttp requestHttp;
  RouterDriveRemoteDataSoruce({this.requestHttp});
  List<RouteEntity> roterDrives =[];

  Future<List<RouteEntity>> getListRouterDrives() async{
    // List<WhereaboutsEntity> whereabouts= [
    //   WhereaboutsEntity(id: '1',cost: '2500',whereabouts: LocationEntity(latLang: LatLng(-11.1072, 77.6103),districtName: 'huacho', provinceName: 'huaura', regionName: 'lima', streetName: 'av. more',)),
    //   WhereaboutsEntity(id: '1',cost: '2500',whereabouts: LocationEntity(latLang: LatLng(-11.1072, 77.6103),districtName: 'huacho', provinceName: 'huaura', regionName: 'lima', streetName: 'av. more',))
    // ];
    print('object');
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/get-routes',
      data: {
        'user_id': 1041,
      }
    );
    print('..................');
    print(result.data );
    print(result.error );
    print(result.success );
    print('..................');
    // roterDrives = [
    //   RouteEntity(
    //     id: 1,
    //     name: 'Causal',
    //     cost: '240',
    //     from: LocationEntity(
    //       latLang: LatLng(-11.1072, 77.6103),
    //       districtName: 'Huacho',
    //       provinceName: 'Huaura',
    //       regionName: 'Lima',
    //       streetName: 'av. more',
    //       zoom: 12,
    //     ),
    //     to: LocationEntity(
    //       latLang: LatLng(-12.0453, -77.0311),
    //       districtName: 'Independecia',
    //       provinceName: 'Lima ',
    //       regionName: 'Lima',
    //       streetName: 'plaza el norte',
    //       zoom: 12,
    //     ),
    //   )
    //   // RouteEntity(id: '2', name: 'juan', nameFrom:'Lima' ,nameTo: 'Huacho',latLagFrom:LatLng(-12.0453, -77.0311),latLagTo: LatLng(-11.1072, 77.6103)),
    //   // RouteEntity(id: '3', name: 'luis', nameFrom:'Chiclayo' ,nameTo: 'Lima',latLagFrom:LatLng(-6.77361, -79.84),latLagTo: LatLng(-12.0453, -77.0311))
    // ];

    return roterDrives;
  }
  Future<List<RouteEntity>> addListRouterDrives({RouteEntity routeDrive} ) async{
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver//routes/create',
      data: {
        'user_id': 1041,
        'id': null,
        'name':null,
        'from': routeDrive.from.toMap,
        'to': routeDrive.to.toMap,
        'cost':null,
      }
    );
    print('..................');
    print(result);
    print('..................');
    roterDrives.add(routeDrive);
    return roterDrives;
  }
  Future<List<RouteEntity>> editListRouterDrives({RouteEntity roterDrive,RouteEntity newRoterDrive} ) async{
    // int index  = roterDrives.indexOf(roterDrive);
    // roterDrives[index] =  RouteEntity(
    //   name: newRoterDrive.name,
    //   nameFrom: newRoterDrive.nameFrom ,
    //   nameTo: newRoterDrive.nameTo,
    //   whereaboutsFrom: ,
    //   whereaboutsTo: ,
    //   // latLagFrom: newRoterDrive.latLagFrom,
    //   // latLagTo: newRoterDrive.latLagTo,
    // );
    // return roterDrives;
  }
  Future<List<RouteEntity>> deleteRouterDrives({RouteEntity roterDrive} ) async{
    int index  = roterDrives.indexOf(roterDrive);
    roterDrives.removeAt(index);
    return roterDrives;
  }

}
