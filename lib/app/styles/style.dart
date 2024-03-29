import 'package:HTRuta/core/utils/colors_util.dart';
import 'package:flutter/material.dart';
import '../colors.dart';

double mqHeigth(BuildContext context, double percentage){
  return MediaQuery.of(context).size.height * (percentage/100);
}
double mqWidth(BuildContext context, double percentage){
  return MediaQuery.of(context).size.width * (percentage/100);
}

TextStyle textStyle = style();
TextStyle textStyleWhite = style( color: Colors.white );
TextStyle textBoldBlack = style(
  color: const Color(0XFF000000),
  fontWeight: FontWeight.bold,
);
TextStyle textBoldWhite = style(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
TextStyle textBlackItalic = TextStyle(
  color: const Color(0XFF000000),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
  fontFamily: 'OpenSans',
);
TextStyle textGrey = style( color: Colors.grey );
TextStyle textGreyBold = style(
  color: Colors.grey,
  fontWeight: FontWeight.bold,
);
TextStyle textStyleBlue = style(color: primaryColor );
TextStyle textStyleActive = style(color: const Color(0xFFF44336) );
TextStyle textStyleValidate = TextStyle(
  color: const Color(0xFFF44336),
  fontSize: 11.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
  fontFamily: 'OpenSans',
);
TextStyle textGreen = style(color: Color(0xFF00c497) );
TextStyle textStyleSmall = style(
    color: Color.fromRGBO(255, 255, 255, 0.8),
    fontSize: 12,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold
);
TextStyle headingWhite = style(
  color: Colors.white,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);
TextStyle headingWhite18 = style(
  color: Colors.white,
  fontSize: 18,
);
TextStyle headingRed = style(
  color: redColor,
  fontSize: 22,
);
TextStyle headingGrey = style(
  color: Colors.grey,
  fontSize: 22,
);
TextStyle heading18 = style(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
TextStyle textStyleHeading18Black = style(
  color: blackColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
TextStyle heading20Black = style(
  color: blackColor,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
TextStyle headingBlack = style(
  color: blackColor,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);
TextStyle headingPrimaryColor = style(
  color: primaryColor,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);
TextStyle headingLogo = style(
  color: blackColor,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);
TextStyle heading35 = style(
  color: Colors.white,
  fontSize: 35,
  fontWeight: FontWeight.bold,
);
TextStyle heading35Black = style(
  color: blackColor,
  fontSize: 35,
  fontWeight: FontWeight.bold,
);
TextStyle heading35Primary = style(
  color: primaryColor,
  fontSize: 35,
  fontWeight: FontWeight.bold,
);
TextStyle heading35BlackNormal = style(
  color: blackColor,
  fontSize: 35,
);
TextStyle style({
    Color color = Colors.black,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    String fontFamily = 'OpenSans'
  }){
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily:  fontFamily,
  );
}

ThemeData appTheme = ThemeData(
  fontFamily: 'MYRIADPRO',
  primarySwatch: MaterialColor(primaryColor.value, ColorsUtil.getSwatch(primaryColor)),
  primaryColor: primaryColor,
  accentColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  indicatorColor: Colors.white,
  splashColor: Colors.white24,
  canvasColor: Colors.white,
  backgroundColor: Colors.white,
  errorColor: Color(0xFFB00020),
  iconTheme: IconThemeData(color: primaryColor),
  buttonColor: primaryColor,
  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textTheme: ButtonTextTheme.primary,
  ),

);