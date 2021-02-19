import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RoterDriveEntity extends Equatable {
  final String name;
  final String lastName;
  final String origin;
  final String destination;

  RoterDriveEntity({
    @required this.name,
    @required this.lastName,
    @required this.origin,
    @required this.destination,
  });

  Map<String, dynamic> get toMap => {
        'name': name,
        'lastName': lastName,
        'origin': origin,
        'destination': destination,
      };

  factory RoterDriveEntity.fromJson(
      Map<String, dynamic> dataJson) {
    return RoterDriveEntity(
      name: dataJson['name'],
      lastName: dataJson['lastName'],
      origin: dataJson['origin'],
      destination: dataJson['destination'],
    );
  }
  factory RoterDriveEntity.empty({@required int orderBranch}) {
    return RoterDriveEntity(
      name: "",
      lastName: "",
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
        lastName: moduleId ?? this.lastName,
        origin: lineId ?? this.origin,
        destination: plantId ?? this.destination,

    );
  }

  List<Object> get props => [name, lastName, origin, destination];
}
