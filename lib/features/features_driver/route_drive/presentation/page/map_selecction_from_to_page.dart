import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/input_map.dart';
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
 
  void _addFromToMarkers({LatLng pos, bool inputSelecter}) async{
    openLoadingDialog(context);
    if(inputSelecter){
      //? crear  punto y llenar data en input
      from = pos;
      List<Placemark> placemarkFrom = await Geolocator().placemarkFromCoordinates(from.latitude, from.longitude);
      Placemark placemark = placemarkFrom.first;
      Navigator.of(context).pop();
      if(placemark.thoroughfare != '' ){
        whereaboutsFrom = LocationEntity(
          latLang: from,
          regionName: placemark.administrativeArea,
          provinceName: placemark.subAdministrativeArea ,
          districtName: placemark.locality,
          streetName: placemark.thoroughfare,
          zoom: 12
        );
        if( placemark.locality == ''){
          fromController.text = placemark.thoroughfare;
        }else{
          print(placemark.locality);
          fromController.text = placemark.subAdministrativeArea;
        }
        Marker markerFrom = _mapViewerUtil.generateMarker(
          latLng: from,
          nameMarkerId: 'FROM_POSITION_MARKER',
        );
        print(markerFrom.markerId);
        _markers[markerFrom.markerId] = markerFrom;
      }else{
        //? mensaje de carta negra
        cleanFrom();
        _markers.length;
        fromController.clear();
        messageController = true;
        _markers = {};
        setState(() {});
        await Future.delayed(Duration(seconds: 4));
        messageController = false;
        setState(() {});
      }
    } else {
      to = pos;
      List<Placemark> placemarkTo = await Geolocator().placemarkFromCoordinates(to.latitude, to.longitude);
      Placemark placemark = placemarkTo.first;
      Navigator.of(context).pop();
      whereaboutsTo = LocationEntity(
        latLang: to,
        regionName: placemark.administrativeArea,
        provinceName: placemark.subAdministrativeArea ,
        districtName: placemark.locality,
        streetName: placemark.thoroughfare ,
        zoom: 12
      );
      if(placemark.thoroughfare != '' ){
        if( placemark.locality == ''){
          toController.text = placemark.thoroughfare;
        }else{
          print(placemark.locality);
          toController.text = placemark.thoroughfare;
        }
      }else{
        // throw ServerException(message: 'Hellow');
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
            InputMapXD(
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
            InputMapXD(
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
          try {
            if(inputSelecter){
              _addFromToMarkers(  pos:pos,inputSelecter:inputSelecter );
            }else{
              _addFromToMarkers( pos:pos, inputSelecter:inputSelecter );
            }
          } catch (e) {
            print(e.toString());
          }
        }
      )
    );
  }
  void cleanFrom(){
    whereaboutsFrom = LocationEntity(latLang: to, regionName: '', provinceName: '' , districtName: '', streetName: '' , zoom: 12);
  }
  void cleanTo(){
    whereaboutsFrom = LocationEntity( latLang: to, regionName: '', provinceName: '' , districtName: '', streetName: '' , zoom: 12);
  }
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