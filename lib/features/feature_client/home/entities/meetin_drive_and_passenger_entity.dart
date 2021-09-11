import 'package:HTRuta/entities/location_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MeetingDriveAndPassengerEntity extends Equatable{
  final int id;
  final LocationEntity pointMeeting;
  final bool isSelect;

  MeetingDriveAndPassengerEntity( {
    @required this.id,
    @required this.pointMeeting,
    @required this.isSelect
  });

  Map<String, dynamic> get toMap => {
    'id': id,
    'seating': pointMeeting,
    'isSelecte': isSelect,

  };

  @override
  List<Object> get props => [id, pointMeeting, isSelect ];
}