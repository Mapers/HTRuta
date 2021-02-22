import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/fromToEntity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';

class RouteDriveRepository {
  final RouterDriveRemoteDataSoruce routerDriveLocalDataSoruce;
  RouteDriveRepository(this.routerDriveLocalDataSoruce);

  Future<List<RoterDriveEntity>> getRouterDrives() async{
    List<RoterDriveEntity> routerDrive = await routerDriveLocalDataSoruce.getListRouterDrives();
    return routerDrive;
  }
  Future<List<RoterDriveEntity>> addRouterDrives({String name, FromToEntity dataFromTo }) async{
    List<RoterDriveEntity> routerDrive = await routerDriveLocalDataSoruce.addListRouterDrives(name: name , dataFromTo: dataFromTo );
    print(routerDrive.length);
    return routerDrive;
  }
}