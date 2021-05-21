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
  Future<ServiceInCourseEntity> getServiceInCourse() async{
    try{
      final user = await _session.get();
      await _prefs.initPrefs();
      dynamic data = {
        'driver_id': _prefs.idChofer,
        'passenger_id': user.id,
      };
      final result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/recovery-last-flow',
        data: data
      );
      return ServiceInCourseEntity.fromJson(result.data);
    } catch(_){
      return null;
    }
  }

  Future<PassengerEntity> getPassengerById(String serviceId, String passengerId, String fcmToken) async{
    dynamic data = {
      'service_id': serviceId,
      'passenger_id': passengerId,
    };
    final result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/service/get-passenger-by-id-and-service-id',
      data: data
    );
    return PassengerEntity.fromJsonServer(
      result.data,
      null,
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
    dynamic data = {
      'service_id': serviceId, 'passenger_id': passengerId, 'passenger_document_id': passengerDocumentId
    };
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/accept-request',
      data: data
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