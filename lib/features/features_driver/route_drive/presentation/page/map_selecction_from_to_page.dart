import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/input_map_selecction.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  LocationEntity from;
  LocationEntity to;
  LocationEntity whereaboutsFrom;
  LocationEntity whereaboutsTo;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  BitmapDescriptor currentPinLocationIcon;
  BitmapDescriptor fromPinLocationIcon;
  BitmapDescriptor toPinLocationIcon;
  LatLng coordinatesSelected;

  @override
  void initState() {
    cleanFrom();
    cleanTo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapViewerUtil.changeMapType();
    });
    super.initState();
  }
  void _addFromToMarkers({LatLng pos}) async{
    try {
      if(inputSelecter){
        // ignore: missing_required_param
        from =  LocationEntity( latLang: pos)  ;
        openLoadingDialog(context);
        List<Placemark> placemarkFrom = await placemarkFromCoordinates(from.latLang.latitude , from.latLang.longitude);
        Placemark placemark = placemarkFrom.first;
        Navigator.of(context).pop();
        if(placemark.thoroughfare != '' && placemark.thoroughfare != 'Unnamed Road'){
          if(toController.text.isEmpty){
            inputSelecter = false;
            setState(() {});
          }
          whereaboutsFrom = LocationEntity(
            latLang: from.latLang,
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea ,
            districtName: placemark.locality,
            streetName: placemark.thoroughfare,
          );
            fromController.text = placemark.thoroughfare;
          Marker markerFrom = MapViewerUtil.generateMarker(
            latLng: from.latLang,
            nameMarkerId: 'FROM_POSITION_MARKER',
          );
          _markers[markerFrom.markerId] = markerFrom;
        }else{
          cleanFrom();
          fromController.clear();
          appearMesage();
        }
      } else {
        // ignore: missing_required_param
        to = LocationEntity(latLang:pos);
        openLoadingDialog(context);
        List<Placemark> placemarkTo = await placemarkFromCoordinates(to.latLang.latitude , to.latLang.longitude);
        Placemark placemark = placemarkTo.first;
        Navigator.of(context).pop();
        if(placemark.thoroughfare != '' && placemark.thoroughfare != 'Unnamed Road'){
          if(fromController.text.isEmpty){
            inputSelecter = true;
            setState(() {});
          }
          whereaboutsTo = LocationEntity(
            latLang: to.latLang,
            regionName: placemark.administrativeArea,
            provinceName: placemark.subAdministrativeArea ,
            districtName: placemark.locality,
            streetName: placemark.thoroughfare ,
          );
          toController.text = placemark.thoroughfare;
          Marker markerTo = MapViewerUtil.generateMarker(
            latLng: to.latLang,
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
    } catch (_) { }
  }

  void drawRoute()async{
    if(_markers.length == 2){
      openLoadingDialog(context);
      Polyline polyline = await _mapViewerUtil.generatePolyline('ROUTE_FROM_TO', from, to);
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
  void cleanFrom(){
    whereaboutsFrom = LocationEntity.initialWithLocation(latitude: 0, longitude: 0) ;
  }
  void cleanTo(){
    whereaboutsTo = LocationEntity.initialWithLocation(latitude: 0, longitude: 0) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            mapViewWidget(context),
            backWidget(context),
            InputMapSelecction(
              isRequired: true,
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
              isRequired: true,
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
            saveButtonWidget(context),
            Center(
              child: Transform.translate(
                offset: Offset(0, -25),
                child: Icon( Icons.location_on, size: 50, color: Theme.of(context).primaryColor)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget saveButtonWidget(BuildContext context) {
    return Positioned(
      bottom: 100,
      right: 15,
      left: 15,
      child: PrincipalButton(text: 'Guardar',onPressed: (){
        if(!formKey.currentState.validate()){
          return ;
        }
        formKey.currentState.save();
        InterprovincialRouteEntity data = InterprovincialRouteEntity(
          from: whereaboutsFrom,
          to: whereaboutsTo,
          cost: null,
          name: null
        );
        widget.getFromAndTo(data);
        Navigator.of(context).pop();
      },)
    );
  }

  Widget mapViewWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _mapViewerUtil.build(
        height: MediaQuery.of(context).size.height,
        currentLocation: LatLng(widget.la, widget.lo),
        markers: _markers,
        polyLines: polylines,
        myLocationEnabled: false,
        zoom: 16,
        onCameraMove: ( cameraPosition ) {
          coordinatesSelected = cameraPosition.target;
        },
        onCameraIdle: (){
          if(coordinatesSelected == null){
            return;
          }
          if(inputSelecter){
            _addFromToMarkers(  pos: coordinatesSelected);
          }else{
            _addFromToMarkers( pos: coordinatesSelected);
          }
        },
        /* onTap: (pos){
          if(inputSelecter){
            _addFromToMarkers(  pos:pos,inputSelecter:inputSelecter );
          }else{
            _addFromToMarkers( pos:pos, inputSelecter:inputSelecter );
          }
        } */
      )
    );
  }

  Widget backWidget(BuildContext context) {
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