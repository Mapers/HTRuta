import 'package:flutter/material.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Model/request_model.dart';
import 'package:flutter_map_booking/DriverTaxiApp/Model/requestDriver_model.dart';
import 'package:flutter_map_booking/DriverTaxiApp/Model/request_model.dart';

class PedidoProvider extends ChangeNotifier{
  //TODO implementar datos de pedido -> punto inicial, punto final, precio y observaciones
  String _idSolicitud;
  Request _request;
  int _contador = 0;
  double _precio;
  RequestDriverData _requestDriver;

  String get idSolicitud => this._idSolicitud;

  set idSolicitud(String data){
    this._idSolicitud = data;
    notifyListeners();
  }

  Request get request => this._request;

  set request(Request data){
    this._request = data;
    notifyListeners();
  }

  RequestDriverData get requestDriver => this._requestDriver;

  set requestDriver(RequestDriverData data){
    this._requestDriver = data;
    notifyListeners();
  }

  int get contador => this._contador;

  set contador(int data){
    this._contador = data;
    notifyListeners();
  }

  double get precio => this._precio;

  set precio(double data){
    this._precio = data;
    notifyListeners();
  }

  void incrementarPrecio(){
    this._precio += 0.5;
    this._contador += 1;
    notifyListeners();
  }

  void reducirPrecio(){
    this._precio -= 0.5;
    this._contador -= 1;
    notifyListeners();
  }

}