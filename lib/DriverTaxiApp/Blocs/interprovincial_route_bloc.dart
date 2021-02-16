import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/config.dart';

class InterprovincialRouteBloc with ChangeNotifier {
  StreamController<Place> locationController = StreamController<Place>.broadcast();
  Place startRoute;
  Place finishRoute;
  Place currentLocation;
  List<Place> listPlace;

  Stream get placeStream => locationController.stream;

  Future<List<Place>> search(String query) async {
    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=${Config.apiKey}&language=${Config.language}&region=${Config.region}&locationbias=circle:5000@${finishRoute.lat},${finishRoute.lng}&query="+Uri.encodeQueryComponent(query);//Uri.encodeQueryComponent(query)
    Response response = await Dio().get(url);
    listPlace = Place.parseLocationList(response.data);
    notifyListeners();
    return listPlace;
  }

  void locationSelected(Place location) {
    locationController.sink.add(location);
  }

  void setStartRoute(Place location) {
    notifyListeners();
    startRoute = location;
  }
  void setFinishRoute(Place location) {
    notifyListeners();
    finishRoute = location;
  }

  @override
  void dispose() {
    locationController.close();
    super.dispose();
  }
}