import 'dart:convert';
import 'dart:io';

import 'package:HTRuta/core/http/response.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class RequestHttp{

  final http.Client client;

  RequestHttp({@required this.client});

  Future<ResponseHttp> get(String url, { dynamic data = '' }) async {
    ResponseHttp response;
    try {
      final result = await client.get(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        }
      );
      if (result.statusCode == 200) {
        try {
          response = ResponseHttp.fromJson(json.decode(result.body));
        } catch (e) {
          response = ResponseHttp.error('[Format]: Formato no válido.');
        }
        return response;
      } else {
        response = ResponseHttp.error('Ruta no encontrada');
      }
    } on SocketException catch (e) {
      response = ResponseHttp.error(e.toString());
    }
    return response;
  }


  Future<ResponseHttp> post(String url, { dynamic data = '' }) async {
    ResponseHttp response;
    try {
      final result = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data)
      );
      switch (result.statusCode) {
        case 200:
          try {
            response = ResponseHttp.fromJson(json.decode(result.body));
          } catch (_) {
            response = ResponseHttp.error('[Format]: Formato no válido.');
          }
          return response;
        case 401:
          response = ResponseHttp.error('No autorizado');
          return response;
        case 404:
          response = ResponseHttp.error('Ruta no encontrada');
          return response;
        default:
          response = ResponseHttp.error('Algo ha pasado');
          return response;
      }
    } on SocketException catch (e) {
      response = ResponseHttp.error(e.toString());
    }
    return response;
  }
  Future<ResponseHttp> postForm(String url, { dynamic data = '' }) async {
    ResponseHttp response;
    try {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request('POST', Uri.parse(url));
      request.bodyFields = data;
      request.headers.addAll(headers);

      http.StreamedResponse responseStream = await request.send();
      switch (responseStream.statusCode) {
        case 200:
          try {
            final body = await responseStream.stream.bytesToString();
            response = ResponseHttp.fromJson(json.decode(body));
          } catch (_) {
            response = ResponseHttp.error('[Format]: Formato no válido.');
          }
          return response;
        case 401:
          response = ResponseHttp.error('No autorizado');
          return response;
        case 404:
          response = ResponseHttp.error('Ruta no encontrada');
          return response;
        default:
          response = ResponseHttp.error('Algo ha pasado');
          return response;
      }
    } on SocketException catch (e) {
      response = ResponseHttp.error(e.toString());
    }
    return response;
  }
}