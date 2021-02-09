import 'package:flutter/widgets.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Model/tabla_codigo.dart';
import 'package:flutter_map_booking/config.dart';
import 'package:http/http.dart' as http;

class TablaApi{

  Future<List<Datum>> getTipoConexion(BuildContext context) async{
    final url = '${Config.apiHost}/api_getTablaCodigos.php?id=1';

    return Future<List<Datum>>.sync(() {
      return http.post(url,body: {"id" : 1} ).then((response){
        final empresaResponse = tablaCodigoFromJson(response.body);
        return empresaResponse.data??null;
      }).catchError((onError){
        print(onError.toString());
      });
    }).catchError((onError){
        print(onError.toString());
    });
  }

  Future<List<Datum>> getSexo(BuildContext context) async{
    final url = '${Config.apiHost}/api_getTablaCodigos.php?id=2';

    return Future<List<Datum>>.sync(() {
      return http.post(url,body: {"id" : '2'} ).then((response){
        final empresaResponse = tablaCodigoFromJson(response.body);
        return empresaResponse.data??null;
      }).catchError((onError){
        print(onError.toString());
      });
    }).catchError((onError){
        print(onError.toString());
    });
  }

  Future<List<Datum>> getTipoUsuario(BuildContext context) async{
    final url = '${Config.apiHost}/api_getTablaCodigos.php?id=3';

    return Future<List<Datum>>.sync(() {
      return http.post(url,body: {"id" : '3'} ).then((response){
        final empresaResponse = tablaCodigoFromJson(response.body);
        return empresaResponse.data??null;
      }).catchError((onError){
        print(onError.toString());
      });
    }).catchError((onError){
        print(onError.toString());
    });
  }

  

  Future<List<Datum>> getEstadoUsuario(BuildContext context) async{
    final url = '${Config.apiHost}/api_getTablaCodigos.php?id=4';

    return Future<List<Datum>>.sync(() {
      return http.post(url,body: {"id" : '4'} ).then((response){
        final empresaResponse = tablaCodigoFromJson(response.body);
        return empresaResponse.data??null;
      }).catchError((onError){
        print(onError.toString());
      });
    }).catchError((onError){
        print(onError.toString());
    });
  }

  Future<List<Datum>> getEstadoDocumentacion(BuildContext context) async{
    final url = '${Config.apiHost}/api_getTablaCodigos.php?id=5';

    return Future<List<Datum>>.sync(() {
      return http.post(url,body: {"id" : '5'} ).then((response){
        final empresaResponse = tablaCodigoFromJson(response.body);
        return empresaResponse.data??null;
      }).catchError((onError){
        print(onError.toString());
      });
    }).catchError((onError){
        print(onError.toString());
    });
  }

  Future<List<Datum>> getTipoDocumentacion(BuildContext context) async{
    final url = '${Config.apiHost}/api_getTablaCodigos.php?id=6';

    return Future<List<Datum>>.sync(() {
      return http.post(url,body: {"id" : '6'} ).then((response){
        final empresaResponse = tablaCodigoFromJson(response.body);
        return empresaResponse.data??null;
      }).catchError((onError){
        print(onError.toString());
      });
    }).catchError((onError){
        print(onError.toString());
    });
  }
}