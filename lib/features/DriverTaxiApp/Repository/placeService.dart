
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:HTRuta/features/DriverTaxiApp/data/Model/placeItem.dart';

import '../../../config.dart';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String language = Config.language;
    String region = Config.region;
    String apiKey = Config.googleMapsApiKey;
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&language=$language&region=$region&query=" +Uri.encodeQueryComponent(keyword);
    HttpClient client = new HttpClient();

    //var res = await http.get(url);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    return PlaceItemRes.fromJson(json.decode(responseBody));
//    if (res.statusCode == 200) {
//      print(PlaceItemRes.fromJson(json.decode(res.body)));
//      return PlaceItemRes.fromJson(json.decode(res.body));
//    } else {
//      return new List();
//    }
  }
}