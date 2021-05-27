import 'package:flutter/material.dart';

class AmountProvider with ChangeNotifier{
  String _amount = '5';
  set amount(String amount){
    _amount = amount;
    notifyListeners();
  }
  String get amount => _amount;
}