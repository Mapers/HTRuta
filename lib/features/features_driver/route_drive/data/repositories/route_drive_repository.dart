import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';

class RouteDriveRepository {
  final RouterDriveRemoteDataSoruce routerDriveLocalDataSoruce;
  RouteDriveRepository(this.routerDriveLocalDataSoruce);

  Future<List<RouteEntity>> getRouterDrives() async{
    List<RouteEntity> routerDrive = await routerDriveLocalDataSoruce.getListRouterDrives();
    return routerDrive;
  }
  Future<List<RouteEntity>> addRouterDriveRepository({RouteEntity roterDrive }) async{
    List<RouteEntity> routerDrive = await routerDriveLocalDataSoruce.addListRouterDrives( routeDrive: roterDrive );
    return routerDrive;
  }
  Future<List<RouteEntity>> editRouterDrives({ RouteEntity roterDrive, RouteEntity newRoterDrive }) async{
    List<RouteEntity> routerDrive = await routerDriveLocalDataSoruce.editListRouterDrives( roterDrive: roterDrive,newRoterDrive: newRoterDrive );
    return routerDrive;
  }
  Future<List<RouteEntity>> deleteRouterDrives({RouteEntity roterDrive }) async{
    List<RouteEntity> routerDrive = await routerDriveLocalDataSoruce.deleteRouterDrives( roterDrive: roterDrive );
    return routerDrive;
  }
}