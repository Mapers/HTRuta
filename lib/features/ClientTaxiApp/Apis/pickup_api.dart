
import 'package:HTRuta/features/ClientTaxiApp/Model/pickup_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/pickupdriver_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/request_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';

import '../../../config.dart';
import 'package:http/http.dart' as http;

class PickupApi{

  Future<RequestData> registerTravel(String idusuario,String vchLatInicial,String vchLatFinal,String vchLongInicial,String vchLongFinal,String mPrecio,String iTipoViaje,String nombreInicio, String nombreFinal)async{
    final url = '${Config.nuevaRutaApi}/registro-viaje-solicitado';
    try{
      final response = await http.post(url,body: {'idusuario' : idusuario, 'vchLatinicial': vchLatInicial, 'vchLatfinal': vchLatFinal, 'vchLonginicial': vchLongInicial,'vchLongfinal': vchLongFinal,'mPrecio': mPrecio,'iTipoViaje': iTipoViaje,'vchNombreInicial':nombreInicio,'vchNombreFinal':nombreFinal} );
      final responseData = requestDataFromJson(response.body);
      if(responseData.success){
        return responseData;
      }else{
        return null;
      }
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<List<Request>> getRequest()async{
    final _prefs = PreferenciaUsuario();
    await _prefs.initPrefs();
    final url = '${Config.nuevaRutaApi}/obtener-viajes-solicitados';
    try{
      final response = await http.post(url,body: {'idchofer': _prefs.idChofer});
      final responseData = pickUpRequestFromJson(response.body);
      if(responseData.success){
        return responseData.data;
      }else{
        return null;
      }
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<List<DriverRequest>> getRequestDriver(String idSolicitud)async{
    final _prefs = PreferenciaUsuario();
    await _prefs.initPrefs();
    final url = '${Config.nuevaRutaApi}/obtener-viajes-choferes';
    try{
      final response = await http.get(url,headers : {'idSolicitud': idSolicitud});
      final responseData = pickUpDriverRequestFromJson(response.body);
      if(responseData.success){
        return responseData.data;
      }else{
        return null;
      }
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> actionTravel(String idChofer,String idsolicitud, double vchLatInicial, double vchLatFinal, double vchLongInicial, double vchLongFinal,String mPropina,double mPrecio,String iTipoViaje,String vchOrigenReferencia, String vchDestinoReferencia,String vchObservacion,String vchNombreInicial, String vchNombreFinal,String iEstado)async{
    //idsolicitud(esta lo obtenies de la ruta donde se lista),vchLatInicial,vchLatFinal,vchLongInicial,vchLongFinal,mPrecio(este puede ser el precio q propone el chofer),mPropina,iTipoViaje,dFecReg,vchOrigenReferencia,vchDestinoReferencia,vchObservacion
    final url = '${Config.nuevaRutaApi}/registro-viaje-chofer';
    try{
      final response = await http.post(url,body: {'idchofer':idChofer,'idsolicitud' : idsolicitud, 'vchLatinicial': vchLatInicial, 'vchLatfinal': vchLatFinal, 'vchLonginicial': vchLongInicial,'vchLongfinal': vchLongFinal,'mPropina': '','mPrecio': mPrecio,'iTipoViaje': iTipoViaje,'vchOrigenReferencia':vchOrigenReferencia,'vchDestinoReferencia':vchDestinoReferencia, 'vchObservacion': vchObservacion, 'vchNombreInicial': vchNombreInicial, 'vchNombreFinal':vchNombreFinal,'iEstado': iEstado});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> cancelTravel(String idSolicitud)async{
    final url = '${Config.nuevaRutaApi}/actualizar-solicitud-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'iEstado': '2'} );
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> acceptTravelFinish(String idSolicitud, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/actualizar-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'idchofer': idChofer} );
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> cancelTravelUser(String idSolicitud, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/rechazar-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'idchofer': idChofer} );
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> updatePriceTravelUser(String idSolicitud, String precio)async{
    final url = '${Config.nuevaRutaApi}/actualizar-precio-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'mPrecio': precio});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> updatePriceTravelDriver(String idSolicitud, String precio, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/actualizar-precio-viaje-chofer';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'mPrecio': precio, 'idchofer': idChofer});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> sendNotification(String idSolicitud)async{
    final url = '${Config.nuevaRutaApi}/enviar-notificacion-viaje-chofer';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    }catch(error){
      print(error.toString());
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

}