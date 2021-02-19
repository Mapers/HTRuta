import 'package:HTRuta/features/features_driver/route_drive/data/datasources/local/router_drive_local_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory(() => RouteDriveBloc(sl()));


  sl.registerLazySingleton<RouteDriveRepository>(
    () => RouteDriveRepository(sl())
  );

  sl.registerLazySingleton<RouterDriveLocalDataSoruce>(
    () => RouterDriveLocalDataSoruce()
  );
}
