import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/driver_cupons.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Cupons/driver_cupons_detail.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DriverCuponsDetail(driverCupons[i])));
          },
          child: Container(
            width: mqWidth(context, 42),
            height: mqHeigth(context, 35),
            margin: EdgeInsets.only(
              left: i % 2 == 0 ? mqWidth(context, 6): 0,
              right: i % 2 == 0 ? mqWidth(context, 6): 0,
              bottom: mqHeigth(context, 3)
            ),
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
                  height: mqHeigth(context, 20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                  ),
                  child: Center(
                    child: Container(
                      width: mqWidth(context, 25),
                      height: mqWidth(context, 25),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/turuta-757ba.appspot.com/o/logosplash.png?alt=media&token=e8968b22-352b-4471-8529-7ee61e7fed68')
                        )
                      )
                    )
                  )
                ),
                Container(
                  width: mqWidth(context, 42),
                  height: mqHeigth(context, 15),
                  padding: EdgeInsets.symmetric(
                    horizontal: mqWidth(context, 5),
                    vertical: mqHeigth(context, 2.5),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driverCupons[i].name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Container()),
                      Text(driverCupons[i].description, style: TextStyle(fontSize: 12)),
                      Container(height: 5),
                      Text(driverCupons[i].availableTime, style: TextStyle(fontSize: 12, color: Colors.blue)),
                    ],
                  )
                ),
              ],
            )
          ),
        )  
      );
    }

    return SingleChildScrollView(
      child: Wrap(
        children: elements,
      ),
    );
  }
}