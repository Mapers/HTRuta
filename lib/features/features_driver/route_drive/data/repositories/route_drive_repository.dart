import 'package:HTRuta/features/features_driver/route_drive/data/datasources/local/router_drive_local_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';

class RouteDriveRepository {
  final RouterDriveLocalDataSoruce routerDriveLocalDataSoruce;
  RouteDriveRepository(this.routerDriveLocalDataSoruce);

  Future<List<RoterDriveEntity>> getRouterDrives() async{
    List<RoterDriveEntity> routerDrive = await routerDriveLocalDataSoruce.getListRouterDrives();
    return routerDrive;
  }
}