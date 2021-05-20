import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Home/home_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/interprovincial_client_screen.dart';
import 'package:HTRuta/features/features_driver/home/presentations/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeClientPage extends StatefulWidget {
  final ServiceInCourseEntity serviceInCourse;
  const HomeClientPage({Key key, @required this.serviceInCourse}) : super(key: key);

  @override
  _HomeClientPageState createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _screenName = 'HOME';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuScreens(activeScreenName: _screenName),
      body: Stack(
        alignment: Alignment.center,
        children: [
          BlocBuilder<ClientServiceBloc, ClientServiceState>(
            builder: (ctx, state){
              DataClientServiceState data = state;
              switch (data.typeService) {
                case TypeServiceEnum.taxi:
                  return HomeScreens(parentScaffoldKey: _scaffoldKey);
                case TypeServiceEnum.interprovincial:
                  return InterprovincialClientScreen();
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