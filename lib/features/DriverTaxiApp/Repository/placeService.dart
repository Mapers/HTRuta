import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:HTRuta/config.dart';
import 'package:HTRuta/models/place_item_model.dart';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String language = Config.language;
    String region = Config.region;
    String apiKey = Config.googleMapsApiKey;
    String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&language=$language&region=$region&query=' +Uri.encodeQueryComponent(keyword);
    HttpClient client =HttpClient();

    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return PlaceItemRes.fromJson(json.decode(responseBody));
  }
}