import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String get formatPeriod {
    return '${hourOfPeriod.toString().padLeft(2,'0')}:${minute}${getAmOrPm()}';
  }

  String getAmOrPm(){
    switch(period){
      case DayPeriod.am:
      return 'AM';
      case DayPeriod.pm:
      return 'PM';
      default:
    }
    return '-';
  }

}