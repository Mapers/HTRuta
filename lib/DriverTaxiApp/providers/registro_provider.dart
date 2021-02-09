import 'package:flutter/foundation.dart';
import 'package:HTRuta/DriverTaxiApp/Model/marca_carro_model.dart';
import 'package:HTRuta/DriverTaxiApp/Model/modelo_carro_model.dart';

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

   int _index = 0;
   String _titulo = '';

   DataMarca get dataMarca => this._dataMarca;

   set dataMarca(DataMarca value){
     this._dataMarca = value;
     notifyListeners();
   }

   DataModelo get dataModelo => this._dataModelo;

   set dataModelo(DataModelo value){
     this._dataModelo = value;
     notifyListeners();
   }

   int get index => this._index;

   set index(int value){
     this._index = value;
     notifyListeners();
   }

   String get color => this._color;

   set color(String value){
     this._color = value;
     notifyListeners();
   }

   String get placa => this._placa;

   set placa(String value){
     this._placa = value;
     notifyListeners();
   }

   String get fotoPerfil => this._fotoPerfil;

   set fotoPerfil(String value){
     this._fotoPerfil = value;
     notifyListeners();
   }

   String get fotoAuto => this._fotoAuto;

   set fotoAuto(String value){
     this._fotoAuto = value;
     notifyListeners();
   }

   String get fotoLicenciaFrente => this._fotoLicenciaFrente;

   set fotoLicenciaFrente(String value){
     this._fotoLicenciaFrente = value;
     notifyListeners();
   }

   String get fotoLicenciaTrasera => this._fotoLicenciaTrasera;

   set fotoLicenciaTrasera(String value){
     this._fotoLicenciaTrasera = value;
     notifyListeners();
   }

   String get fotoAtencedente => this._fotoAtencedente;

   set fotoAtencedente(String value){
     this._fotoAtencedente = value;
     notifyListeners();
   }

   String get fotoSoat => this._fotoSoat;

   set fotoSoat(String value){
     this._fotoSoat = value;
     notifyListeners();
   }

   String get titulo => this._titulo;

   set titulo(String value){
     this._titulo = value;
     notifyListeners();
   }

   String get licencia => this._licencia;

   set licencia(String value){
     this._licencia = value;
     notifyListeners();
   }


}