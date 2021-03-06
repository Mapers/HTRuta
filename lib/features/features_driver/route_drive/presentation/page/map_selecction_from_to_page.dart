import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/input_map_selecction.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
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
  final formKey = GlobalKey<FormState>();
  LocationEntity location = LocationEntity.initalPeruPosition();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  bool inputSelecter = true ;
  LatLng currentLocation;
  bool messageController = false;
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
    cleanFrom();
    cleanTo();
    super.initState();
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
            InputMapSelecction(
              controller: fromController,
              top: 80,
              onTap: (){
                inputSelecter = true;
                setState(() {});
              },
              labelText: 'Origen',
              suffixIcon: inputSelecter ? Icons.radio_button_checked:null,
              region: whereaboutsFrom.regionName == '' ? '' :whereaboutsFrom.regionName,
              province: whereaboutsFrom.provinceName == '' ? '' :whereaboutsFrom.provinceName,
              district: whereaboutsFrom.districtName == '' ? '' :whereaboutsFrom.districtName,
            ),
            InputMapSelecction(
              controller: toController,
              onTap: (){
                inputSelecter = false;
                setState(() {});
              },
              top: 155,
              labelText: 'Destino',
              suffixIcon: !inputSelecter ? Icons.radio_button_checked:null,
              region: whereaboutsTo.regionName == '' ? '' :whereaboutsTo.regionName,
              province: whereaboutsTo.provinceName == '' ? '' :whereaboutsTo.provinceName,
              district: whereaboutsTo.districtName == '' ? '' :whereaboutsTo.districtName,
            ),
            messageController? PositionedDarkCardWidget(top: 240,text: 'No se encontrol ninguna calle por favor selecione otro punto'):Container(),
            SaveButtonWidget(context),
          ],
        ),
      ),
    );
  }
  Positioned SaveButtonWidget(BuildContext context) {
    return Positioned(
      top: 500,
      right: 15,
      left: 15,
      child: PrincipalButton(text: 'Guardar',onPressed: (){
        formKey.currentState.save();
        RouteEntity data = RouteEntity(
          whereaboutsFrom: whereaboutsFrom,
          whereaboutsTo: whereaboutsTo
        );
        widget.getFromAndTo(data);
        Navigator.of(context).pop();
      },)
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
            _addFromToMarkers(  pos:pos,inputSelecter:inputSelecter );
          }else{
            _addFromToMarkers( pos:pos, inputSelecter:inputSelecter );
          }
        }
      )
    );
  }
  void _addFromToMarkers({LatLng pos, bool inputSelecter}) async{
    try {
      if(inputSelecter){
        from = pos;
        openLoadingDialog(context);
        List<Placemark> placemarkFrom = await Geolocator().placemarkFromCoordinates(from.latitude, from.longitude);
        Placemark placemark = placemarkFrom.first;
        Navigator.of(context).pop();
        if(placemark.thoroughfare != '' && placemark.thoroughfare != 'Unnamed Road'){
          whereaboutsFrom = LocationEntity(
            latLang: from,
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea ,
            districtName: placemark.locality,
            streetName: placemark.thoroughfare,
          );
            fromController.text = placemark.thoroughfare;
          Marker markerFrom = _mapViewerUtil.generateMarker(
            latLng: from,
            nameMarkerId: 'FROM_POSITION_MARKER',
          );
          _markers[markerFrom.markerId] = markerFrom;
        }else{
          cleanFrom();
          fromController.clear();
          appearMesage();
        }
      } else {
        to = pos;
        openLoadingDialog(context);
        List<Placemark> placemarkTo = await Geolocator().placemarkFromCoordinates(to.latitude, to.longitude);
        Placemark placemark = placemarkTo.first;
        Navigator.of(context).pop();
        if(placemark.thoroughfare != '' && placemark.thoroughfare != 'Unnamed Road'){
          whereaboutsTo = LocationEntity(
            latLang: to,
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea ,
            districtName: placemark.locality,
            streetName: placemark.thoroughfare ,
          );
          toController.text = placemark.thoroughfare;
          Marker markerTo = _mapViewerUtil.generateMarker(
            latLng: to,
            nameMarkerId: 'TO_POSITION_MARKER',
          );
          _markers[markerTo.markerId] = markerTo;
        }else{
          cleanTo();
          toController.clear();
          appearMesage();
        }
      }
      drawRoute();
    } catch (e) {
      print(e.toString());
    }
  }
  //! metodos estaticos
  void drawRoute()async{
    if(_markers.length == 2){
      openLoadingDialog(context);
      Polyline polyline = await _mapViewerUtil.generatePolylineXd('ROUTE_FROM_TO', from, to);
      Navigator.of(context).pop();
      polylines[polyline.polylineId] = polyline;
    }
    setState(() {});
  }

  void appearMesage()async{
    messageController = true;
    setState(() {});
    await Future.delayed(Duration(seconds: 4));
    messageController = false;
    setState(() {});
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
  void cleanFrom(){
    whereaboutsFrom = LocationEntity(latLang: to, regionName: '', provinceName: '' , districtName: '', streetName: '' );
  }
  void cleanTo(){
    whereaboutsTo = LocationEntity( latLang: to, regionName: '', provinceName: '' , districtName: '', streetName: '' );
  }
  //! cierre
}

class PositionedDarkCardWidget extends StatelessWidget {
  final double top;
  final double bottom;
  final String text;
  const PositionedDarkCardWidget({Key key, this.top, this.bottom, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      left: 15,
      top: top,
      bottom: bottom,
      child: Card(
        color: Colors.black,
        elevation: 20,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: double.infinity ,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
        )
      )
    );
  }
}