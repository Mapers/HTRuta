import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/data/remote/interprovincial_remote_firestore.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/local/interprovincial_client_data_local.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/comments_drive_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/inteprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_remote.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/datasources/remote/router_drive_remote_datasource.dart';
import 'package:HTRuta/features/features_driver/route_drive/data/repositories/route_drive_repository.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  //? Client
  getIt.registerLazySingleton<RouteDriveRepository>(
    () => RouteDriveRepository(getIt())
  );

  getIt.registerLazySingleton<RouterDriveRemoteDataSoruce>(
    () => RouterDriveRemoteDataSoruce(
      requestHttp: getIt(),
    )
  );

  getIt.registerLazySingleton<DriverServiceBloc>(
    () => DriverServiceBloc()
  );

  getIt.registerLazySingleton<CommentsDriveBloc>(
    () => CommentsDriveBloc((getIt()),)
  );


  getIt.registerLazySingleton<InterprovincialDriverBloc>(
    () => InterprovincialDriverBloc(
      interprovincialDataFirestore: getIt(),
      interprovincialDriverDataRemote: getIt(),
      serviceDataRemote: getIt()
    )
  );

  getIt.registerLazySingleton<InterprovincialDataFirestore>(
    () => InterprovincialDataFirestore(firestore: getIt(), pushMessage: getIt(), serviceDataRemote: getIt())
  );
  getIt.registerLazySingleton<InterprovincialDriverDataRemote>(
    () => InterprovincialDriverDataRemote(requestHttp: getIt())
  );
  getIt.registerLazySingleton<InterprovincialDataDriverFirestore>(
    () => InterprovincialDataDriverFirestore(
      firestore: getIt(),
      pushMessage: getIt()
    )
  );
    getIt.registerFactory<RouteDriveBloc>(
    () => RouteDriveBloc(getIt())
  );

  //? Client
  getIt.registerLazySingleton<InterprovincialDriverLocationBloc>(
    () => InterprovincialDriverLocationBloc(interprovincialDataFirestore: getIt())
  );
  getIt.registerLazySingleton<InterprovincialClientRemoteDataSoruce>(
    () => InterprovincialClientRemoteDataSoruce(
      firestore: getIt(),
      requestHttp: getIt()
    )
  );
  getIt.registerLazySingleton<InterprovincialClientDataFirebase>(
    () => InterprovincialClientDataFirebase(
      pushMessage: getIt(),
      firestore: getIt(),
    )
  );
  getIt.registerLazySingleton<InterprovincialClientLocationBloc>(
    () => InterprovincialClientLocationBloc()
  );

  getIt.registerLazySingleton<ClientServiceBloc>(
    () => ClientServiceBloc()
  );
  getIt.registerLazySingleton<InterprovincialClientBloc>(
    () => InterprovincialClientBloc()
  );

  getIt.registerLazySingleton<AvailablesRoutesBloc>(
    () => AvailablesRoutesBloc(getIt())
  );
  getIt.registerLazySingleton<InterprovincialClientDataLocal>(
    () => InterprovincialClientDataLocal(
      sharedPreferences: getIt()
    )
  );
  //? General
  getIt.registerLazySingleton<ServiceDataRemote>(
    () => ServiceDataRemote(
      requestHttp: getIt()
    )
  );
  getIt.registerLazySingleton<RequestHttp>(
    () => RequestHttp(
      client: getIt()
    )
  );

  //? Core Dependences
  await Firebase.initializeApp();
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance
  );
  getIt.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  //? Core Libs
  getIt.registerLazySingleton(() => PushMessage(client: getIt()));


}
