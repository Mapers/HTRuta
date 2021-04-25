import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CommentsDriverEntity extends Equatable{
  final String passenger_name;
  final DateTime registered_at;
  final String comment;

  CommentsDriverEntity( {
    @required this.passenger_name,
    @required this.registered_at,
    @required this.comment,
  });
  Map<String, dynamic> get toMap => {
    'passenger_name': passenger_name,
    'registered_at': registered_at,
    'comment': comment,
  };

  factory CommentsDriverEntity.fromJson(Map<String, dynamic> dataJson){
    return CommentsDriverEntity(
      passenger_name: dataJson['passenger_name'],
      registered_at: DateTime.parse( dataJson['registered_at'] ),
      comment: dataJson['comment'],
    );
  }
  static List<CommentsDriverEntity> fromListJson(List<dynamic> listJson){
    List<CommentsDriverEntity> list = [];
    listJson.forEach((data) => list.add(CommentsDriverEntity.fromJson(data)));
    return list;
  }


  @override
  List<Object> get props => [passenger_name, registered_at, comment];
}