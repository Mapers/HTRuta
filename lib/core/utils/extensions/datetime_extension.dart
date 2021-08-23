import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get fullFormatToCard {
    return '${day.toString().padLeft(2,'0').padLeft(2, '0')} ${getMonthName(month).substring(0, 3)} ${DateFormat('y hh:mm a').format(this)}';
  }
  String get formatOnlyDate {
    return '${day.toString().padLeft(2,'0').padLeft(2, '0')}/${month.toString().padLeft(2,'0')}/$year';
  }

  String get formatOnlyTimeInAmPM {
    return '${DateFormat('hh:mma').format(this)}';
  }

  String getMonthName(int month){
    switch(month){
      case 1:
      return 'Enero';
      case 2:
      return 'Febrero';
      case 3:
      return 'Marzo';
      case 4:
      return 'Abril';
      case 5:
      return 'Mayo';
      case 6:
      return 'Junio';
      case 7:
      return 'Julio';
      case 8:
      return 'Agosto';
      case 9:
      return 'Septiembre';
      case 10:
      return 'Octubre';
      case 11:
      return 'Noviembre';
      case 12:
      return 'Diciembre';
    }
    return '-';
  }

  int calculateDifferenceInDays({DateTime otherDay}) {
    DateTime comparationDay = otherDay ?? DateTime.now();
    return comparationDay.difference(this).inDays;
  }
  static String changeDateFormat(String englishFormat){
    if(englishFormat.isEmpty) return englishFormat;
    String spanishFormat = '';
    String year = englishFormat.substring(0, 4);
    String month = englishFormat.substring(5, 7);
    String day = englishFormat.substring(8, 10);
    spanishFormat = day + '-' +  month + '-' + year;
    return spanishFormat;
  }
  static String parseDateEnglish(int day, int month, int year){
    String date = '';
    date += year.toString();
    date += '-';
    if(month < 10){
      date+='0';
      date+=month.toString();
    }else{
      date+=month.toString();
    }
    date += '-';
    if(day < 10){
      date+='0';
      date+=day.toString();
    }else{
      date+=day.toString();
    }
    return date;
  }
  static String parseDateSpanishV2(DateTime date){
    if(date == null) return '';
    String dateStr = '';
    if(date.day < 10){
      dateStr+='0';
      dateStr+=date.day.toString();
    }else{
      dateStr+=date.day.toString();
    }
    dateStr += '-';
    if(date.month < 10){
      dateStr+='0';
      dateStr+=date.month.toString();
    }else{
      dateStr+=date.month.toString();
    }
    dateStr += '-';
    dateStr += date.year.toString();
    return dateStr;
  }
  static String parseDateEnglishV2(DateTime date){
    if(date == null) return '';
    String dateStr = '';
    dateStr += date.year.toString();
    dateStr += '-';
    if(date.month < 10){
      dateStr+='0';
      dateStr+=date.month.toString();
    }else{
      dateStr+=date.month.toString();
    }
    dateStr += '-';
    if(date.day < 10){
      dateStr+='0';
      dateStr+=date.day.toString();
    }else{
      dateStr+=date.day.toString();
    }
    return dateStr;
  }
  static String parseDateSpanish(DateTime date){
    if(date == null) return '';
    String dateStr = '';
    if(date.day < 10){
      dateStr+='0';
      dateStr+=date.day.toString();
    }else{
      dateStr+=date.day.toString();
    }
    dateStr += '-';
    if(date.month < 10){
      dateStr+='0';
      dateStr+=date.month.toString();
    }else{
      dateStr+=date.month.toString();
    }
    dateStr += '-';
    dateStr += date.year.toString();
    return dateStr;
  }
  static DateTime dateFromString(String value){
    if(value.isEmpty) return null;
    List<String> times = value.split('-');
    if(times.length != 3) return null;
    DateTime newDate = DateTime(
      int.parse(times[0]),
      int.parse(times[1]),
      int.parse(times[2]),
    );
    return newDate;
  }

}