import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(
  color: const Color(0XFF000000),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

TextStyle textStyleWhite = const TextStyle(
  color: const Color(0XFFFFFFFF),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

TextStyle textBoldBlack = const TextStyle(
  color: const Color(0XFF000000),
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);

TextStyle textBoldWhite = const TextStyle(
  color: const Color(0XFFFFFFFF),
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);

TextStyle textBlackItalic = const TextStyle(
  color: const Color(0XFF000000),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
);

TextStyle textGrey = const TextStyle(
  color: Colors.grey,
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

TextStyle textGreyBold = const TextStyle(
  color: Colors.grey,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);

TextStyle textStyleBlue = const TextStyle(
  color: primaryColor,
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

TextStyle textStyleActive = const TextStyle(
  color: const Color(0xFFF44336),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

TextStyle textStyleValidate = const TextStyle(
  color: const Color(0xFFF44336),
  fontSize: 11.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
);

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    title: base.title.copyWith(
    ),
  );
}

TextStyle textGreen = const TextStyle(
  color: const Color(0xFF00c497),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
);

final ThemeData base = ThemeData.light();

ThemeData appTheme = new ThemeData(
  fontFamily: "MYRIADPRO",
  primaryColor: primaryColor,
  buttonColor: primaryColor,
  indicatorColor: Colors.white,
  splashColor: Colors.white24,
  splashFactory: InkRipple.splashFactory,
  accentColor: const Color(0xFF13B9FD),
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  errorColor: const Color(0xFFB00020),
  highlightColor: activeColor,
  iconTheme: new IconThemeData(color: primaryColor),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: _buildTextTheme(base.textTheme),
  primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
  accentTextTheme: _buildTextTheme(base.accentTextTheme),

);

Color textFieldColor = const Color.fromRGBO(168, 160, 149, 0.6);
const Color backgroundColor = const Color(0xffeeeeee);
const Color whiteColor = const Color(0XFFFFFFFF);
const Color blackColor = const Color(0XFF242A37);
const Color greyColor = const Color(0XFFF1F2F6);
const Color greyColor2 = Colors.grey;
const Color activeColor = const Color(0xFFF44336);
const Color redColor = const Color(0xFFFF0000);
const Color buttonStop = const Color(0xFFF44336);
const Color primaryColor = const Color(0xFFFFD428);
const Color secondary = const Color(0xFFFF8900);
const Color facebook = const Color(0xFF4267b2);
const Color googlePlus = const Color(0xFFdb4437);
const Color yellow = Colors.pinkAccent;
const Color green1 = Colors.lightGreen;
const Color green2 = Colors.green;
const Color blue1 = Colors.lightBlue;
const Color blue2 = Colors.blue;
const Color tim = Colors.deepPurple;
const Color tim2 = Colors.deepPurpleAccent;

const Color greenColor = const Color(0xFF00c497);
//const Color greyColor = Colors.grey;

TextStyle textStyleSmall = const TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 0.8),
    fontSize: 12.0,
    fontWeight: FontWeight.bold);

//Image miniLogo = new Image(
//    image: new ExactAssetImage("assets/header-logo.png"),
//    height: 28.0,
//    width: 20.0,
//    alignment: FractionalOffset.center);

TextStyle headingWhite = new TextStyle(
  color: Colors.white,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

TextStyle headingWhite18 = new TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  fontWeight: FontWeight.normal,
);

TextStyle headingRed = new TextStyle(
  color: redColor,
  fontSize: 22.0,
  fontWeight: FontWeight.normal,
);

TextStyle headingGrey = new TextStyle(
  color: Colors.grey,
  fontSize: 22.0,
  fontWeight: FontWeight.normal,
);

TextStyle heading18 = new TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

TextStyle heading18Black = new TextStyle(
  color: blackColor,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

TextStyle heading20Black = new TextStyle(
  color: blackColor,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

TextStyle headingBlack = new TextStyle(
  color: blackColor,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

TextStyle headingPrimaryColor = new TextStyle(
  color: primaryColor,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

TextStyle headingLogo = new TextStyle(
  color: blackColor,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

TextStyle heading35 = new TextStyle(
  color: Colors.white,
  fontSize: 35.0,
  fontWeight: FontWeight.bold,
);

TextStyle heading35Black = new TextStyle(
  color: blackColor,
  fontSize: 35.0,
  fontWeight: FontWeight.bold,
);

TextStyle heading35Primary = new TextStyle(
  color: primaryColor,
  fontSize: 35.0,
  fontWeight: FontWeight.bold,
);

TextStyle heading35BlackNormal = new TextStyle(
  color: blackColor,
  fontSize: 35.0,
  fontWeight: FontWeight.normal,
);

const Color transparentColor = const Color.fromRGBO(0, 0, 0, 0.2);
const Color activeButtonColor = const Color.fromRGBO(43, 194, 137, 50.0);
const Color dangerButtonColor = const Color(0XFFf53a4d);

int getColorHexFromStr(String colorStr) {
  colorStr = "FF" + colorStr;
  colorStr = colorStr.replaceAll("#", "");
  int val = 0;
  int len = colorStr.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = colorStr.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("An error occurred when converting a color");
    }
  }
  return val;
}
