import 'package:HTRuta/features/features_driver/route_drive/presentation/widgets/app_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
class SelecctionOriginDestination extends StatefulWidget {
  final double la;
  final double lo;
  const SelecctionOriginDestination({Key key, this.la, this.lo}) : super(key: key);

  @override
  _SelecctionOriginDestinationState createState() => _SelecctionOriginDestinationState();
}

class _SelecctionOriginDestinationState extends State<SelecctionOriginDestination> {

  String origin = "";
  String destination = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: appState.initialPosition,
              zoom: 12,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: appState.onCreated,
            mapType: MapType.normal,
            compassEnabled: true,
            markers: appState.markers,
            onCameraMove: appState.onCameraMove,
            polylines: appState.polyLines,
          ),
          Positioned(
            top: 50,
            right: 15,
            left: 15,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1, 5),
                      blurRadius: 10,
                      spreadRadius: 3)
                ],
              ),
              child: TextField(
                cursorColor: Colors.black,
                // controller: appState.locationController,
                onSubmitted: (value) {
                  origin = value;
                  if(destination == ""){
                    print("entre XDDD");
                    print(origin);
                    print(destination);
                    // appState.sendRequest(txtOrigen: origin,txtDestination: destination);
                  }
                },
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20,),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Origen",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 5),
                ),
              ),
            ),
          ),
          Positioned(
            top: 110,
            right: 15,
            left: 15,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
                ],
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: appState.destinationController,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  destination = value;
                  if(origin == ""){
                    print("entre XDDD");
                    print(origin);
                    print(destination);
                    // appState.sendRequest(txtDestination: destination, txtOrigen: origin);
                  }
                },
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.local_taxi,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Destino",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}