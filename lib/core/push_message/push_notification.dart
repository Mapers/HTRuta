
import 'dart:async';

import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

typedef BackgroundMessageHandler = Future<dynamic> Function(Map<String, dynamic> message);

class PushNotificationProvider{
  PushNotificationProvider._privateConstructor();
  static final PushNotificationProvider _instance = PushNotificationProvider._privateConstructor();
  factory PushNotificationProvider() => _instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _mensajesStreamController = StreamController<Map>.broadcast();
  Stream<Map> get mensajes => _mensajesStreamController.stream;

  void initNotifications(BackgroundMessageHandler backgroundMessageHandler){
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.subscribeToTopic('general');

    _firebaseMessaging.getToken().then(
      (token) async{
        final _prefs = UserPreferences();
        await _prefs.initPrefs();
        _prefs.tokenPush = token.toString();
        print('token guardado: ${_prefs.tokenPush}');
      }
    );

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelect);

    _firebaseMessaging.configure(
      onMessage: (info) async {
        print('============= On Message ==========');
        print(info);

        _displayNotification(info, backgroundMessageHandler);
        _mensajesStreamController.sink.add(info);
      },
      onLaunch: (info) async {
        print('============= On Launch ==========');
        print(info);
        _displayNotification(info, backgroundMessageHandler);
        _mensajesStreamController.sink.add(info);
      },
      onResume: (info) async {
        print('============= On Resume ==========');
        print('${info['notification']['title']}');
        _displayNotification(info, backgroundMessageHandler);
        _mensajesStreamController.sink.add(info);
      }
    );
  }

  void _displayNotification(dynamic info, BackgroundMessageHandler backgroundMessageHandler){
    // dynamic data = info['data'];
    backgroundMessageHandler(info);
    /* if(data['display_notification'] == 'true'){
    } */
  }

  void dispose(){
    _mensajesStreamController.close();
  }

  Future<String> onSelect(String data) async {
    return '';
  }

}