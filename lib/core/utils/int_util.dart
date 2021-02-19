class IntUtils {

  /// ${number} >= 1000000 ==> ${number} "M"
  ///
  /// ${number} >= 1000 ==> ${number} "K"
  ///
  /// ${number} < 1000 ==> ${number}
  static String abreviature(int number) {
    String totalViewed;
    if((number / 1000000).round() > 0){
      totalViewed = (number / 1000000).toStringAsFixed(1) + " M";
    }else if((number / 1000).round() > 0){
      totalViewed = (number / 1000).toStringAsFixed(1) + " K";
    }else {
      totalViewed = number.toString();
    }
    return totalViewed;
  }
}