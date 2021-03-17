import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/inteprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/whereabouts_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //! Blocs
  getIt.registerLazySingleton<RouteDriveRepository>(
    () => RouteDriveRepository(getIt())
  );

  getIt.registerLazySingleton<RouterDriveRemoteDataSoruce>(
    () => RouterDriveRemoteDataSoruce()
  );
  getIt.registerLazySingleton<InterprovincialClientRemoteDataSoruce>(
    () => InterprovincialClientRemoteDataSoruce()
  );
  getIt.registerLazySingleton<InterprovincialClientLocationBloc>(
    () => InterprovincialClientLocationBloc()
  );

  getIt.registerLazySingleton<DriverServiceBloc>(
    () => DriverServiceBloc()
  );

  getIt.registerLazySingleton<InterprovincialDriverBloc>(
    () => InterprovincialDriverBloc(
      interprovincialDataRemote: getIt(),
      interprovincialDataFirestore: getIt()
    )
  );

  getIt.registerLazySingleton<InterprovincialDriverLocationBloc>(
    () => InterprovincialDriverLocationBloc(interprovincialDataRemote: getIt(), interprovincialDataFirestore: getIt())
  );

  getIt.registerLazySingleton<ClientServiceBloc>(
    () => ClientServiceBloc()
  );
  getIt.registerLazySingleton<InterprovincialClientBloc>(
    () => InterprovincialClientBloc()
  );

  getIt.registerLazySingleton<InterprovincialDataRemote>(
    () => InterprovincialDataRemote()
  );
  getIt.registerLazySingleton<InterprovincialDataFirestore>(
    () => InterprovincialDataFirestore(
      firestore: getIt()
    )
  );

  getIt.registerLazySingleton<AvailablesRoutesBloc>(
    () => AvailablesRoutesBloc(getIt())
  );
  await Firebase.initializeApp();
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance
  );
  // feature_client
  getIt.registerFactory<RouteDriveBloc>(
    () => RouteDriveBloc(getIt())
  );
  getIt.registerFactory<WhereaboutsBloc>(
    () => WhereaboutsBloc(getIt())
  );
}
