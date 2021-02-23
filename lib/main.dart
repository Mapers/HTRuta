import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/push_notification.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SplashScreen/splash_screen.dart';
import 'package:HTRuta/features/DriverTaxiApp/providers/registro_provider.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:HTRuta/injection_container.dart' as ij;

import 'app_router.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await ij.init();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PushNotificationProvider pushProvider;

  @override
  void initState() {
    super.initState();
    pushProvider = PushNotificationProvider();
    pushProvider.initNotifications();
    pushProvider.mensajes.listen((argumento) async{
      if(argumento.contains('Rechazados')){
        Navigator.pushNamed(context, AppRoute.sendDocumentScreen);
      }
      //Navigator.pushNamed(context, AppRoute.homeDriverScreen);
    });
  }

  @override
  void dispose() {
    pushProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistroProvider()),
        ChangeNotifierProvider(create: (_) => PlaceBloc()),
        ChangeNotifierProvider(create: (_) => PedidoProvider()),
        ChangeNotifierProvider(create: (_) => OnBoardingProvider(),),

      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RouteDriveBloc>(create: (_) => ij.sl<RouteDriveBloc>()),
          BlocProvider<DriverServiceBloc>(create: (_) => ij.sl<DriverServiceBloc>()),
          BlocProvider<InterprovincialBloc>(create: (_) => ij.sl<InterprovincialBloc>()),
        ],
        child: MaterialApp(
          title: 'Taxi App',
          theme: appTheme,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoute.generateRoute,
          home: SplashScreen(),
        ),
      )
    );
  }
}
