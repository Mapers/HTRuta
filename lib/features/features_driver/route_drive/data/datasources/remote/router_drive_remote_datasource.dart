import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';

class RouterDriveRemoteDataSoruce {
  final RequestHttp requestHttp;
  final Session _session =  Session();
  final _prefs = UserPreferences();
  RouterDriveRemoteDataSoruce({this.requestHttp});
  //!borrar
  List<RouteEntity> roterDrives =[];
  Future<List<RouteEntity>> getListRouterDrives() async{
    // final userSession = await _session.get();
    await _prefs.initPrefs();

    print(_prefs.idChofer);
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/get-routes',
      data: {
        'user_id': _prefs.idChofer,
      }
    );
    List<RouteEntity> routeDrives = RouteEntity.fromListJson(result.data['data']);
    return routeDrives;
  }

  Future<List<RouteEntity>> addListRouterDrives({RouteEntity routeDrive} ) async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/create',
      data: {
        'user_id': _prefs.idChofer,
        'name':routeDrive.name,
        'from': routeDrive.from.toMap,
        'to': routeDrive.to.toMap,
        'cost': routeDrive.cost,
      }
    );
    print('..................');
    print(result.data);
    print(result.error);
    print(result.success);
    print('..................');
    return roterDrives;
  }
  Future<List<RouteEntity>> editListRouterDrives({RouteEntity routeDrive} ) async{
    final userSession = await _session.get();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/create',
      data: {
        'user_id': userSession.id,
        'id': routeDrive.id,
        'name':routeDrive.name,
        'from': routeDrive.from.toMap,
        'to': routeDrive.to.toMap,
        'cost': routeDrive.cost,
      }
    );
    print(result.success);
    print(result.error);
  }
  Future<List<RouteEntity>> deleteRouterDrives({RouteEntity roterDrive} ) async{
    int index  = roterDrives.indexOf(roterDrive);
    roterDrives.removeAt(index);
    return roterDrives;
  }

}
