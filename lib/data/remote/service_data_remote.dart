import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:meta/meta.dart';

class ServiceDataRemote{
  final RequestHttp requestHttp;
  final _prefs = UserPreferences();
  ServiceDataRemote({@required this.requestHttp});

  /// Obtener cómo ha iniciado (cliente o conductor) su último servicio
  /// Obtener el tipo de servicio (taxi, interprovincial, cargo)
  Future<ServiceInCourseEntity> getServiceInCourse() async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/recovery-last-flow',
      data: {
        'user_id': _prefs.idChofer
      }
    );
    if(result.data == null) return null;
    if(result.data.first['document_id'] == null) return null;
    return ServiceInCourseEntity(
      entityType: getTypeEntityEnumByString(result.data.first['type_entity']),
      serviceType: TypeServiceEnum.interprovincial,
      documentId: result.data.first['document_id']
    );
  }

  Future<PassengerEntity> getPassengerById(int passengerId) async{
    //! Esta data debe venir desde backend
    return PassengerEntity.mock();
  }

  Future<InterprovincialRouteInServiceEntity> getInterprovincialRouteInServiceById(String serviceId) async{
    //! Esta data debe venir desde backend
    return InterprovincialRouteInServiceEntity.test();
  }

}