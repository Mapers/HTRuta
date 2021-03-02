import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouterDriveRemoteDataSoruce {

  List<RoterDriveEntity> roterDrives =[];

  Future<List<RoterDriveEntity>> getListRouterDrives() async{
    roterDrives = [
      RoterDriveEntity(id: '1', name: 'samuel', nameFrom: 'Huacho' ,nameTo: 'Lima',latLagFrom:LatLng(-11.1072, 77.6103),latLagTo: LatLng(-12.0453, -77.0311)),
      RoterDriveEntity(id: '2', name: 'juan', nameFrom:'Lima' ,nameTo: 'Huacho',latLagFrom:LatLng(-12.0453, -77.0311),latLagTo: LatLng(-11.1072, 77.6103)),
      RoterDriveEntity(id: '3', name: 'luis', nameFrom:'Chiclayo' ,nameTo: 'Lima',latLagFrom:LatLng(-6.77361, -79.84),latLagTo: LatLng(-12.0453, -77.0311))
    ];

    return roterDrives;
  }
  Future<List<RoterDriveEntity>> addListRouterDrives({RoterDriveEntity roterDrive} ) async{
    roterDrives.add(RoterDriveEntity( id: '3',name: roterDrive.name ,nameFrom: roterDrive.nameFrom ,nameTo: roterDrive.nameTo));
    return roterDrives;
  }
  Future<List<RoterDriveEntity>> editListRouterDrives({RoterDriveEntity roterDrive, RoterDriveEntity newRoterDrive} ) async{
    int index  = roterDrives.indexOf(roterDrive);
    roterDrives[index] =  RoterDriveEntity(
      name: newRoterDrive.name,
      nameFrom: newRoterDrive.nameFrom ,
      nameTo: newRoterDrive.nameTo,
      latLagFrom: newRoterDrive.latLagFrom,
      latLagTo: newRoterDrive.latLagTo,
    );
    return roterDrives;
  }
  Future<List<RoterDriveEntity>> deleteRouterDrives({RoterDriveEntity roterDrive} ) async{
    int index  = roterDrives.indexOf(roterDrive);
    roterDrives.removeAt(index);
    return roterDrives;
  }

  List<WhereaaboutsEntity> whereaabouts =[];
  Future<List<WhereaaboutsEntity>> getWhereAbouts({RoterDriveEntity roterDrive} ) async{
    whereaabouts = [
      WhereaaboutsEntity(id: '1', province: 'huaura',adress: 'Av.pierola', cost: 'S/.344',latLagFrom:LatLng(-11.1072, 77.6103),latLagTo: LatLng(-12.0453, -77.0311)),
      WhereaaboutsEntity(id: '2', province: 'chancay',adress: 'san luis',cost:'S/.344' ,latLagFrom:LatLng(-12.0453, -77.0311),latLagTo: LatLng(-11.1072, 77.6103)),
      WhereaaboutsEntity(id: '3', province: 'supe',adress: 'av.peru', cost:'S/.344' ,latLagFrom:LatLng(-6.77361, -79.84),latLagTo: LatLng(-12.0453, -77.0311))
    ];
    return whereaabouts;
  }

}
