import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:meta/meta.dart';

class InterprovincialDriverDataRemote {
  final RequestHttp requestHttp;
  InterprovincialDriverDataRemote({@required this.requestHttp});

  Future<String> createService({@required String documentId, @required DateTime startDateTime, @required InterprovincialRouteEntity interprovincialRoute, @required int availableSeats}) async{
    String strStartDateTime = startDateTime.toString().split('.').first;
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/driver/service/start',
      data: {
        'route_id': interprovincialRoute.id,
        'available_seats': availableSeats,
        'document_id': documentId,
        'start_date_time': strStartDateTime.substring(0, strStartDateTime.length - 3),
        'status': toStringFirebaseInterprovincialStatus(InterprovincialStatus.onWhereabouts) 
      }
    );
    if(result.success){
      return result.data;
    }
    throw ServerException(message: result.error);
  }

  Future<bool> finishService({@required String serviceId}) async{
    ResponseHttp result = await requestHttp.post('${Config.nuevaRutaApi}/interprovincial/driver/service/finish',
      data: { 'service_id': serviceId }
    );
    if(result.success){
      return result.success;
    }
    throw ServerException(message: result.error);
  }
}