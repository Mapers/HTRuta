import 'package:flutter/material.dart';
import 'package:flutter_map_booking/DriverTaxiApp/theme/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bodyProgress = SpinKitRipple(color: primaryColor,size: 100.0,);
    return bodyProgress;
  }
}
//SpinKitRipple(color: primaryColor),