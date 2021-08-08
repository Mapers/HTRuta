import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/driver_cupons.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:flutter/material.dart';


class DriverCupons extends StatefulWidget {
  @override
  _DriverCuponsState createState() => _DriverCuponsState();
}

class _DriverCuponsState extends State<DriverCupons> {
  final String screenName = 'CUPONS';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  List<DriverCuponsModel> cuponsLoaded;
  final _prefs = UserPreferences();

  final pickupApi = PickupApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDriverScreens(activeScreenName: screenName),
      appBar: AppBar(
        title: Text('Mis cupones',style: TextStyle(color: blackColor)),
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: cuponsLoaded == null ? FutureBuilder(
        future: pickupApi.getDriverCupons(_prefs.idChoferReal),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasError) return Container();
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return Container();
            case ConnectionState.none: return Container();
            case ConnectionState.active: {
              cuponsLoaded = snapshot.data;
              return createFutureContent(snapshot.data);
            }
            case ConnectionState.done: {
              cuponsLoaded = snapshot.data;
              return createFutureContent(snapshot.data);
            }
          }
          return Container();
        }
      ) : createFutureContent(cuponsLoaded)
    );
  }
  Widget createFutureContent(List<DriverCuponsModel> driverCupons){
    if(driverCupons.isEmpty) return Container();
    List<Widget> elements = [];
    for(int i = 0; i < driverCupons.length; i++){
      elements.add(
        Container(
          width: mqWidth(context, 42),
          height: mqHeigth(context, 42),
          margin: EdgeInsets.symmetric(horizontal: i % 2 == 0 ? mqWidth(context, 6): 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: Offset(10, 10),
                spreadRadius: 10
              )
            ]
          ),
          child: Column(
            children: [
              Container(
                width: mqWidth(context, 42),
                height: mqHeigth(context, 15),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                ),
              ),
              Container(
                width: mqWidth(context, 42),
                height: mqHeigth(context, 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                ),
                
              ),
            ],
          )
        )  
      );
    }

    return Wrap(
      children: elements,
    );
  }
}