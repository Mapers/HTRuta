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
    ResponseHttp result;
    try{
      result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/recovery-last-flow',
        data: {
          'user_id': _prefs.idChofer
        }
      );
    } catch(_){
      return null;
    }
    if(result.data == null) return null;
    if(result.data['document_id'] == null) return null;
    return ServiceInCourseEntity(
      entityType: getTypeEntityEnumByString(result.data['type_entity']),
      serviceType: TypeServiceEnum.interprovincial,
      documentId: result.data['document_id']
    );
  }

  Future<PassengerEntity> getPassengerById(String passengerId, String documentId, String fcmToken) async{
    //! Passenger está mockeado :c
    return PassengerEntity.fromJsonServer(
      PassengerEntity.mock().toFirestore,
      documentId,
      fcmToken
    );
  }

  Future<InterprovincialRouteInServiceEntity> getInterprovincialRouteInServiceById(String serviceId) async{
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/service/get-by-id',
      data: {
        'service_id': serviceId
      }
    );
    if(result.success){
      return InterprovincialRouteInServiceEntity.fromJson(result.data);
    }
    return null;
  }

  Future<bool> acceptRequest(String serviceId, String passengerId) async{
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/accept-request',
      data: {
        'service_id': serviceId, 'passenger_id': passengerId
      }
    );
    return result.success;
  }

  Future<bool> rejectRequest(String serviceId, String passengerId) async{
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/reject-request',
      data: {
        'service_id': serviceId, 'passenger_id': passengerId
      }
    );
    return result.success;
  }

}