import 'package:HTRuta/core/map_network/map_network.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/Model/get_routes_request_model.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OriginMap extends StatefulWidget {
  final LocationEntity to;
  final LocationEntity from;
  OriginMap({this.from, this.to});

  @override
  _OriginMapState createState() => _OriginMapState();
}

class _OriginMapState extends State<OriginMap> {
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  var apis = MapNetwork();
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    traceRoute();
  }

  void traceRoute() async {
    final String polylineIdVal = 'polyline_id';
    final PolylineId polylineId = PolylineId(polylineIdVal);
    polylines.clear();
    var router;
    LatLng _fromLocation = LatLng(widget?.from?.latLang?.latitude, widget?.from?.latLang?.longitude);
    LatLng _toLocation = LatLng(widget?.to?.latLang?.latitude, widget?.from?.latLang?.longitude);

    await apis.getRoutes(
      getRoutesRequest: GetRoutesRequestModel(
        fromLocation: _fromLocation,
        toLocation: _toLocation,
        mode: 'driving'
      ),
    ).then((data) {
      if (data != null) {
        if(data.result.routes.isNotEmpty){
          router = data?.result?.routes[0]?.overviewPolyline?.points;
        }
      }
    }).catchError((_) {});

    if(router != null){
      polylines[polylineId] = GMapViewHelper.createPolyline(
        polylineIdVal: polylineIdVal,
        router: router,
      );
    }
    final MarkerId markerInicioId = MarkerId('marker${widget?.from?.streetName}');
    final Marker markerInicio = Marker(
      markerId: markerInicioId,
      position: LatLng(widget?.from?.latLang?.latitude, widget?.from?.latLang?.longitude),
      infoWindow: InfoWindow(title: ''),
    );
    final MarkerId markerFinalId = MarkerId('marker${widget?.to?.streetName}');
    final Marker markerFinal = Marker(
      markerId: markerFinalId,
      position: LatLng(widget?.to?.latLang?.latitude, widget?.to?.latLang?.longitude),
      infoWindow: InfoWindow(title: ''),
    );
    _markers[markerInicioId] = markerInicio;
    _markers[markerFinalId] = markerFinal;
    setState(() {});
    _gMapViewHelper.cameraMove(
      fromLocation: _fromLocation,
      toLocation: _toLocation, 
      mapController: _mapController,
      zoom: 90
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        onMapCreated: (mapController){
          _mapController = mapController;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.from.latLang.latitude, widget.from.latLang.longitude),
        ),
        polylines: Set<Polyline>.of(polylines.values),
        markers: Set<Marker>.of(_markers.values),
      )
    );
  }
}