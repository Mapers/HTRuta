import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class SelecctionWhereaboutsPage extends StatefulWidget {
  final double la;
  final double lo;
  SelecctionWhereaboutsPage({Key key, this.la, this.lo}) : super(key: key);

  @override
  _SelecctionWhereaboutsPageState createState() => _SelecctionWhereaboutsPageState();
}

class _SelecctionWhereaboutsPageState extends State<SelecctionWhereaboutsPage> {
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
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
          )
        ],
      ),
    );
  }
}