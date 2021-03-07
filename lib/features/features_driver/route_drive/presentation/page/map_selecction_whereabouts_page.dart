import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/input_map_selecction.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/core/utils/dialog.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/whereabouts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapSelecctionWhereaboutsPage extends StatefulWidget {
  final RouteEntity routesFromTo;
  final WhereaboutsEntity whereabout;
  final bool editState;
  final double la;
  final double lo;
  MapSelecctionWhereaboutsPage({Key key, this.la, this.lo, this.routesFromTo, this.whereabout, this.editState = false}) : super(key: key);

  @override
  _MapSelecctionWhereaboutsPageState createState() => _MapSelecctionWhereaboutsPageState();
}

class _MapSelecctionWhereaboutsPageState extends State<MapSelecctionWhereaboutsPage> {
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  final formKey = GlobalKey<FormState>();
  bool selectedInput = true ;
  LocationEntity whereabouts;
  TextEditingController whereaboutsController = TextEditingController();
  TextEditingController costController = TextEditingController();
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  bool messageController = false;
  String cost;

  @override
  void initState() {
    cleanWhereabouts();
    createRuota();
    if(widget.editState){
      Marker markerWhereabouts = _mapViewerUtil.generateMarker(
        latLng: widget.whereabout.whereabouts.latLang,
        nameMarkerId: 'WHEREABOUTS_POSITION_MARKER',
      );
      _markers[markerWhereabouts.markerId] = markerWhereabouts;
      whereaboutsController.text = widget.whereabout.whereabouts.streetName;
      
    }
    super.initState();
  }
  void _addFromToMarkers( { LatLng pos })async{
    openLoadingDialog(context);
    List<Placemark> placemarkFrom = await Geolocator().placemarkFromCoordinates(pos.latitude, pos.longitude);
    Navigator.of(context).pop();
    Placemark placemark = placemarkFrom.first;
    Marker markerWhereabouts = _mapViewerUtil.generateMarker(
        latLng: LatLng(placemark.position.latitude,placemark.position.longitude),
        nameMarkerId: 'WHEREABOUTS_POSITION_MARKER',
    );
    _markers[markerWhereabouts.markerId] = markerWhereabouts;
    if(placemark.thoroughfare != '' && placemark.thoroughfare != 'Unnamed Road'){
      whereabouts = LocationEntity(
        latLang: LatLng(placemark.position.latitude,placemark.position.longitude),
        regionName: placemark.administrativeArea,
        provinceName: placemark.subAdministrativeArea ,
        districtName: placemark.locality,
        streetName: placemark.thoroughfare,
      );
        whereaboutsController.text = placemark.thoroughfare;
        setState(() {});
    }else{
      cleanWhereabouts();
      whereaboutsController.clear();
      appearMesage();
    }
  }
  void cleanWhereabouts(){
    whereabouts = LocationEntity(latLang: null, regionName: '', provinceName: '' , districtName: '', streetName: '' );
  }
  void appearMesage()async{
    messageController = true;
    setState(() {});
    await Future.delayed(Duration(seconds: 4));
    messageController = false;
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
                zoom:12,
                currentLocation: LatLng(widget.la, widget.lo),
                markers: _markers,
                polyLines: polylines,
                onTap: (pos){
                  if (selectedInput) {
                    _addFromToMarkers( pos:pos);
                  }
                }
              )
            ),
            Back(context),
            InputMapSelecction(
              top:80,
              controller: whereaboutsController,
              labelText:'Paradero',
              province: whereabouts.provinceName == '' ? '' : whereabouts.provinceName,
              district: whereabouts.districtName == '' ? '' : whereabouts.districtName,
              suffixIcon: selectedInput ? Icons.radio_button_checked:null,
              onTap: (){
                selectedInput = true;
              },
            ),
            InputMap(
              onSaved: (val) => cost = val,
              top: 155,
              labelText: 'Costo',
              icon: Icons.monetization_on,
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
      child: PrincipalButton(text: widget.editState ? 'Actualizar' :'Guardar' ,onPressed: (){
        formKey.currentState.save();
        if(widget.editState){
          WhereaboutsEntity newWhereabouts = WhereaboutsEntity(
            id: '1',
            cost: cost,
            whereabouts: whereabouts,
          );
          BlocProvider.of<WhereaboutsBloc>(context).add(EditWhereaboutsEvent( whereabouts:widget.whereabout,newWhereabouts: newWhereabouts));
        }else{
          BlocProvider.of<WhereaboutsBloc>(context).add(AddwhereaboutsWhereaboutsEvent(whereabouts: whereabouts,cost: cost));
        }
        Navigator.of(context).pop();
      },)
    );
  }
  Positioned Back(BuildContext context) {
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
  //! cuminados sin  nesesidad de actualizar
  void  createRuota(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Marker markerFrom = _mapViewerUtil.generateMarker(
        latLng: widget.routesFromTo.from.latLang,
        nameMarkerId: 'FROM_POSITION_MARKER',
      );
      Marker markerTo = _mapViewerUtil.generateMarker(
        latLng: widget.routesFromTo.to.latLang,
        nameMarkerId: 'TO_POSITION_MARKER',
      );
      _markers[markerFrom.markerId] = markerFrom;
      _markers[markerTo.markerId] = markerTo;
      Polyline polyline = await _mapViewerUtil.generatePolylineXd('ROUTE_FROM_TO', widget.routesFromTo.from.latLang, widget.routesFromTo.to.latLang);
      polylines[polyline.polylineId] = polyline;
      setState(() {});
    });
  }
}

class InputMap extends StatelessWidget {
  final double top;
  final String labelText;
  final IconData icon;
  final Function onSaved;
  const InputMap({
    Key key,
    this.top,
    this.labelText,
    this.icon, this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
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
        child: TextFormField(
          onSaved: onSaved,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText:labelText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15, top: 5),
          ),
        ),
      ),
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