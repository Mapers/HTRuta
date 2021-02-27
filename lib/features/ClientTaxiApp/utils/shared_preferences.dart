import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaUsuario{

  static final PreferenciaUsuario _instance =PreferenciaUsuario._internal();

  factory PreferenciaUsuario(){
    return _instance;
  }

  PreferenciaUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async{
    this._prefs = await SharedPreferences.getInstance();
  }

  //Obtener cambiocontraseña
  get primeraSesion{
    return _prefs.getBool('primeraSesion') ?? true;
  }

  set primeraSesion(bool value){
    _prefs.setBool('primeraSesion', value);
  }

  get tokenPush => _prefs.getString('tokenPush') ?? '';

  set tokenPush(String value) {
    _prefs.setString('tokenPush', value);
  }

  get idChofer => _prefs.getString('idChofer') ?? '';

  set idChofer(String value) {
    _prefs.setString('idChofer', value);
  }

}