import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  FocusNode _focus = new FocusNode();
  final formKey = new GlobalKey<FormState>();
  LocationEntity location = LocationEntity.initalPeruPosition();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  bool inputSelecter= true ;
  LatLng currentLocation;
  LatLng from;
  LatLng to;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  BitmapDescriptor currentPinLocationIcon;
  BitmapDescriptor fromPinLocationIcon;
  BitmapDescriptor toPinLocationIcon;

  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    super.initState();
  }
  void _onFocusChange(){
    if(_focus.hasFocus){
      inputSelecter = true;
      setState(() {});
    }else{
      inputSelecter =false;
      setState(() {});
    }
  }
  void _addFromToMarkers({LatLng pos, bool inputSelecter}) async{
    if(inputSelecter){
      from = pos;
      List<Placemark> placemarkFrom = await Geolocator().placemarkFromCoordinates(from.latitude, from.longitude);
      if(placemarkFrom[0].locality != ""){
        fromController.text = placemarkFrom[0].locality;
      }
      Marker markerFrom = _mapViewerUtil.generateMarker(
        latLng: from,
        nameMarkerId: 'FROM_POSITION_MARKER',
      );
      _markers[markerFrom.markerId] = markerFrom;
    }else{
      to = pos;
      List<Placemark> placemarkTo = await Geolocator().placemarkFromCoordinates(to.latitude, to.longitude);
      if(placemarkTo[0].locality != ""){
        toController.text = placemarkTo[0].locality;
      }
      Marker markerTo = _mapViewerUtil.generateMarker(
        latLng: to,
        nameMarkerId: 'TO_POSITION_MARKER',
      );
      _markers[markerTo.markerId] = markerTo;
    }

    if(_markers.length == 2){
      Polyline polyline = await _mapViewerUtil.generatePolylineXd('ROUTE_FROM_TO', from, to);
      polylines[polyline.polylineId] = polyline;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: _mapViewerUtil.build(
                height: MediaQuery.of(context).size.height,
                currentLocation: LatLng(widget.la, widget.lo),
                markers: _markers,
                polyLines: polylines,
                onTap: (pos){
                  if(inputSelecter){
                    _addFromToMarkers(  pos:pos,inputSelecter:inputSelecter );
                  }else{
                    _addFromToMarkers( pos:pos, inputSelecter:inputSelecter );
                  }
                }
              )
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
                  autofocus: true,
                  focusNode: _focus,
                  cursorColor: Colors.black,
                  controller: fromController,
                  onSubmitted: (value) async{
                    List<Placemark> placemarkOrigin = await Geolocator().placemarkFromAddress(value);
                    LatLng pos = LatLng(placemarkOrigin[0].position.latitude,placemarkOrigin[0].position.longitude);
                    _addFromToMarkers(pos: pos ,inputSelecter:true );
                  },
                  decoration: InputDecoration(
                    suffixIcon:  inputSelecter ?Icon(Icons.radio_button_checked):null,
                    labelText:"Origen" ,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15,),
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
                  controller: toController,
                  onSubmitted: (value) async {
                    List<Placemark> placemarkOrigin = await Geolocator().placemarkFromAddress(value);
                    LatLng pos = LatLng(placemarkOrigin[0].position.latitude,placemarkOrigin[0].position.longitude);
                    _addFromToMarkers(pos: pos ,inputSelecter: false );
                  },
                  decoration: InputDecoration(
                    suffixIcon: !inputSelecter?Icon(Icons.radio_button_checked):null,
                    labelText:"Destino" ,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15, top: 5),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 500,
              right: 15,
              left: 15,
              child: PrincipalButton(text: "Guardar",onPressed: (){
                formKey.currentState.save();
                BlocProvider.of<RouteDriveBloc>(context).add(AddDrivesRouteDriveEvent());
                Navigator.of(context).pop();
              },)
            ),
          ],
        ),
      ),
    );
  }
}