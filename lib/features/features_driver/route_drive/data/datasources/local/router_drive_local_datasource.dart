import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:meta/meta.dart';

class RouterDriveLocalDataSoruce {


  Future<List<RoterDriveEntity>> getListRouterDrives() async{
    return [
      RoterDriveEntity( name: "samuel",lastName:"luis mendoza", origin: "Huacho",destination:"Lima" ),
      RoterDriveEntity( name: "juan",lastName:"perez sanchez", origin: "Lima",destination:"Huacho" ),
      RoterDriveEntity( name: "luis",lastName:"soliz mogoyon", origin: "Chiclayo",destination:"Lima" ),
    ];
  }

}
