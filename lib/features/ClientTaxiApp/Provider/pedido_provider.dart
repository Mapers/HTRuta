import 'package:HTRuta/features/ClientTaxiApp/Model/pickupdriver_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:flutter/material.dart';

class PedidoProvider extends ChangeNotifier{
  //Datos de pedido -> punto inicial, punto final, precio y observaciones
  String _idSolicitud;
  RequestModel _request;
  int _contador = 0;
  double _precio;
  DriverRequest _requestDriver;
  String _idViaje;

  String get idSolicitud => _idSolicitud;

  set idSolicitud(String data){
    _idSolicitud = data;
    notifyListeners();
  }

  RequestModel get request => _request;

  set request(RequestModel data){
    _request = data;
    notifyListeners();
  }

  String get idViaje => _idViaje;

  set idViaje(String idViaje){
    _idViaje = idViaje;
  }

  DriverRequest get requestDriver => _requestDriver;

  set requestDriver(DriverRequest data){
    _requestDriver = data;
    notifyListeners();
  }

  int get contador => _contador;

  set contador(int data){
    _contador = data;
    notifyListeners();
  }

  double get precio => _precio;

  set precio(double data){
    _precio = data;
    notifyListeners();
  }

  void incrementarPrecio(){
    _precio += 0.5;
    _contador += 1;
    notifyListeners();
  }

  void reducirPrecio(){
    _precio -= 0.5;
    _contador -= 1;
    notifyListeners();
  }

}