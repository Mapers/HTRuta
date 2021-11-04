import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{

  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences(){
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  void initPrefs() async{
    _prefs = await SharedPreferences.getInstance();
  }

  //Obtener cambiocontraseña
  bool get primeraSesion{
    return _prefs.getBool('primeraSesion') ?? true;
  }

  set primeraSesion(bool value){
    _prefs.setBool('primeraSesion', value);
  }

  String get service_id{
    return _prefs.getString('service_id') ?? '';
  }

  set service_id(String value){
    _prefs.setString('service_id', value);
  }

  String get tokenPush => _prefs.getString('tokenPush') ?? '';

  set tokenPush(String value) {
    _prefs.setString('tokenPush', value);
  }

  String get idChofer => _prefs.getString('idChofer') ?? '';

  set idChofer(String value) {
    _prefs.setString('idChofer', value);
  }

  String get idUsuario => _prefs.getString('idUsuario') ?? '';

  set idUsuario(String value) {
    _prefs.setString('idUsuario', value);
  }

  String get idChoferReal => _prefs.getString('idChoferReal') ?? '';

  set idChoferReal(String value) {
    _prefs.setString('idChoferReal', value);
  }

  
  String get firestoreId => _prefs.getString('firestoreId') ?? '';

  set firestoreId(String value) {
    _prefs.setString('firestoreId', value);
  }

  bool get drivingState => _prefs.getBool('drivingState') ?? false;

  set setDrivingState(bool value) {
    _prefs.setBool('drivingState', value);
  }

  String get taxiRequestInCourse => _prefs.getString('taxiRequestInCourse') ?? '';

  set taxiRequestInCourse(String taxiRequestInCourse) {
    _prefs.setString('taxiRequestInCourse', taxiRequestInCourse);
  }

  bool get isDriverInService => _prefs.getBool('isDriverInService') ?? false;

  set isDriverInService(bool value) {
    _prefs.setBool('isDriverInService', value);
  }

  bool get isClientInTaxi => _prefs.getBool('isClientInTaxi') ?? false;

  set isClientInTaxi(bool value) {
    _prefs.setBool('isClientInTaxi', value);
  }

  String get clientTaxiRequest => _prefs.getString('clientTaxiRequest') ?? '';

  set clientTaxiRequest(String clientTaxiRequest) {
    _prefs.setString('clientTaxiRequest', clientTaxiRequest);
  }

  String get clientTaxiDriverRequest => _prefs.getString('clientTaxiDriverRequest') ?? '';

  set clientTaxiDriverRequest(String clientTaxiDriverRequest) {
    _prefs.setString('clientTaxiDriverRequest', clientTaxiDriverRequest);
  }

  List<String> get getClientPaymentMethods => _prefs.getStringList('clientPayments') ?? ['1'];
  
  set setClientPaymentMethods(List<String> values) {
    _prefs.setStringList('clientPayments', values);
  }

  List<String> get notificacionesConductor => _prefs.getStringList('notificacionesConductor') ?? [];

  set setNotificacionConductor(String nuevaNotificacion) {
    List<String> notificacionesPasadas = _prefs.getStringList('notificacionesConductor') ?? [];
    notificacionesPasadas.add(nuevaNotificacion);
    if(notificacionesPasadas.length > 10){
      notificacionesPasadas.removeAt(0);
    }
    _prefs.setStringList('notificacionesConductor', notificacionesPasadas);
  }
  void clearNotificacionConductor() {
    _prefs.setStringList('notificacionesConductor', null);
  }
  void clearNotificacionConductorIndex(int index) {
    List<String> notificacionesPasadas = _prefs.getStringList('notificacionesConductor') ?? [];
    notificacionesPasadas.removeAt(index);
    _prefs.setStringList('notificacionesConductor', notificacionesPasadas);
  }

  List<String> get notificacionesUsuario => _prefs.getStringList('notificacionesUsuario') ?? [];

  set setNotificacionUsuario(String nuevaNotificacion) {
    List<String> notificacionesPasadas = _prefs.getStringList('notificacionesUsuario') ?? [];
    notificacionesPasadas.add(nuevaNotificacion);
    if(notificacionesPasadas.length > 10){
      notificacionesPasadas.removeAt(0);
    }
    _prefs.setStringList('notificacionesUsuario', notificacionesPasadas);
  }
  void clearNotificacionUsuario() {
    _prefs.setStringList('notificacionesUsuario', null);
  }
  void clearNotificacionUsuarioIndex(int index) {
    List<String> notificacionesPasadas = _prefs.getStringList('notificacionesUsuario') ?? [];
    notificacionesPasadas.removeAt(index);
    _prefs.setStringList('notificacionesUsuario', notificacionesPasadas);
  }


  bool get newTravelInit => _prefs.getBool('newTravelInit') ?? false;

  set newTravelInit(bool value) {
    _prefs.setBool('newTravelInit', value);
  }

  bool get newTravelFinish => _prefs.getBool('newTravelFinish') ?? false;

  set newTravelFinish(bool value) {
    _prefs.setBool('newTravelFinish', value);
  }

}