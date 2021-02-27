import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/loading.dart';
import 'package:HTRuta/features/DriverTaxiApp/data/Model/get_routes_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../google_map_helper.dart';
import '../../../../app/styles/style.dart';
import '../../Components/slidingUpPanel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../Networking/Apis.dart';
import '../../data/Model/direction_model.dart';
import 'stepsPartView.dart';
import 'imageSteps.dart';

class PickUp extends StatefulWidget {
  @override
  _PickUpState createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  var apis = Apis();
  GoogleMapController _mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;
  bool checkPlatform = Platform.isIOS;

  LatLng currentLocation = LatLng(39.155232, -95.473636);
  LatLng fromLocation = LatLng(39.155232, -95.473636);
  LatLng toLocation = LatLng(39.115153, -95.638949);

  String distance, duration;
  List<Routes> routesData;

  final GMapViewHelper _gMapViewHelper = GMapViewHelper();

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
    addMarker();
    getRouter();
  }


  addMarker(){
    final MarkerId _markerFrom = MarkerId('fromLocation');
    final MarkerId _markerTo = MarkerId('toLocation');
    markers[_markerFrom] = GMapViewHelper.createMaker(
      markerIdVal: 'fromLocation',
      icon: checkPlatform ? 'assets/image/gps_point_24.png' : 'assets/image/gps_point.png',
      lat: fromLocation.latitude,
      lng: fromLocation.longitude,
    );

    markers[_markerTo] = GMapViewHelper.createMaker(
      markerIdVal: 'toLocation',
      icon: checkPlatform ? 'assets/image/ic_marker_32.png' : 'assets/image/ic_marker_128.png',
      lat: toLocation.latitude,
      lng: toLocation.longitude,
    );
  }

  void getRouter() async {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    final PolylineId polylineId = PolylineId(polylineIdVal);
    polyLines.clear();
    var router;

    await apis.getRoutes(
        getRoutesRequest: GetRoutesRequestModel(
            fromLocation: fromLocation,
          toLocation: toLocation,
          mode: 'driving'
        ),
    ).then((data) {
      if (data != null) {
        router = data.result.routes[0].overviewPolyline.points;
        routesData = data.result.routes;
      }
    }).catchError((error) {
      print('DiscoveryActionHandler::GetRoutesRequest > $error');
    });

    distance = routesData[0].legs[0].distance.text;
    duration = routesData[0].legs[0].duration.text;

    polyLines[polylineId] = GMapViewHelper.createPolyline(
        polylineIdVal: polylineIdVal,
        router: router,
        formLocation: fromLocation,
        toLocation: toLocation,
    );
    setState(() {});
    _gMapViewHelper.cameraMove(fromLocation: fromLocation,toLocation: toLocation,mapController: _mapController);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildInfoLayer(),
          Positioned(
            top: 30.0,
            left: 0.0,
            child: _buildStepDirection(),
          )
        ],
      ),
    );
  }

  Widget _buildStepDirection(){
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: 50.0,
      width: screenSize.width,
      color: greenColor,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_upward,color: blackColor,),
            onPressed: (){
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0,right: 5.0),
            child: Text('500 metros',style: textBoldBlack,),
          ),
          Text('Dirígete hacia el suroeste en Av. Peru 897',style: textStyle,)
        ],
      ),
    );
  }

  Widget _buildInfoLayer(){
    final screenSize = MediaQuery.of(context).size;
    final maxHeight = 0.70*screenSize.height;
    final minHeight = 130.0;

    final panel =
    Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(duration ?? '',style: headingBlack,),
                          Text(' / S/.29.00',style: headingPrimaryColor,)
                        ],
                      ),
                      Text(distance ?? '',style: textStyle,),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    print('Reset');
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: primaryColor,
                    ),
//                    Icon(MdiIcons.directionsFork,),
                    child: Icon(MdiIcons.directionsFork,color: whiteColor,),
                  ),
                ),
                Container(
                  width: 70.0,
                  child: ButtonTheme(
                    minWidth: 50,
                    height: 35.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30.0)),
                      elevation: 0.0,
                      color: redColor,
                      child: Text('Salir'.toUpperCase(),style: heading18,
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
//          Container(
//            padding: EdgeInsets.only(top: 10.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                GestureDetector(
//                  onTap: (){
//                    print('Reset');
//                  },
//                  child: Container(
//                    height: 40,
//                    width: 40,
//                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(50.0),
//                      color: primaryColor,
//                    ),
//                    child: Icon(Icons.arrow_back_ios,color: whiteColor,),
//                  ),
//                ),
//                GestureDetector(
//                  onTap: (){
//                    print('Reset');
//                  },
//                  child: Container(
//                    height: 40,
//                    width: 40,
//                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(50.0),
//                      color: primaryColor,
//                    ),
//                    child: Icon(Icons.arrow_forward_ios,color: whiteColor,),
//                  ),
//                ),
//              ],
//            ),
//          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: ButtonTheme(
              minWidth: screenSize.width ,
              height: 35.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0)),
                elevation: 0.0,
                color: primaryColor,
                child: Text('Destino'.toUpperCase(),style: headingWhite,
                ),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PickUp()));
                },
              ),
            ),
          ),
          Divider(),
          Expanded(
            child:
            routesData != null ?
            ListView.builder(
              shrinkWrap: true,
              itemCount: routesData[0].legs[0].steps.length,
              itemBuilder: (BuildContext context, index){
                return StepsPartView(
                  instructions: routesData[0].legs[0].steps[index].htmlInstructions,
                  duration: routesData[0].legs[0].steps[index].duration.text,
                  imageManeuver: getImageSteps(routesData[0].legs[0].steps[index].maneuver),
                );
              },
            ): Container(
              child: LoadingBuilder(),
            ),
          )
        ],
      )
    );

    return SlidingUpPanel(
      maxHeight: maxHeight,
      minHeight: minHeight,
      parallaxEnabled: true,
      parallaxOffset: .5,
      panel: panel,
      body: _buildMapLayer(),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      onPanelSlide: (double pos) => setState(() {
      }),
    );
  }

  Widget _buildMapLayer(){
    return currentLocation == null ?
      Center(child: CupertinoActivityIndicator())
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: _gMapViewHelper.buildMapView(
              context: context,
              onMapCreated: _onMapCreated,
              currentLocation: currentLocation,
              markers: markers,
              polyLines: polyLines,
              onTap: (_){

              }
            ),
    );
  }
}
