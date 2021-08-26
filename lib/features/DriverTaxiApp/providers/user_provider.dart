import 'package:HTRuta/features/ClientTaxiApp/Model/payment_methods_response.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  List<PaymentMethodClient> _userPaymentMethods;

  List<PaymentMethodClient> get  userPaymentMethods => _userPaymentMethods;

  set userPaymentMethods(List<PaymentMethodClient> userPaymentMethods){
    _userPaymentMethods = userPaymentMethods;
    notifyListeners();
  }
}