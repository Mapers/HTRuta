import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouterDriveRemoteDataSoruce {

  List<RoutesEntity> roterDrives =[];

  Future<List<RoutesEntity>> getListRouterDrives() async{
    roterDrives = [
      RoutesEntity(id: '1', name: 'samuel', nameFrom: 'Huacho' ,nameTo: 'Lima',latLagFrom:LatLng(-11.1072, 77.6103),latLagTo: LatLng(-12.0453, -77.0311)),
      RoutesEntity(id: '2', name: 'juan', nameFrom:'Lima' ,nameTo: 'Huacho',latLagFrom:LatLng(-12.0453, -77.0311),latLagTo: LatLng(-11.1072, 77.6103)),
      RoutesEntity(id: '3', name: 'luis', nameFrom:'Chiclayo' ,nameTo: 'Lima',latLagFrom:LatLng(-6.77361, -79.84),latLagTo: LatLng(-12.0453, -77.0311))
    ];

    return roterDrives;
  }
  Future<List<RoutesEntity>> addListRouterDrives({RoutesEntity roterDrive} ) async{
    roterDrives.add(RoutesEntity( id: '3',name: roterDrive.name ,nameFrom: roterDrive.nameFrom ,nameTo: roterDrive.nameTo));
    return roterDrives;
  }
  Future<List<RoutesEntity>> editListRouterDrives({RoutesEntity roterDrive, RoutesEntity newRoterDrive} ) async{
    int index  = roterDrives.indexOf(roterDrive);
    roterDrives[index] =  RoutesEntity(
      name: newRoterDrive.name,
      nameFrom: newRoterDrive.nameFrom ,
      nameTo: newRoterDrive.nameTo,
      latLagFrom: newRoterDrive.latLagFrom,
      latLagTo: newRoterDrive.latLagTo,
    );
    return roterDrives;
  }
  Future<List<RoutesEntity>> deleteRouterDrives({RoutesEntity roterDrive} ) async{
    int index  = roterDrives.indexOf(roterDrive);
    roterDrives.removeAt(index);
    return roterDrives;
  }

  List<WhereaboutsEntity> whereaabouts =[];
  Future<List<WhereaboutsEntity>> getWhereAbouts({RoutesEntity roterDrive} ) async{
    whereaabouts = [
      WhereaboutsEntity(id: '1', cost: 'S/.344',whereabouts: LocationEntity(latLang: LatLng(-12.0453, -77.0311),regionName: 'lima', provinceName: 'Huaura',districtName: 'Huacho',streetName: 'Av. San matin', zoom: 12)),
      WhereaboutsEntity(id: '1', cost: 'S/.344',whereabouts: LocationEntity(latLang: LatLng(-12.0453, -77.0311),regionName: 'lima', provinceName: 'Huaura',districtName: 'Huacho',streetName: 'Av. San matin', zoom: 12)),
      WhereaboutsEntity(id: '1', cost: 'S/.344',whereabouts: LocationEntity(latLang: LatLng(-12.0453, -77.0311),regionName: 'lima', provinceName: 'Huaura',districtName: 'Huacho',streetName: 'Av. San matin', zoom: 12)),
    ];
    return whereaabouts;
  }
  Future<List<WhereaboutsEntity>> editOnOrderWhereAbouts({@required int oldIndex,@required int newIndex, } ) async{
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final WhereaboutsEntity newString = whereaabouts.removeAt(oldIndex);
    whereaabouts.insert(newIndex, newString);
    return whereaabouts;
  }

}
