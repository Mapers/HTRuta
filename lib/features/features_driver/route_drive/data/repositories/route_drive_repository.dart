import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:flutter/material.dart';

class RouteDriveRepository {
  final RouterDriveRemoteDataSoruce routerDriveLocalDataSoruce;
  RouteDriveRepository(this.routerDriveLocalDataSoruce);

  Future<List<RoutesEntity>> getRouterDrives() async{
    List<RoutesEntity> routerDrive = await routerDriveLocalDataSoruce.getListRouterDrives();
    return routerDrive;
  }
  Future<List<RoutesEntity>> addRouterDrives({RoutesEntity roterDrive }) async{
    List<RoutesEntity> routerDrive = await routerDriveLocalDataSoruce.addListRouterDrives(roterDrive: roterDrive );
    return routerDrive;
  }
  Future<List<RoutesEntity>> editRouterDrives({ RoutesEntity roterDrive, RoutesEntity newRoterDrive }) async{
    List<RoutesEntity> routerDrive = await routerDriveLocalDataSoruce.editListRouterDrives( roterDrive: roterDrive,newRoterDrive: newRoterDrive );
    return routerDrive;
  }
  Future<List<RoutesEntity>> deleteRouterDrives({RoutesEntity roterDrive }) async{
    List<RoutesEntity> routerDrive = await routerDriveLocalDataSoruce.deleteRouterDrives( roterDrive: roterDrive );
    return routerDrive;
  }
  Future<List<WhereaaboutsEntity>> getWhereAbouts() async{
    List<WhereaaboutsEntity> whereAbouts = await routerDriveLocalDataSoruce.getWhereAbouts();
    return whereAbouts;
  }
  Future<List<WhereaaboutsEntity>> editOnOrderWhereAbouts({@required int oldIndex,@required int newIndex, }) async{
    List<WhereaaboutsEntity> whereAbouts = await routerDriveLocalDataSoruce.editOnOrderWhereAbouts(oldIndex: oldIndex, newIndex: newIndex);
    return whereAbouts;
  }
}