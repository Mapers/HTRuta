import 'package:HTRuta/app/widgets/loading_positioned.dart';
import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/in_route_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/map_interprovincial_driver_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/on_whereabouts_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/routes_interprovincial_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/custom_dropdown_driver.dart';

class InterprovincialScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final ServiceInCourseEntity serviceInCourse;
  InterprovincialScreen({Key key, @required this.parentScaffoldKey, this.serviceInCourse}) : super(key: key);

  @override
  _InterprovincialScreenState createState() => _InterprovincialScreenState();
}

class _InterprovincialScreenState extends State<InterprovincialScreen> {

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String documentID = widget.serviceInCourse?.serviceDocumentId;
      BlocProvider.of<InterprovincialDriverBloc>(context).add(GetDataInterprovincialDriverEvent(documentID));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InterprovincialDriverLocationBloc>(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          MapInterprovincialDriverWidget(),
          CustomDropdownDriver(),
          BlocBuilder<InterprovincialDriverBloc, InterprovincialDriverState>(
            builder: (context, state) {
              if(state is DataInterprovincialDriverState){
                BlocProvider.of<InterprovincialDriverLocationBloc>(context).add(SetDocumentIdInterprovincialDriverLocationEvent(documentId: state.documentId));
                if(state.status == InterprovincialStatus.loading){
                  return LoadingPositioned(label: state.loadingMessage);
                }else if(state.status == InterprovincialStatus.notEstablished){
                  return RoutesInterprovincialCardWidget();
                }else if(state.status == InterprovincialStatus.onWhereabouts){
                  return OnWhereaboutsWidget(route: state.routeService, routeStartDateTime: state.routeStartDateTime, documentId: state.documentId);
                }else if(state.status == InterprovincialStatus.inRoute){
                  return InRouteWidget(route: state.routeService, routeStartDateTime: state.routeStartDateTime, documentId: state.documentId);
                }
              }
              return Container();
            },
          )
        ],
      )
    );
  }
}