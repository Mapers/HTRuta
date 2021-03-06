import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:flutter/material.dart';

class RouteDriveRepository {
  final RouterDriveRemoteDataSoruce routerDriveLocalDataSoruce;
  RouteDriveRepository(this.routerDriveLocalDataSoruce);

  Future<List<RouteEntity>> getRouterDrives() async{
    List<RouteEntity> routerDrive = await routerDriveLocalDataSoruce.getListRouterDrives();
    return routerDrive;
  }
  Future<List<RouteEntity>> addRouterDriveRepository({RouteEntity roterDrive }) async{
    List<RouteEntity> routerDrive = await routerDriveLocalDataSoruce.addListRouterDrives(roterDrive: roterDrive );
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
  Future<List<WhereaboutsEntity>> getWhereAbouts() async{
    List<WhereaboutsEntity> whereAbouts = await routerDriveLocalDataSoruce.getWhereAbouts();
    return whereAbouts;
  }
  Future<List<WhereaboutsEntity>> editOnOrderWhereAbouts({@required int oldIndex,@required int newIndex, }) async{
    List<WhereaboutsEntity> whereAbouts = await routerDriveLocalDataSoruce.editOnOrderWhereAbouts(oldIndex: oldIndex, newIndex: newIndex);
    return whereAbouts;
  }
  Future<List<WhereaboutsEntity>> addWhereAboutsRepository({WhereaboutsEntity whereabouts}) async{
    List<WhereaboutsEntity> whereAbouts = await routerDriveLocalDataSoruce.addWhereAbouts(whereabouts: whereabouts);
    return whereAbouts;
  }
}