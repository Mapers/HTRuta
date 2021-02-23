
import 'dart:async';
import 'dart:io';

import 'package:HTRuta/features/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{
  
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  void initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.subscribeToTopic('general');

    _firebaseMessaging.getToken().then(
      (token) async{
        final _prefs = PreferenciaUsuario();
        await _prefs.initPrefs();
        _prefs.tokenPush = token.toString();
        print('token guardado: ${_prefs.tokenPush}');
      }
    );

  _firebaseMessaging.configure(
    onMessage: (info) async {
      print('============= On Message ==========');
      print('${info['notification']['title']}');
      print(info);

      String argumento = 'no-data';
      if(Platform.isAndroid){
        argumento = info['notification']['title'];
      }
      _mensajesStreamController.sink.add(argumento);
    },
    onLaunch: (info) async {
      print('============= On Launch ==========');
      print(info);
      print('${info['notification']['title']}');
      String argumento = 'no-data';
      if(Platform.isAndroid){
        argumento = info['notification']['title'];
      }
      _mensajesStreamController.sink.add(argumento);
    },
    onResume: (info) async {
      print('============= On Resume ==========');
      print('${info['notification']['title']}');
      String argumento = 'no-data';
      if(Platform.isAndroid){
        argumento = info['notification']['title'];
      }
      _mensajesStreamController.sink.add(argumento);
    }
  );

  }

  void dispose(){
    _mensajesStreamController.close();
  }


}