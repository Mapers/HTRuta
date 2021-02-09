
import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/shared_preferences.dart';

class PushNotificationProvider{
  
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotifications(){
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
    onMessage: (info) {
      print('============= On Message ==========');
      print('${info['notification']['title']}');
      print(info);

      String argumento = 'no-data';
      if(Platform.isAndroid){
        argumento = info['notification']['title'];
      }
      _mensajesStreamController.sink.add(argumento);
    },
    onLaunch: (info) {
      print('============= On Launch ==========');
      print(info);
      print('${info['notification']['title']}');
      String argumento = 'no-data';
      if(Platform.isAndroid){
        argumento = info['notification']['title'];
      }
      _mensajesStreamController.sink.add(argumento);
    },
    onResume: (info){
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

  dispose(){
    _mensajesStreamController.close();
  }


}