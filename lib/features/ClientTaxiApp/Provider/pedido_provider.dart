import 'package:HTRuta/features/DriverTaxiApp/Model/requestDriver_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:flutter/material.dart';

class PedidoProvider extends ChangeNotifier{
  //Datos de pedido -> punto inicial, punto final, precio y observaciones
  String _idSolicitud;
  Request _request;
  int _contador = 0;
  double _precio;
  RequestDriverData _requestDriver;

  String get idSolicitud => _idSolicitud;

  set idSolicitud(String data){
    _idSolicitud = data;
    notifyListeners();
  }

  Request get request => _request;

  set request(Request data){
    _request = data;
    notifyListeners();
  }

  RequestDriverData get requestDriver => _requestDriver;

  set requestDriver(RequestDriverData data){
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