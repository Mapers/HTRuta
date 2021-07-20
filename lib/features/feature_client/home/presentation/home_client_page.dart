import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Home/home_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/interprovincial_client_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
class HomeClientPage extends StatefulWidget {
  final ServiceInCourseEntity serviceInCourse;
  const HomeClientPage({Key key, @required this.serviceInCourse}) : super(key: key);

  @override
  _HomeClientPageState createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _screenName = 'HOME';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  
  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuScreens(activeScreenName: _screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
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
                    final _state = _sideMenuKey.currentState;
                    if (_state.isOpened)
                      _state.closeSideMenu(); // close side menu
                    else
                      _state.openSideMenu();
                    }
                ),
              )
            )
            // MenuButtonWidget(parentScaffoldKey: _scaffoldKey),
          ],
        ),
      )
    );
  }
}