extension IntExtension on int {
  /// Number in minutes
  String toTimeString({bool space = true}) {
    String strSpace = space ? ' ' : '';
    if(this > 60) return '${toStringAsFixed(0)}${strSpace}hr';
    return '${toStringAsFixed(0)}${strSpace}min';
  }
}