import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class FromToEntity extends Equatable {
  final String provinceFrom;
  final String provinceTo;
  final LatLng from;
  final LatLng to;

  FromToEntity({
    @required this.provinceFrom,
    @required this.provinceTo,
    @required this.from,
    @required this.to,
  });

  @override
  List<Object> get props => throw UnimplementedError();
}
