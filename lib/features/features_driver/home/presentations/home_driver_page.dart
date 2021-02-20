import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/widgets/taxi_widgets.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/DriverTaxiApp/enums/type_service_driver_enum.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/presentations/widgets/change_service_driver_widget.dart';
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
              if(data.typeService == TypeServiceDriver.taxi){
                return TaxiHomeDriverScreen(parrentScaffoldKey: _scaffoldKey);
              }
              return Text('Otro pe :c');
            },
          ),
          Positioned(
            top: 50,
            left: 10,
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100.0),),
              ),
              child: IconButton(
                icon: Icon(Icons.menu,size: 20.0,color: blackColor),
                onPressed: (){
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            )
          ),
          ChangeServiceDriverWidget(),
        ],
      ),
    );
  }
}