import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';

class RouteDriveRepository {
  final RouterDriveRemoteDataSoruce routerDriveLocalDataSoruce;
  RouteDriveRepository(this.routerDriveLocalDataSoruce);

  Future<List<RoterDriveEntity>> getRouterDrives() async{
    List<RoterDriveEntity> routerDrive = await routerDriveLocalDataSoruce.getListRouterDrives();
    return routerDrive;
  }
  Future<List<RoterDriveEntity>> addRouterDrives({RoterDriveEntity roterDrive }) async{
    List<RoterDriveEntity> routerDrive = await routerDriveLocalDataSoruce.addListRouterDrives(roterDrive: roterDrive );
    return routerDrive;
  }
  Future<List<RoterDriveEntity>> editRouterDrives({ RoterDriveEntity roterDrive, RoterDriveEntity newRoterDrive }) async{
    List<RoterDriveEntity> routerDrive = await routerDriveLocalDataSoruce.editListRouterDrives( roterDrive: roterDrive,newRoterDrive: newRoterDrive );
    return routerDrive;
  }
  Future<List<RoterDriveEntity>> deleteRouterDrives({RoterDriveEntity roterDrive }) async{
    List<RoterDriveEntity> routerDrive = await routerDriveLocalDataSoruce.deleteRouterDrives( roterDrive: roterDrive );
    return routerDrive;
  }
}