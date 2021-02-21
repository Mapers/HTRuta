import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/DriverTaxiApp/enums/type_driver_service_enum.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/presentations/widgets/menu_button_widget.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/interprovincial_screen.dart';
import 'package:HTRuta/features/features_driver/home/screens/taxi/taxi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDriverPage extends StatefulWidget {
  HomeDriverPage({Key key}) : super(key: key);

  @override
  _HomeDriverPageState createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _screenName = "HOME";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDriverScreens(activeScreenName: _screenName),
      body: Stack(
        alignment: Alignment.center,
        children: [
          BlocBuilder<DriverServiceBloc, DriverServiceState>(
            builder: (ctx, state){
              DataDriverServiceState data = state;
              switch (data.typeService) {
                case TypeDriverService.taxi:
                  return TaxiDriverServiceScreen(parentScaffoldKey: _scaffoldKey);
                case TypeDriverService.interprovincial:
                  return InterprovincialScreen(parentScaffoldKey: _scaffoldKey);
                default:
                  return Text('Service not found!');
              }
            },
          ),
          MenuButtonWidget(parentScaffoldKey: _scaffoldKey),
        ],
      ),
    );
  }
}