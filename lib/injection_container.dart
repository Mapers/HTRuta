import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/inteprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/home_client/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/bloc/client_interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
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

  sl.registerLazySingleton<RouterDriveRemoteDataSoruce>(
    () => RouterDriveRemoteDataSoruce()
  );

  sl.registerLazySingleton<DriverServiceBloc>(
    () => DriverServiceBloc()
  );

  sl.registerLazySingleton<InterprovincialBloc>(
    () => InterprovincialBloc(
      interprovincialDataRemote: sl()
    )
  );
  sl.registerLazySingleton<ClientServiceBloc>(
    () => ClientServiceBloc()
  );
  sl.registerLazySingleton<ClientInterprovincialBloc>(
    () => ClientInterprovincialBloc()
  );
  sl.registerLazySingleton<InterprovincialDataRemote>(
    () => InterprovincialDataRemote()
  );

  sl.registerLazySingleton<InterprovincialLocationBloc>(
    () => InterprovincialLocationBloc()
  );
}
