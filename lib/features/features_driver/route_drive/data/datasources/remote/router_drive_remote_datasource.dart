import 'package:HTRuta/features/features_driver/route_drive/domain/entities/fromToEntity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:meta/meta.dart';

class RouterDriveRemoteDataSoruce {

  List<RoterDriveEntity> roterDrive =[];

  Future<List<RoterDriveEntity>> getListRouterDrives() async{
    roterDrive.add(RoterDriveEntity(name: "samuel",origin: "Huacho" ,destination: "Lima"));
    roterDrive.add(RoterDriveEntity(name: "juan",origin: "Lima" ,destination: "Huacho"));
    roterDrive.add(RoterDriveEntity(name: "luis",origin: "Chiclayo" ,destination: "Lima"));

    return roterDrive;
  }
  Future<List<RoterDriveEntity>> addListRouterDrives({String name,FromToEntity dataFromTo} ) async{
    roterDrive.add(RoterDriveEntity(name: name,origin: dataFromTo.provinceFrom ,destination: dataFromTo.provinceTo));
    return roterDrive;
    
  }

}
