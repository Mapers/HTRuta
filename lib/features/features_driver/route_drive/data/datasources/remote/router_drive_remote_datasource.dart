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
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/get-routes',
      data: {
        'user_id': 1041,
      }
    );
    List<RouteEntity> routeDrives = RouteEntity.fromListJson(result.data['data']);
    return routeDrives;
  }

  Future<List<RouteEntity>> addListRouterDrives({RouteEntity routeDrive} ) async{
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver//routes/create',
      data: {
        'user_id': 1041,
        'id': null ,
        'name':routeDrive.name,
        'from': routeDrive.from.toMap,
        'to': routeDrive.to.toMap,
        'cost': routeDrive.cost,
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
