extension DoubleExtension on double {
  /// From meters value
  String toDistanceString({bool space = true}) {
    String strSpace = space ? ' ' : '';
    if(this > 1000) return '${(this/1000).toStringAsFixed(2)}${strSpace}Km';
    return '${toStringAsFixed(0)}${strSpace}m';
  }
}