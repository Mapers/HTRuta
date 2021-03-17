import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/availables_routes_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/choose_routes_client_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/search_province_client_page.dart';
import 'package:HTRuta/features/feature_client/pick_seat/presentation/pick_seat_page.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/full_screen_dialogs/list_passengers_full_screen_dialog.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/router_drive_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route toRouterDrivePage() => MaterialPageRoute(builder: (context)=> RouterDrivePage());
  static Route toChooseRouteClientPage() => MaterialPageRoute(builder: (context)=> ChooseRouteClientPage());
  static Route toSearchProvinceClientPage({@required String title,@required OnSelectProvinceDistrict onSelectProvinceDistrict,}) => MaterialPageRoute(builder: (context)=> SearchProvinceClientPage(title: title, onSelectProvinceDistrict: onSelectProvinceDistrict,));
  static Route toAvailableRoutesPage({ProvinceDistrictClientEntity origin, ProvinceDistrictClientEntity destination}) => MaterialPageRoute(builder: (context)=> AvailableRoutesPage(origin: origin, destination: destination));
  static Route toPickSeatPage() => MaterialPageRoute(builder: (context)=> PickSeatPage());
  static Route toListPassengersFullScreenDialog(String documentId, List<PassengerEntity> passengers) => MaterialPageRoute(builder: (context)=> ListPassengersFullScreenDialog(passengers, documentId: documentId), fullscreenDialog: true);
}