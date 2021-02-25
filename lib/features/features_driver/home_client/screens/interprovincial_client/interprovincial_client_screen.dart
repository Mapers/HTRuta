import 'package:HTRuta/app/widgets/loading_positioned.dart';
import 'package:HTRuta/features/features_driver/home/presentations/widgets/change_service_driver_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/inteprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/in_route_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/map_interprovincia_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/routes_interprovincial_card_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/waiting_to_start_route_widget.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/bloc/client_interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/widgets/change_service_client_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/injection_container.dart' as ij;

class InterprovincialClientScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  InterprovincialClientScreen({Key key, @required this.parentScaffoldKey}) : super(key: key);

  @override
  _InterprovincialClientScreenState createState() => _InterprovincialClientScreenState();
}

class _InterprovincialClientScreenState extends State<InterprovincialClientScreen> {

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BlocProvider.of<InterprovincialBloc>(context).add(GetDataInterprovincialEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ij.sl<InterprovincialLocationBloc>(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          MapInterprovincialWidget(),
          ChangeServiceClientWidget(),
          BlocBuilder<ClientInterprovincialBloc, ClientInterprovincialState>(
            builder: (context, state) {
              if(state is DataInterprovincialState){
                // if(state.status == InterprovincialStatus.loading){
                //   return LoadingPositioned(label: state.loadingMessage);
                // }else if(state.status == InterprovincialStatus.notEstablished){
                //   return RoutesInterprovincialCardWidget();
                // }else if(state.status == InterprovincialStatus.waiting){
                //   return WaitingToStartRouteWidget(route: state.route);
                // }else if(state.status == InterprovincialStatus.inRoute){
                //   return InRouteWidget(route: state.route);
                // }
              }
              return Container();
            },
          )
        ],
      )
    );
  }
}