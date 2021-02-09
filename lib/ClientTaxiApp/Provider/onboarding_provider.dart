import 'package:flutter/foundation.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Model/onboarding_model.dart';

class OnBoardingProvider extends ChangeNotifier{
  List<Pantallas> _listItem;

  List<Pantallas> get listItem => this._listItem;

  set listItem(List<Pantallas> data){
    this._listItem = data;
    notifyListeners();
  }

}