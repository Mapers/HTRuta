import 'dart:async';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/config.dart';
import 'package:geolocator/geolocator.dart';

class ClientTaxiPlaceBloc with ChangeNotifier {
  StreamController<Place> locationController = StreamController<Place>.broadcast();
  Place locationSelect;
  Place formLocation;
  List<Place> listPlace = [];

  Stream get placeStream => locationController.stream;

  Future<List<Place>> search(String query, {Position currentPosition}) async {
    try{
      String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?key=${Config.googleMapsApiKey}&language=${Config.language}&region=${Config.region}&locationbias=circle:5000@${currentPosition != null ? currentPosition.latitude : formLocation.lat},${currentPosition != null ? currentPosition.longitude : formLocation.lng}&query='+Uri.encodeQueryComponent(query);//Uri.encodeQueryComponent(query)
      Response response = await Dio().get(url);
      listPlace = Place.parseLocationList(response.data);
      notifyListeners();
      return listPlace;
    }catch(e){
      return [];
    }
  }

  void locationSelected(Place location) {
    locationController.sink.add(location);
  }

  Future<void> selectLocation(Place location) async {
    locationSelect = location;
    notifyListeners();
  }

  Future<void> getCurrentLocation(Place location) async {
    formLocation = location;
    notifyListeners();
  }
  Future<void> selectFromLocation(Place location) async {
    formLocation = location;
    notifyListeners();
  }
  bool routeReady(){
    return ((formLocation != null) && (locationSelect != null)); 
  }
  
  void clearPlacesList(){
    listPlace = [];
    notifyListeners();
  }

  @override
  void dispose() {
    locationController.close();
    super.dispose();
  }
}