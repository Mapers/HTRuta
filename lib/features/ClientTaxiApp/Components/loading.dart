import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    var bodyProgress = SpinKitRipple(color: primaryColor, size: responsive.hp(25),);
    return bodyProgress;
  }
}