import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';


class ServiceDataRemote{
  final http.Client client;
  ServiceDataRemote({@required this.client});

  /// Obtener cómo ha iniciado (cliente o conductor) su último servicio
  /// Obtener el tipo de servicio (taxi, interprovincial, cargo)
  Future<ServiceInCourseEntity> getServiceInCourse() async{
    return ServiceInCourseEntity(
      entityType: TypeEntityEnum.driver,
      serviceType: TypeServiceEnum.interprovincial
    );
  }

  Future<PassengerEntity> getPassengerById(int passengerId) async{
    //! Esta data debe venir desde backend
    return PassengerEntity.mock();
  }

}