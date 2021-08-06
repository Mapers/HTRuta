import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/interprovincial_screen.dart';
import 'package:HTRuta/features/features_driver/home/screens/taxi/taxi_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDriverPage extends StatefulWidget {
  final ServiceInCourseEntity serviceInCourse;
  HomeDriverPage({Key key, @required this.serviceInCourse}) : super(key: key);

  @override
  _HomeDriverPageState createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _screenName = 'HOME';

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
                case TypeServiceEnum.taxi:
                  return TaxiDriverServiceScreen(parentScaffoldKey: _scaffoldKey);
                case TypeServiceEnum.interprovincial:
                  return InterprovincialScreen(parentScaffoldKey: _scaffoldKey, serviceInCourse: widget.serviceInCourse);
                default:
                  return Text('Service not found!');
              }
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
                }
              ),
            )
          )
        ],
      ),
    );
  }
}