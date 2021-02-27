import 'package:HTRuta/features/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:flutter/foundation.dart';

class OnBoardingProvider extends ChangeNotifier{
  List<Pantallas> _listItem;

  List<Pantallas> get listItem => _listItem;

  set listItem(List<Pantallas> data){
    _listItem = data;
    notifyListeners();
  }

}