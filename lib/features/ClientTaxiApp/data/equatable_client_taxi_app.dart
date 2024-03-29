import 'package:collection/collection.dart';

/// A class that helps implement equality
/// without needing to explicitly override == and [hashCode].
/// Equatables override their own == and [hashCode] based on
/// the provided `properties`.
abstract class EquatableClientTaxiApp {
  /// The [List] of `props` (properties) which will be used to determine whether
  /// two [Equatables] are equal.
  final List props;

  /// The constructor takes an optional [List] of `props` (properties) which
  /// will be used to determine whether two [Equatables] are equal.
  /// If no properties are provided, `props` will be initialized to
  /// an empty [List].
  EquatableClientTaxiApp([this.props = const []]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EquatableClientTaxiApp &&
              runtimeType == other.runtimeType &&
              const IterableEquality().equals(props, other.props);

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const IterableEquality().hash(props);

  @override
  String toString() => props.isNotEmpty ? props.toString() : super.toString();
}
