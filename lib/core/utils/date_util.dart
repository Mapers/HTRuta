class DateUtils {

  /// Yesterday : calculateDifference(date) == -1
  ///
  /// Today : calculateDifference(date) == 0
  ///
  /// Tomorrow : calculateDifference(date) == 1
  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }
}