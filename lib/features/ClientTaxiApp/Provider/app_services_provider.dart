import 'package:HTRuta/config.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/app_services_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppServicesProvider extends ChangeNotifier{
  bool _taxiAvailable = false;
  bool _interprovincialAvailable = false;
  bool _heavyLoadAvailable = false;

  bool get taxiAvailable => _taxiAvailable;
  bool get interprovincialAvailable => _interprovincialAvailable;
  bool get heavyLoadAvailable => _heavyLoadAvailable;

  set taxiAvailable(bool taxiAvailable){
    _taxiAvailable = taxiAvailable;
    notifyListeners();
  }
  set interprovincialAvailable(bool interprovincialAvailable){
    _interprovincialAvailable = interprovincialAvailable;
    notifyListeners();
  }
  set heavyLoadAvailable(bool heavyLoadAvailable){
    _heavyLoadAvailable = heavyLoadAvailable;
    notifyListeners();
  }
  Future<void> loadAppServices() async{
    final url = '${Config.nuevaRutaApi}/funcionalidad/obtenerFuncionalidad';
    try{
      final response = await http.post(url);
      final responseData = appServicesResponseFromJson(response.body);
      if(responseData.success){
        _taxiAvailable = responseData.data[0].estado == '1';
        _interprovincialAvailable = responseData.data[1].estado == '1';
        _heavyLoadAvailable = responseData.data[2].estado == '1'; 
      }else{
        _taxiAvailable = true;
        _interprovincialAvailable = true;
        _heavyLoadAvailable = true;
      }
    } catch(error){
      print(error);
      _taxiAvailable = true;
      _interprovincialAvailable = true;
      _heavyLoadAvailable = true;
    }
  }
  int countServices(){
    int total = 0;
    if(_taxiAvailable){
      total++;
    }
    if(_interprovincialAvailable){
      total++;
    }
    if(_heavyLoadAvailable){
      total++;
    }
    return total;
  }
}