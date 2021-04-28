import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:meta/meta.dart';

class RouterDriveRemoteDataSoruce {
  final RequestHttp requestHttp;
  final _prefs = UserPreferences();
  RouterDriveRemoteDataSoruce({@required this.requestHttp});
  Future<List<InterprovincialRouteEntity>> getListRouterDrives() async{
    print('..................');
    print('ccccc');
    print('..................');
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(Config.nuevaRutaApi + '/interprovincial/driver/get-routes',
      data: {
        'user_id': _prefs.idChofer,
      }
    );
<<<<<<< HEAD
    print(result.data );
    List<InterprovincialRouteEntity> routeDrives = InterprovincialRouteEntity.fromListJson(result.data);
    return routeDrives;
=======

    if(result.success) return InterprovincialRouteEntity.fromListJson(result.data);

    return [];
>>>>>>> d745c96c20b77d4d91af1595f3ffd90ed6a5bad7
  }

  Future<void> addListRouterDrives({InterprovincialRouteEntity interprovincialRoute} ) async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/create',
      data: {
        'user_id': _prefs.idChofer,
        'name':interprovincialRoute.name,
        'from': interprovincialRoute.from.toMap,
        'to': interprovincialRoute.to.toMap,
        'cost': interprovincialRoute.cost,
      }
    );
    if(!result.success){
      print('mensaje de error');
    }
  }
  Future<void> editListRouterDrives({InterprovincialRouteEntity interprovincialRoute} ) async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/update',
      data: {
        'user_id': _prefs.idChofer,
        'id': interprovincialRoute.id,
        'name':interprovincialRoute.name,
        'from': interprovincialRoute.from.toMap,
        'to': interprovincialRoute.to.toMap,
        'cost': interprovincialRoute.cost,
      }
    );
    print(result.success);
    print(result.error);
  }
  Future<void> deleteRouterDrives({InterprovincialRouteEntity interprovincialRoute} ) async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/delete',
      data: {
        'user_id': _prefs.idChofer,
        'id': interprovincialRoute.id,
      }
    );
    print(result.success);
    print(result.error);
  }

}
