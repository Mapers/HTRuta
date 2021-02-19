import 'dart:convert';
import 'dart:io';

import 'package:HTRuta/features/ClientTaxiApp/Apis/request_http.dart';
import 'package:http/http.dart' as http;

class RequestHttp{



  Future<ResponseHttp> get(String url, { dynamic data = "" }) async {
    ResponseHttp response;
    try {
      final result = await http.get(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        }
      );
      if (result.statusCode == 200) {
        try {
          response = ResponseHttp.fromJson(json.decode(result.body));
        } catch (e) {
          print(e.toString());
          response = ResponseHttp.error("[Format]: Formato no válido.");
        }
        return response;
      } else {
        response = ResponseHttp.error("Ruta no encontrada");
      }
    } on SocketException catch (e) {
      response = ResponseHttp.error(e.toString());
    }
    return response;
  }

  Future<ResponseHttp> post(String url, { dynamic data = "" }) async {
    ResponseHttp response;
    try {
      final result = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        encoding: Encoding.getByName('utf-8'),
        body: data
      );
      print(result.body);
      if (result.statusCode == 200) {
        try {
          response = ResponseHttp.fromJson(json.decode(result.body));
        } catch (e) {
          print(e.toString());
          response = ResponseHttp.error("[Format]: Formato no válido.");
        }
        return response;
      } else {
        response = ResponseHttp.error("Ruta no encontrada");
      }
    } on SocketException catch (e) {
      response = ResponseHttp.error(e.toString());
    }
    return response;
  }
}
