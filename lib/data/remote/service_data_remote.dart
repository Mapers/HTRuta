import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:meta/meta.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
class ServiceDataRemote{
  final RequestHttp requestHttp;
  final _prefs = UserPreferences();
  Session _session = Session();
  ServiceDataRemote({@required this.requestHttp});

  /// Obtener cómo ha iniciado (cliente o conductor) su último servicio
  /// Obtener el tipo de servicio (taxi, interprovincial, cargo)
  /// 
  Future<ServiceInCourseEntity> getServiceInCourse() async{
      final user = await _session.get();
    try{
      await _prefs.initPrefs();
      final result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/recovery-last-flow',
        data: {
          'passenger_id' : user.id,
          'user_id': _prefs.idChofer,
        }
      );
      return ServiceInCourseEntity.fromJson(result.data);
    } catch(_){
      return null;
    }
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

  Future<bool> acceptRequest(String serviceId, String passengerId, String passengerDocumentId) async{
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/accept-request',
      data: {
        'service_id': serviceId, 'passenger_id': passengerId, 'passenger_document_id': passengerDocumentId
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