
import 'dart:typed_data';
import 'dart:convert';
import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/historical_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/payment_methods_response.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/pickup_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/pickupdriver_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/register_travel_body.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/save_profile_body.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/request_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/save_qualification_body.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/travel_accepted_response.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/response/solicitud_usuario_response.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/driver_payment_method_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/request_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/save_driver_py_body.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/my_wallet_response.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/historical_detail_response.dart';
import 'package:HTRuta/models/minutes_response.dart';

import 'package:http/http.dart' as http;

class PickupApi{

  Future<RequestData> registerTravel(String idusuario,String vchLatInicial,String vchLatFinal,String vchLongInicial,String vchLongFinal,String mPrecio,String iTipoViaje,String nombreInicio, String nombreFinal, String comentarios, String token, String unidad, int distancia, List<int> metodosPago)async{
    final url = '${Config.nuevaRutaApi}/registro-viaje-solicitado';
    try{
      final response = await http.post(url,body: {'IdTokenCliente': token, 'idusuario' : idusuario, 'vchLatinicial': vchLatInicial, 'vchLatfinal': vchLatFinal, 'vchLonginicial': vchLongInicial,'vchLongfinal': vchLongFinal,'mPrecio': mPrecio,'iTipoViaje': iTipoViaje,'vchNombreInicial':nombreInicio,'vchNombreFinal':nombreFinal, 'Comentario': comentarios, 'unidad': unidad, 'distancia': distancia.toString(), 'arrFormaPagoIds': metodosPago} );//TODO: unidad: M, distancia: 1
      final responseData = requestDataFromJson(response.body);
      if(responseData.success){
        return responseData;
      }else{
        return null;
      }
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
  Future<RequestData> registerTravelClient(RegisterTravelBody body)async{
    final url = '${Config.nuevaRutaApi}/registro-viaje-solicitado';
    try{
      final response = await http.post(
        url,
        body:  registerTravelBodyToJson(body),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'}
      );
      final responseData = requestDataFromJson(response.body);
      if(responseData.success){
        return responseData;      }else{
        return null;
      }
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<List<RequestModel>> getRequest(String idChofer, String latitud, String longitud)async{
    final _prefs = UserPreferences();
    await _prefs.initPrefs();
    final url = '${Config.nuevaRutaApi}/obtener-viajes-solicitados';
    try{
      final response = await http.post(
        url,
        body: {
          'choferId': idChofer,
          'idLatitud': latitud,
          'idLongitud': longitud
        });
      final responseData = pickUpRequestFromJson(response.body);
      if(responseData.success){
        return responseData.data;
      }else{
        return null;
      }
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<List<DriverRequest>> getRequestDriver(String idSolicitud)async{
    final _prefs = UserPreferences();
    await _prefs.initPrefs();
    final url = '${Config.nuevaRutaApi}/obtener-viajes-choferes';
    try{
      final response = await http.post(url,body : {'idSolicitud': idSolicitud});
      final responseData = pickUpDriverRequestFromJson(response.body);
      if(responseData.success){
        return responseData.data;
      }else{
        return null;
      }
    } catch(error){
      return null;
    }
  }

  Future<bool> actionTravel(String idChofer,String idsolicitud, double vchLatInicial, double vchLatFinal, double vchLongInicial, double vchLongFinal,String mPropina,double mPrecio,String iTipoViaje,String vchOrigenReferencia, String vchDestinoReferencia,String vchObservacion,String vchNombreInicial, String vchNombreFinal,String iEstado, String token)async{
    //idsolicitud(esta lo obtenies de la ruta donde se lista),vchLatInicial,vchLatFinal,vchLongInicial,vchLongFinal,mPrecio(este puede ser el precio q propone el chofer),mPropina,iTipoViaje,dFecReg,vchOrigenReferencia,vchDestinoReferencia,vchObservacion
    final url = '${Config.nuevaRutaApi}/registro-viaje-chofer';
    try{
      final response = await http.post(url,body: {'idchofer':idChofer,'IdTokenChofer': token,'idsolicitud' : idsolicitud, 'vchLatinicial': vchLatInicial.toString(), 'vchLatfinal': vchLatFinal.toString(), 'vchLonginicial': vchLongInicial.toString(), 'vchLongfinal': vchLongFinal.toString(), 'mPropina': '', 'mPrecio': mPrecio.toString(),'iTipoViaje': iTipoViaje,'vchOrigenReferencia':vchOrigenReferencia,'vchDestinoReferencia':vchDestinoReferencia, 'vchObservacion': vchObservacion, 'vchNombreInicial': vchNombreInicial, 'vchNombreFinal':vchNombreFinal,'iEstado': iEstado});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      return false;
    }
  }

  Future<bool> cancelTravel(String idSolicitud)async{
    final url = '${Config.nuevaRutaApi}/actualizar-solicitud-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'iEstado': '2'} );
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      return false;
    }
  }

  Future<bool> acceptTravelFinish(String idSolicitud, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/actualizar-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'idchoferUsuario': idChofer} );
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
  Future<String> acceptDriverRequest(String idSolicitud, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/actualizar-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'idchoferUsuario': idChofer} );
      final responseData = travelAcceptedResponseFromJson(response.body);
      return responseData.data.iIdViaje;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> cancelTravelUser(String idSolicitud, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/rechazar-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'idchofer': idChofer} );
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> updatePriceTravelUser(String idSolicitud, String precio)async{
    final url = '${Config.nuevaRutaApi}/actualizar-precio-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'mPrecio': precio});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> updatePriceTravelDriver(String idSolicitud, String precio, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/actualizar-precio-viaje-chofer';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'mPrecio': precio, 'idchofer': idChofer});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> sendNotification(String idSolicitud)async{
    final url = '${Config.nuevaRutaApi}/enviar-notificacion-viaje-chofer';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud});
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
  Future<List<HistoryItem>> getHistoricalRequest(String idUser, String date)async{
    final url = '${Config.nuevaRutaApi}/viaje/listado?id=$idUser&date=$date';
    try{
      final response = await http.get(url);
      final responseData = historicalModelFromJson(response.body);
      if(response.statusCode == 200){
        return responseData.data;
      }else{
        return [];
      }
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
  Future<List<HistoryItem>> getHistoricalClient(String idUser)async{
    final url = '${Config.nuevaRutaApi}/viaje/listado?id=$idUser';
    try{
      final response = await http.get(url);
      final responseData = historicalModelFromJson(response.body);
      if(response.statusCode == 200){
        return responseData.data;
      }else{
        return [];
      }
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<RequestModel> solicitudesUsuarioChofer(String idSolicitud, String idChofer)async{
    final url = '${Config.nuevaRutaApi}/solicitudes-usuario-chofer';
    try{
      final response = await http.post(url,body: {'idSolicitud': idSolicitud, 'idchofer' : idChofer});
      final responseData = solicitudUsuarioResponseFromJson(response.body);
      return responseData.data.first;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> prepareTravel(String idSolicitud)async{
    final url = '${Config.nuevaRutaApi}/actualizar-solicitud-viaje';
    try{
      final response = await http.post(url,body: {'idSolicitud' : idSolicitud, 'iEstado': '3'} );
      final responseData = requestDataFromJson(response.body);
      return responseData.success;
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
  Future<List<PaymentMethod>> getDriverPaymentMethod(String idChofer)async{
    final url = '${Config.nuevaRutaApi}/chofer/metodo-pago/informacion?choferId=$idChofer';
    try{
      final response = await http.get(url);
      final responseData = driverPaymentMethodFromJson(response.body);
      if(responseData.success){
        return responseData.data;
      }else{
        throw Exception();
      }
    } catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
  Future<bool> saveDriverPaymentMethods(SaveDriverPmBody body)async{
    final url = '${Config.nuevaRutaApi}/chofer/metodo-pago/actualizar';
    try{
      final response = await http.post(
        url, 
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body : saveDriverPmBodyToJson(body)
      );
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    } catch(error){
      return false;
    }
  }
  Future<Uint8List> getUserPhoto() async {
    try{
      http.Response response = await http.get(
        'https://d1nhio0ox7pgb.cloudfront.net/_img/g_collection_png/standard/512x512/user.png',
      );   
      return response.bodyBytes;
    }catch(e){
      return null;
    }
  }
  Future<PaymentMethodsResponse> getPaymentMethods()async{
    final _prefs = UserPreferences();
    await _prefs.initPrefs();
    final url = '${Config.nuevaRutaApi}/formas-pago';
    try{
      final response = await http.post(
        url,
        body: {
          'eEstado': 'A',
        });
      final responseData = paymentMethodsResponseFromJson(response.body);
      if(response.statusCode == 200){
        return responseData;
      }else{
        throw Exception();
      }
    } catch(_){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
  Future<bool> sendUserQualification(SaveQualificationBody body)async{
    final url = '${Config.nuevaRutaApi}/usuario/calificar';
    try{
      final response = await http.post(
        url,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body: saveQualificationBodyToJson(body)
      );
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    } catch(_){
      return false;
    }
  }
  Future<WalletData> getDriverPaymentsHistory(String choferId) async {
    try{
      final response = await http.get(
        Uri.parse('${Config.nuevaRutaApi}/pago/historial?choferId=$choferId'),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
      );
      if(response.statusCode == 200){
        final responseData = myWalletResponseFromJson(response.body);
        return responseData.data;
      }else{
        throw Exception();
      }
    }catch(e){
      print(e);
      throw Exception();
    }
  }
  Future<bool> chargeWallet(String choferId, double monto) async {
    try{
      final response = await http.post(
        Uri.parse('${Config.nuevaRutaApi}/pago/realizar-pago'),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({'choferId': choferId, 'monto': monto})
      );
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }
  Future<WalletData> getUserTravelHistory(String userId) async {
    try{
      final response = await http.get(
        Uri.parse('${Config.nuevaRutaApi}/viaje/listado?id=$userId'),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
      );
      if(response.statusCode == 200){
        final responseData = myWalletResponseFromJson(response.body);
        return responseData.data;
      }else{
        throw Exception();
      }
    }catch(e){
      print(e);
      throw Exception();
    }
  }
  Future<HistoryDetailItem> getHistoryDriverDetail(String viajeId ) async {
    try{
      final response = await http.get(
        Uri.parse('${Config.nuevaRutaApi}/viaje/detalle?viajeId=$viajeId'),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
      );
      if(response.statusCode == 200){
        final responseData = historicalDetailResponseFromJson(response.body);
        if(responseData.data.isNotEmpty){
          return responseData.data.first;
        }else{
          throw Exception();
        }
      }else{
        throw Exception();
      }
    }catch(e){
      print(e);
      throw Exception();
    }
  }
  Future<bool> saveProfile(SaveProfileBody body) async {
    try{
      final response = await http.post(
        Uri.parse('${Config.nuevaRutaApi}/usuario/actualizar-informacion-personal'),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body: saveProfileBodyToJson(body)
      );
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }
  Future<bool> uploadPhoto(String idUsuario, String photo) async {
    try{
      final response = await http.post(
        Uri.parse('${Config.nuevaRutaApi}/usuario/actualizar-imagen'),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({
          'iIdUsuario': idUsuario,
          'image': photo
        })
      );
      if(response.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }
  Future<AproxElement> calculateMinutes(double latIni, double lonIni, double latFin, double lonFin) async {
    try{
      final response = await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/distancematrix/json?origins=$latIni,$lonIni&destinations=$latFin,$lonFin&mode=driving&key=${Config.googleMapsApiKey}'),
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
      );
      if(response.statusCode == 200){
        final body = minutesResponseFromJson(response.body);
        if(body.rows.isNotEmpty && body.rows[0].elements.isNotEmpty){
          return body.rows[0].elements[0];
        }else{
          throw Exception();
        }
      }else{
        throw Exception();
      }
    }catch(e){
      print(e);
      rethrow;
    }
  }
}