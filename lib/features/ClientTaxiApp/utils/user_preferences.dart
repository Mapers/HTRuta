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

  String get tokenPush => _prefs.getString('tokenPush') ?? '';

  set tokenPush(String value) {
    _prefs.setString('tokenPush', value);
  }

  String get idChofer => _prefs.getString('idChofer') ?? '';

  set idChofer(String value) {
    _prefs.setString('idChofer', value);
  }

}