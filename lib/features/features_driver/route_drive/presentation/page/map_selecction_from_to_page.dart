import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/input_map.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapSelecctionFromToMapPage extends StatefulWidget {
  final Function getFromAndTo;
  final double la;
  final double lo;
  const MapSelecctionFromToMapPage({Key key, this.la, this.lo, this.getFromAndTo}) : super(key: key);

  @override
  _SelecctioFromToMapPageState createState() => _SelecctioFromToMapPageState();
}

class _SelecctioFromToMapPageState extends State<MapSelecctionFromToMapPage> {
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  FocusNode _focus = FocusNode();
  final formKey = GlobalKey<FormState>();
  LocationEntity location = LocationEntity.initalPeruPosition();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  bool inputSelecter= true ;
  LatLng currentLocation;
  String txtFrom;
  String txtTo;
  LatLng from;
  LatLng to;
  LocationEntity whereaboutsFrom;
  LocationEntity whereaboutsTo;
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
    openLoadingDialog(context);
    if(inputSelecter){
      from = pos;
      List<Placemark> placemarkFrom = await Geolocator().placemarkFromCoordinates(from.latitude, from.longitude);
      Placemark placemark = placemarkFrom.first;
      whereaboutsFrom = LocationEntity(
        latLang: from,
        regionName: placemark.administrativeArea,
        provinceName: placemark.subAdministrativeArea ,
        districtName: placemark.locality,
        streetName: placemark.thoroughfare ,
        zoom: 12
      );
      print('..................');
      print('lanlog :'+ placemark.position.toString() );
      print('pais '+ placemark.country );
      print('region: '+ placemark.administrativeArea );
      print('provincia: '+ placemark.subAdministrativeArea );
      print('distrito: '+ placemark.locality );
      print('sub distrito: '+placemark.subLocality );
      print('calle: '+ placemark.thoroughfare );
      print('sub calle: '+placemark.subThoroughfare );
      print('Codigo postal: ' + placemark.postalCode );
      print('..................');
      Navigator.of(context).pop();
      if(placemark.thoroughfare != '' ){
        if( placemark.locality == ''){
          print(placemark.subAdministrativeArea);
          fromController.text = placemark.subAdministrativeArea;
        }else{
          print(placemark.locality);
          fromController.text = placemark.locality;
        }
      }else{
        throw ServerException(message: 'Hellow');
      }
      Marker markerFrom = _mapViewerUtil.generateMarker(
        latLng: from,
        nameMarkerId: 'FROM_POSITION_MARKER',
      );
      _markers[markerFrom.markerId] = markerFrom;
    } else {
      to = pos;
      List<Placemark> placemarkTo = await Geolocator().placemarkFromCoordinates(to.latitude, to.longitude);
      Placemark placemark = placemarkTo.first;
      whereaboutsTo = LocationEntity(
        latLang: to,
        regionName: placemark.administrativeArea,
        provinceName: placemark.subAdministrativeArea ,
        districtName: placemark.locality,
        streetName: placemark.thoroughfare ,
        zoom: 12
      );
      Navigator.of(context).pop();
      if( placemark.locality == ''){
        fromController.text = placemark.subAdministrativeArea;
      }else{
        fromController.text = placemark.locality;
      }
      Marker markerTo = _mapViewerUtil.generateMarker(
        latLng: to,
        nameMarkerId: 'TO_POSITION_MARKER',
      );
      _markers[markerTo.markerId] = markerTo;
    }

    if(_markers.length == 2){
      openLoadingDialog(context);
      Polyline polyline = await _mapViewerUtil.generatePolylineXd('ROUTE_FROM_TO', from, to);
      Navigator.of(context).pop();
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
            MapViewWidget(context),
            BackWidget(context),
            InputMap(
              top: 80,
              labelText: 'Origen',
              focus: _focus,
              controller: fromController,
              inputSelecter: inputSelecter,
            ),
            // Positioned(
            //   top: 80,
            //   right: 15,
            //   left: 15,
            //   child: Container(
            //     height: 50,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(3),
            //       color: Colors.white,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey,
            //           offset: Offset(1, 5),
            //           blurRadius: 10,
            //           spreadRadius: 3)
            //       ],
            //     ),
            //     child: TextField(
            //       autofocus: true,
            //       focusNode: _focus,
            //       cursorColor: Colors.black,
            //       controller: fromController,
            //       // onChanged: (val){
            //       //   txtFrom = val;
            //       // },
            //       // onSubmitted: (value) async{
            //       //   List<Placemark> placemarkOrigin = await Geolocator().placemarkFromAddress(value);
            //       //   LatLng pos = LatLng(placemarkOrigin[0].position.latitude,placemarkOrigin[0].position.longitude);
            //       //   _addFromToMarkers(pos: pos ,inputSelecter:true );
            //       // },
            //       decoration: InputDecoration(
            //         suffixIcon:  inputSelecter ?Icon(Icons.radio_button_checked):null,
            //         labelText:'Origen' ,
            //         border: InputBorder.none,
            //         contentPadding: EdgeInsets.only(left: 15,),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              top: 140,
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
                  onChanged: (val){
                    txtTo = val;
                  },
                  onSubmitted: (value) async {
                    List<Placemark> placemarkOrigin = await Geolocator().placemarkFromAddress(value);
                    LatLng pos = LatLng(placemarkOrigin[0].position.latitude,placemarkOrigin[0].position.longitude);
                    _addFromToMarkers(pos: pos ,inputSelecter: false );
                  },
                  decoration: InputDecoration(
                    suffixIcon: !inputSelecter?Icon(Icons.radio_button_checked):null,
                    labelText:'Destino' ,
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
              child: PrincipalButton(text: 'Guardar',onPressed: () async {
                formKey.currentState.save();
                RouteEntity data = RouteEntity(
                  whereaboutsFrom: whereaboutsFrom,
                  whereaboutsTo: whereaboutsTo
                );
                widget.getFromAndTo(data);
                Navigator.of(context).pop();
              },)
            ),
          ],
        ),
      ),
    );
  }

  Positioned BackWidget(BuildContext context) {
    return Positioned(
            top: 30,
            left: 15,
            child: ClipOval(
              child: Material(
                color: backgroundColor, // button color
                child: InkWell(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(child: Icon(Icons.chevron_left,size: 30,color: Colors.black,))),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          );
  }

  SizedBox MapViewWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _mapViewerUtil.build(
        height: MediaQuery.of(context).size.height,
        currentLocation: LatLng(widget.la, widget.lo),
        markers: _markers,
        polyLines: polylines,
        zoom: 7,
        onTap: (pos){
          if(inputSelecter){
            FocusScope.of(context).requestFocus( FocusNode());
            _addFromToMarkers(  pos:pos,inputSelecter:inputSelecter );
          }else{
            FocusScope.of(context).requestFocus( FocusNode());
            _addFromToMarkers( pos:pos, inputSelecter:inputSelecter );
          }
        }
      )
    );
  }
}