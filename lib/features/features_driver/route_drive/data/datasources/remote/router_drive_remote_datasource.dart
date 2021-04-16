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
  //!borrar
  List<InterprovincialRouteEntity> interprovincialRoutes =[];
  Future<List<InterprovincialRouteEntity>> getListRouterDrives() async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/get-routes',
      data: {
        'user_id': _prefs.idChofer,
      }
    );
    List<InterprovincialRouteEntity> routeDrives = InterprovincialRouteEntity.fromListJson(result.data);
    return routeDrives;
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
  Future<List<InterprovincialRouteEntity>> deleteRouterDrives({InterprovincialRouteEntity interprovincialRoute} ) async{
    int index  = interprovincialRoutes.indexOf(interprovincialRoute);
    interprovincialRoutes.removeAt(index);
    return interprovincialRoutes;
  }

}
