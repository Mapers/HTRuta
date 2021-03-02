import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/inteprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/choose_routes_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/client_interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/whereabouts_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  


  sl.registerLazySingleton<RouteDriveRepository>(
    () => RouteDriveRepository(sl())
  );

  sl.registerLazySingleton<RouterDriveRemoteDataSoruce>(
    () => RouterDriveRemoteDataSoruce()
  );
  sl.registerLazySingleton<InterprovincialClientRemoteDataSoruce>(
    () => InterprovincialClientRemoteDataSoruce()
  );

  sl.registerLazySingleton<DriverServiceBloc>(
    () => DriverServiceBloc()
  );

  sl.registerLazySingleton<ChooseRoutesClientBloc>(
    () => ChooseRoutesClientBloc(sl())
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
    () => InterprovincialDataRemote(
      firestore: sl()
    )
  );

  sl.registerLazySingleton<InterprovincialLocationBloc>(
    () => InterprovincialLocationBloc()
  );
  sl.registerLazySingleton<AvailablesRoutesBloc>(
    () => AvailablesRoutesBloc(sl())
  );
  await Firebase.initializeApp();
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance
  );
  // feature_client
  sl.registerFactory<RouteDriveBloc>(
    () => RouteDriveBloc(sl())
  );
  sl.registerFactory<WhereaboutsBloc>(
    () => WhereaboutsBloc(sl())
  );
}
