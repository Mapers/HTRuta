import 'dart:async';

import 'package:HTRuta/config.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/Model/get_routes_request_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'json_message.dart';
import 'web_api_client.dart';

class MapNetwork {
  static const domain = 'https://maps.googleapis.com/maps/api/directions/json';
  static final GMapClient _gmapClient = GMapClient();

  Future getHttp(String query) async {
    try {
      Response response = await Dio().get('$domain?$query');
      return response.data;
    } catch (_) {
    }
  }

  Future<JsonMessage> getRoutes({@required GetRoutesRequestModel getRoutesRequest}) async {
    return await _gmapClient.fetch(
      url: domain,
      key: Config.googleMapsApiKey,
      queryParameters: getRoutesRequest.toJson(),
    );
  }
}