import 'dart:ui';
import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = Color(0xFFFDD958);
  static const Color loginGradientEnd = Color(0xFFf3c660);

  static const primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}