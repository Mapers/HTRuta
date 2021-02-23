import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RoterDriveEntity extends Equatable {
  final String name;
  final String origin;
  final String destination;

  RoterDriveEntity({
    @required this.name,
    @required this.origin,
    @required this.destination,
  });

  Map<String, dynamic> get toMap => {
        'name': name,
        'origin': origin,
        'destination': destination,
      };

  factory RoterDriveEntity.fromJson(
      Map<String, dynamic> dataJson) {
    return RoterDriveEntity(
      name: dataJson['name'],
      origin: dataJson['origin'],
      destination: dataJson['destination'],
    );
  }
  factory RoterDriveEntity.empty({@required int orderBranch}) {
    return RoterDriveEntity(
      name: "",
      origin: "",
      destination: "",
    );
  }
  roterDrivepyWith({
    String lineId,
    String plantId,
    int allotmentId,
    int moduleId,
  }) {
    return RoterDriveEntity(
        name: allotmentId ?? this.name,
        origin: lineId ?? this.origin,
        destination: plantId ?? this.destination,

    );
  }

  List<Object> get props => [name, origin, destination];
}
