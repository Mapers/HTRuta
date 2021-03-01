import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/pages/availables_routes_page.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/pages/choose_routes_client_page.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/pages/search_province_client_page.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/router_drive_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route toRouterDrivePage() => MaterialPageRoute(builder: (context)=> RouterDrivePage());
  static Route toChooseRouteClientPage() => MaterialPageRoute(builder: (context)=> ChooseRouteClientPage());
  static Route toSearchProvinceClientPage({@required String title,@required Function onTap,}) => MaterialPageRoute(builder: (context)=> SearchProvinceClientPage(title: title,getPrivinceOrigin: onTap,));
  static Route toAvailableRoutesPage() => MaterialPageRoute(builder: (context)=> AvailableRoutesPage());
}