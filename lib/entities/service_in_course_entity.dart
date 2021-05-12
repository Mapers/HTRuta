import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ServiceInCourseEntity extends Equatable{
  final String serviceDocumentId;
  final String requestDocumentId;
  final String passengerDocumentId;
  final TypeEntityEnum entityType;
  final TypeServiceEnum serviceType;

  ServiceInCourseEntity({
    @required this.serviceDocumentId,
    @required this.requestDocumentId,
    @required this.passengerDocumentId,
    @required this.entityType,
    @required this.serviceType
  });

  factory ServiceInCourseEntity.fromJson(dynamic data){
    print('###################');
    print(data);
    print(data['type_entity']);
    print('###################');
    if(data == null) return null;
    if(data['service_document_id'] == null) return null;
    return ServiceInCourseEntity(
      entityType: getTypeEntityEnumByString(data['type_entity']),
      //? Se requerirá traer dinámico cuando se implemente cargo
      serviceType: TypeServiceEnum.interprovincial,
      serviceDocumentId: data['service_document_id'],
      passengerDocumentId: data['passenger_document_id'],
      requestDocumentId: data['request_document_id'],
    );
  }

  @override
  List<Object> get props => [entityType, serviceType, serviceDocumentId, requestDocumentId, passengerDocumentId];
}