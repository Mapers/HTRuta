extension DoubleExtension on double {
  /// Number in meters
  String toDistanceString({bool space = true}) {
    String strSpace = space ? ' ' : '';
    if(this > 1000) return '${toStringAsFixed(1)}${strSpace}Km';
    return '${toStringAsFixed(0)}${strSpace}m';
  }
}