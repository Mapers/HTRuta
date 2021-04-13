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

  Future<void> addListRouterDrives({RouteEntity routeDrive} ) async{
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
    if(!result.success){
      print('mensaje de error');
    }
  }
  Future<void> editListRouterDrives({RouteEntity routeDrive} ) async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/update',
      data: {
        'user_id': _prefs.idChofer,
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
