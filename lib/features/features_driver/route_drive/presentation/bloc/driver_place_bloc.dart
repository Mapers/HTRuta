import 'dart:async';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HTRuta/entities/location_entity.dart';

class DriverTaxiPlaceBloc with ChangeNotifier {
  StreamController<Place> locationController = StreamController<Place>.broadcast();
  LocationEntity fromLocation;
  LocationEntity toLocation;
  List<Place> listPlace = [];

  Stream get placeStream => locationController.stream;

  Future<List<Place>> search(String query, {Position currentPosition}) async {
    try{
      String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?key=${Config.googleMapsApiKey}&language=${Config.language}&region=${Config.region}&locationbias=circle:5000@${currentPosition != null ? currentPosition.latitude : fromLocation.latLang.latitude},${currentPosition != null ? currentPosition.longitude : fromLocation.latLang.latitude}&query='+Uri.encodeQueryComponent(query);//Uri.encodeQueryComponent(query)
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

  Future<void> selectToLocation(LocationEntity location) async {
    toLocation = location;
    notifyListeners();
  }

  Future<void> getCurrentLocation(LocationEntity location) async {
    fromLocation = location;
    notifyListeners();
  }
  Future<void> selectFromLocation(LocationEntity location) async {
    fromLocation = location;
    notifyListeners();
  }
  bool routeReady(){
    return ((fromLocation != null) && (toLocation != null)); 
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