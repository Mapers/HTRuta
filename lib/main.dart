import 'package:HTRuta/core/push_message/push_notification.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SplashScreen/splash_screen.dart';
import 'package:HTRuta/features/DriverTaxiApp/providers/registro_provider.dart';
import 'package:HTRuta/features/DriverTaxiApp/providers/availability_provider.dart';
import 'package:HTRuta/features/DriverTaxiApp/providers/user_provider.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/comments_drive_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:HTRuta/injection_container.dart' as ij;
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/services.dart';
import 'app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await ij.init();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//updated myBackgroundMessageHandler
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  int msgId = int.tryParse(message['msgId'].toString()) ?? 0;
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'report_chanel',
    'Canal Básico',
    'Este es el canal Básico',
    color: primaryColor,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.max,
    ticker: 'ticker'
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics
  );
  flutterLocalNotificationsPlugin.show(msgId,
    message['notification']['title'],
    message['notification']['body'],
    platformChannelSpecifics,
    payload: ''
  );
  return Future<void>.value();
}

class _MyAppState extends State<MyApp> {

  PushNotificationProvider pushProvider;

  @override
  void initState() {
    super.initState();
    pushProvider = PushNotificationProvider();
    pushProvider.initNotifications(myBackgroundMessageHandler);
    pushProvider.mensajes.listen((argumento) async{
      Map notification = argumento['notification'];
      if(notification == null) return;
      String title = notification['title'];
      if(title == null) return;
      if(title.contains('Rechazados')){
        Navigator.pushNamed(context, AppRoute.sendDocumentScreen);
      }
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
        ChangeNotifierProvider(create: (_) => ClientTaxiPlaceBloc()),
        ChangeNotifierProvider(create: (_) => PedidoProvider()),
        ChangeNotifierProvider(create: (_) => OnBoardingProvider(),),
        ChangeNotifierProvider(create: (_) => AvailabilityProvider(),),
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RouteDriveBloc>(create: (_) => ij.getIt<RouteDriveBloc>()),
          BlocProvider<DriverServiceBloc>(create: (_) => ij.getIt<DriverServiceBloc>()),
          BlocProvider<InterprovincialDriverBloc>(create: (_) => ij.getIt<InterprovincialDriverBloc>()),
          BlocProvider<ClientServiceBloc>(create: (_) => ij.getIt<ClientServiceBloc>()),
          BlocProvider<InterprovincialDriverBloc>(create: (_) => ij.getIt<InterprovincialDriverBloc>()),
          BlocProvider<InterprovincialClientBloc>(create: (_) => ij.getIt<InterprovincialClientBloc>()),
          BlocProvider<InterprovincialClientLocationBloc>(create: (_) => ij.getIt<InterprovincialClientLocationBloc>()),
          BlocProvider<AvailablesRoutesBloc>(create: (_) => ij.getIt<AvailablesRoutesBloc>()),
          BlocProvider<CommentsDriveBloc>(create: (_) => ij.getIt<CommentsDriveBloc>()),
        ],
        child: MaterialApp(
          title: 'Taxi App',
          theme: appTheme,
          localizationsDelegates: const [        
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('es', 'ES')
          ],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoute.generateRoute,
          home: SplashScreen(),
        ),
      )
    );
  }
}
