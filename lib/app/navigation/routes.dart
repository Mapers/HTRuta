import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/presentation/home_client_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/availables_routes_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/qualification_client_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/travel_negotation_page.dart';
import 'package:HTRuta/features/feature_client/pick_seat/presentation/pick_seat_page.dart';
import 'package:HTRuta/features/features_driver/home/presentations/home_driver_page.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/full_screen_dialogs/list_passengers_full_screen_dialog.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/full_screen_dialogs/list_requests_full_screen_dialog.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/router_drive_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route toHomePassengerPage() => MaterialPageRoute(builder: (context)=> HomeClientPage());
  static Route toHomeDriverPage({ ServiceInCourseEntity serviceInCourse }) => MaterialPageRoute(builder: (context)=> HomeDriverPage(serviceInCourse: serviceInCourse));
  static Route toRouterDrivePage() => MaterialPageRoute(builder: (context)=> RouterDrivePage());
  static Route toAvailableRoutesPage() => MaterialPageRoute(builder: (context)=> AvailableRoutesPage());
  static Route toPickSeatPage() => MaterialPageRoute(builder: (context)=> PickSeatPage());
  static Route toTravelNegotationPage({@required AvailableRouteEntity availablesRoutesEntity}) => MaterialPageRoute(builder: (context)=> TravelNegotationPage(availablesRoutesEntity: availablesRoutesEntity,));
  static Route toListPassengersFullScreenDialog(String documentId, String serviceId) => MaterialPageRoute(builder: (context)=> ListPassengersFullScreenDialog(documentId: documentId, serviceId: serviceId), fullscreenDialog: true);
  static Route toListInterprovincialRequestFullScreenDialog(String documentId, String serviceId) => MaterialPageRoute(builder: (context)=> ListRequestsFullScreenDialog(documentId: documentId, serviceId: serviceId), fullscreenDialog: true);
  static Route toQualificationClientPage({@required String documentId, @required String passengerId, @required AvailableRouteEntity availablesRoutesEntity}) => MaterialPageRoute(builder: (context)=> QualificationClientPage(availablesRoutesEntity: availablesRoutesEntity,documentId: documentId,passengerId: passengerId, ));
}