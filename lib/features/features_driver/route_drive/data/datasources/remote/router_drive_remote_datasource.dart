import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/http/request.dart';
import 'package:HTRuta/core/http/response.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

class RouterDriveRemoteDataSoruce {
  final RequestHttp requestHttp;
  final _prefs = UserPreferences();
  RouterDriveRemoteDataSoruce({@required this.requestHttp});
  Future<List<InterprovincialRouteEntity>> getListRouterDrives() async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(Config.nuevaRutaApi + '/interprovincial/driver/get-routes',
      data: {
        'user_id': _prefs.idChofer,
      }
    );
    if(result.success) return InterprovincialRouteEntity.fromListJson(result.data);

    return [];
  }

  Future<void> addListRouterDrives({InterprovincialRouteEntity interprovincialRoute} ) async{
    await _prefs.initPrefs();
    dynamic data = {
      'user_id': _prefs.idChofer,
      'name': interprovincialRoute.name,
      'from': interprovincialRoute.from.toMap,
      'to': interprovincialRoute.to.toMap,
      'cost': interprovincialRoute.cost,
    };
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/create',
      data: data
    );
    if(result.success) return;
    Fluttertoast.showToast(msg: 'Error: ${result.error}', toastLength: Toast.LENGTH_SHORT);
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
    if(result.success) return;
    Fluttertoast.showToast(msg: 'Error: ${result.error}', toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> deleteRouterDrives({InterprovincialRouteEntity interprovincialRoute} ) async{
    await _prefs.initPrefs();
    ResponseHttp result = await requestHttp.post(
      Config.nuevaRutaApi + '/interprovincial/driver/routes/delete',
      data: {
        'id': interprovincialRoute.id,
      }
    );
    if(result.success) return;
    Fluttertoast.showToast(msg: 'Error: ${result.error}', toastLength: Toast.LENGTH_SHORT);
  }
}