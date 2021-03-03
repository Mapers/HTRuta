import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class SelecctionWhereaboutsPage extends StatefulWidget {
  final RoutesEntity routesFromTo;
  final double la;
  final double lo;
  SelecctionWhereaboutsPage({Key key, this.la, this.lo, this.routesFromTo}) : super(key: key);

  @override
  _SelecctionWhereaboutsPageState createState() => _SelecctionWhereaboutsPageState();
}

class _SelecctionWhereaboutsPageState extends State<SelecctionWhereaboutsPage> {
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Marker markerFrom = _mapViewerUtil.generateMarker(
          latLng: widget.routesFromTo.latLagFrom,
          nameMarkerId: 'FROM_POSITION_MARKER',
        );
        Marker markerTo = _mapViewerUtil.generateMarker(
          latLng: widget.routesFromTo.latLagTo,
          nameMarkerId: 'TO_POSITION_MARKER',
        );
      _markers[markerTo.markerId] = markerTo;
      _markers[markerFrom.markerId] = markerFrom;
      Polyline polyline = await _mapViewerUtil.generatePolylineXd('ROUTE_FROM_TO', widget.routesFromTo.latLagFrom, widget.routesFromTo.latLagTo);
      polylines[polyline.polylineId] = polyline;
    });

  }
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: _mapViewerUtil.build(
              height: MediaQuery.of(context).size.height,
              currentLocation: LatLng(widget.la, widget.lo),
              markers: _markers,
              polyLines: polylines,
              onTap: (pos){
              }
            )
          ),
          Back(context),
          InputMap( top: 80, labelText: 'Paradero',icon: Icons.location_pin,),
          InputMap( top: 140, labelText: 'Costo',icon: Icons.monetization_on ,),
        ],
      ),
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
}

class InputMap extends StatelessWidget {
  final double top;
  final String labelText;
  final IconData icon;
  const InputMap({
    Key key,
    this.top,
    this.labelText,
    this.icon,
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
        child: TextField(
          cursorColor: Colors.black,
          onChanged: (val){
            // txtTo = val;
          },
          onSubmitted: (value) async {
          },
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