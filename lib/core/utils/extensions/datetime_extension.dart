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

}