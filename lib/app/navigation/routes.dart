import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/availables_routes_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/travel_negotation_page.dart';
import 'package:HTRuta/features/feature_client/pick_seat/presentation/pick_seat_page.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/router_drive_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route toRouterDrivePage() => MaterialPageRoute(builder: (context)=> RouterDrivePage());
  static Route toAvailableRoutesPage({ProvinceDistrictClientEntity origin, ProvinceDistrictClientEntity destination}) => MaterialPageRoute(builder: (context)=> AvailableRoutesPage(origin: origin, destination: destination));
  static Route toPickSeatPage() => MaterialPageRoute(builder: (context)=> PickSeatPage());
  static Route toTravelNegotationPage({@required AvailableRouteEntity availablesRoutesEntity}) => MaterialPageRoute(builder: (context)=> TravelNegotationPage(availablesRoutesEntity: availablesRoutesEntity,));
}