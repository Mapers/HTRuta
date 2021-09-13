import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/services/services_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ServicesAvailable extends ChangeNotifier{
  Future<List<ServiceAvailable>> cancelTravelUser(String idSolicitud, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/funcionalidad/obtenerFuncionalidad';
    try{
      final response = await http.post(url);
      final responseData = servicesResponseFromJson(response.body);
      if(!responseData.success){
        throw Exception(responseData.message);
      }else{
        return responseData.data;
      }
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
}