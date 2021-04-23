import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ServiceInCourseEntity extends Equatable{
  final String documentId;
  final TypeEntityEnum entityType;
  final TypeServiceEnum serviceType;

  ServiceInCourseEntity({
    @required this.documentId,
    @required this.entityType,
    @required this.serviceType
  });

  @override
  List<Object> get props => [entityType, serviceType, documentId];
}