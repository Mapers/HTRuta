import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';

class RouteDriveRepository {
  final RouterDriveRemoteDataSoruce routerDriveLocalDataSoruce;
  RouteDriveRepository(this.routerDriveLocalDataSoruce);

  Future<List<InterprovincialRouteEntity>> getRouterDrives() async{
    List<InterprovincialRouteEntity> interprovincialRoute = await routerDriveLocalDataSoruce.getListRouterDrives();
    return interprovincialRoute;
  }
  Future<void> addRouterDriveRepository({InterprovincialRouteEntity interprovincialRoute }) async{
    await routerDriveLocalDataSoruce.addListRouterDrives( interprovincialRoute: interprovincialRoute );
  }
  Future<void> editRouterDrives({ InterprovincialRouteEntity interprovincialRoute}) async{
    await routerDriveLocalDataSoruce.editListRouterDrives( interprovincialRoute: interprovincialRoute );
  }
  Future<List<InterprovincialRouteEntity>> deleteRouterDrives({InterprovincialRouteEntity interprovincialRoute }) async{
    List<InterprovincialRouteEntity> routerDrive = await routerDriveLocalDataSoruce.deleteRouterDrives( interprovincialRoute: interprovincialRoute );
    return routerDrive;
  }
}