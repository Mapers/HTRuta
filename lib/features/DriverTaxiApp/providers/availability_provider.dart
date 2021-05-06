import 'package:flutter/material.dart';

class AvailabilityProvider with ChangeNotifier{
  bool _available = false;
  
  bool get available => _available;
  
  set available(bool available){
    _available = available;
    notifyListeners();
  }
}