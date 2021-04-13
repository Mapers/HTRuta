import 'dart:convert';
import 'dart:io';

import 'package:HTRuta/core/http/response.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class RequestHttp{

  final http.Client client;

  RequestHttp({@required this.client});

  Future<ResponseHttp> post(String url, { dynamic data = '' }) async {
    print('llgeeeeeeeeeeeeeeeeeeeeeee');
    ResponseHttp response;
    try {
      final result = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data)
      );
      print('###################');
      print(result.statusCode );
      print(result.reasonPhrase );
      print(result.body );
      print(result.request);
      print('###################');
      switch (result.statusCode) {
        case 200:
          response = ResponseHttp.success(json.decode(result.body));
          return response;
        case 401:
          response = ResponseHttp(success: false, data: null, error: 'No autorizado');
          return response;
        default:
          response = ResponseHttp(success: false, data: null, error: 'Algo ha pasado');
          return response;
      }
    } on SocketException catch (e) {
      response = ResponseHttp(success: false, data: null, error: e.toString());
    }
    return response;
  }
}