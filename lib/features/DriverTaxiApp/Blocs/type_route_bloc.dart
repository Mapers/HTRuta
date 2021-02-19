import 'package:HTRuta/features/DriverTaxiApp/enums/type_route_enum.dart';
import 'package:flutter/material.dart';

class TypeRouteBloc with ChangeNotifier {
  TypeRoute type = TypeRoute.taxi;

  void changeType(TypeRoute newType){
    type = newType;
    notifyListeners();
  }
}