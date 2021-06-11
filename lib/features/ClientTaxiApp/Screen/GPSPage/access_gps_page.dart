import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Loading/loading_screen.dart';

import 'package:HTRuta/app/navigation/routes.dart';

class AccessGpsPage extends StatefulWidget {

  @override
  _AccesGpsPageState createState() => _AccesGpsPageState();
}

class _AccesGpsPageState extends State<AccessGpsPage> with WidgetsBindingObserver {

  @override
  void initState() {
    
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    
    if (  state == AppLifecycleState.resumed ) {
      if ( await Permission.location.isGranted  ) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Es necesario el GPS para usar esta app'),

            MaterialButton(
              child: Text('Solicitar Acceso', style: TextStyle( color: Colors.white )),
              color: Theme.of(context).primaryColor,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () async {
                
                final status = await Permission.location.request();

                accesoGPS( status );

              }
            )
          ],
        )
     ),
   );
  }

  void accesoGPS( PermissionStatus status ) {


    switch ( status ) {
      
      case PermissionStatus.granted:
        Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
        break;
      
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
      case PermissionStatus.undetermined:
        openAppSettings();
    
    }
    
  }
}