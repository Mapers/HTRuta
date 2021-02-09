import 'package:HTRuta/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:HTRuta/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/ClientTaxiApp/Screen/SplashScreen/splash_screen.dart';
import 'package:HTRuta/ClientTaxiApp/theme/style.dart';
import 'package:provider/provider.dart';

import 'ClientTaxiApp/Apis/push_notification.dart';
import 'ClientTaxiApp/Blocs/place_bloc.dart';
import 'DriverTaxiApp/providers/registro_provider.dart';
import 'app_router.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PushNotificationProvider pushProvider;

  @override
  void initState() { 
    super.initState();
    pushProvider = new PushNotificationProvider();
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
        ChangeNotifierProvider(create: (_) => OnBoardingProvider(),)
      ],
      child: MaterialApp(
        title: 'Taxi App',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoute.generateRoute,
        home: SplashScreen(),
      )
    );
  }
}
