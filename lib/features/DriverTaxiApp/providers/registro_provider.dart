import 'package:HTRuta/features/DriverTaxiApp/Model/marca_carro_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/modelo_carro_model.dart';
import 'package:flutter/foundation.dart';

class RegistroProvider with ChangeNotifier{

  DataMarca _dataMarca;
  DataModelo _dataModelo;
  String _color = '';
  String _placa = '';
  String _fotoPerfil = '';
  String _fotoAuto = '';
  String _fotoLicenciaFrente = '';
  String _fotoLicenciaTrasera = '';
  String _fotoAtencedente = '';
  String _fotoSoat = '';
  String _licencia = '';
  String _email = '';
  DateTime _birthDay;

  int _index = 0;
  String _titulo = '';

  DataMarca get dataMarca => _dataMarca;

  set dataMarca(DataMarca value){
    _dataMarca = value;
    notifyListeners();
  }

  DataModelo get dataModelo => _dataModelo;

  set dataModelo(DataModelo value){
    _dataModelo = value;
    notifyListeners();
  }

  int get index => _index;

  set index(int value){
    _index = value;
    notifyListeners();
  }

  String get color => _color;

  set color(String value){
    _color = value;
    notifyListeners();
  }

  String get placa => _placa;

  set placa(String value){
    _placa = value;
    notifyListeners();
  }
  String get email => _email;

  set email(String value){
    _email = value;
    notifyListeners();
  }

  String get fotoPerfil => _fotoPerfil;

  set fotoPerfil(String value){
    _fotoPerfil = value;
    notifyListeners();
  }

  String get fotoAuto => _fotoAuto;

  set fotoAuto(String value){
    _fotoAuto = value;
    notifyListeners();
  }

  String get fotoLicenciaFrente => _fotoLicenciaFrente;

  set fotoLicenciaFrente(String value){
    _fotoLicenciaFrente = value;
    notifyListeners();
  }

  String get fotoLicenciaTrasera => _fotoLicenciaTrasera;

  set fotoLicenciaTrasera(String value){
    _fotoLicenciaTrasera = value;
    notifyListeners();
  }
  
  DateTime get birthDay => _birthDay;

  set birthDay(DateTime birthDay){
    _birthDay = birthDay;
    notifyListeners();
  }

  String get fotoAtencedente => _fotoAtencedente;

  set fotoAtencedente(String value){
    _fotoAtencedente = value;
    notifyListeners();
  }

  String get fotoSoat => _fotoSoat;

  set fotoSoat(String value){
    _fotoSoat = value;
    notifyListeners();
  }

  String get titulo => _titulo;

  set titulo(String value){
    _titulo = value;
    notifyListeners();
  }

  String get licencia => _licencia;

  set licencia(String value){
    _licencia = value;
    notifyListeners();
  }
}