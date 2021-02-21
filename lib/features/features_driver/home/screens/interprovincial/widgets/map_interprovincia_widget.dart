import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInterprovincialWidget extends StatefulWidget {
  MapInterprovincialWidget({Key key}) : super(key: key);

  @override
  _MapInterprovincialWidgetState createState() => _MapInterprovincialWidgetState();
}

class _MapInterprovincialWidgetState extends State<MapInterprovincialWidget> {
  LocationUtil _locationUtil = LocationUtil();

  BitmapDescriptor currentPinLocationIcon;
  BitmapDescriptor fromPinLocationIcon;
  BitmapDescriptor toPinLocationIcon;
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  LatLng currentLocation;
  LocationEntity location = LocationEntity.initalPeruPosition();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dynamic result = await Future.wait([
        LocationUtil.currentLocation(),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/ic_pick_48.png'),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/gps_point_24.png'),
        BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/ic_marker_32.png'),
      ]);
      location = result[0];
      currentPinLocationIcon = result[1];
      fromPinLocationIcon = result[2];
      toPinLocationIcon = result[3];
      _mapViewerUtil.cameraMoveLatLngZoom(location.latLang);
      _updateMarkerCurrentPosition(location);
      _locationUtil.initListener(listen: (_location) => _updateMarkerCurrentPosition(_location));
      DataInterprovincialState _data = BlocProvider.of<InterprovincialBloc>(context).state;
      _addFromToMarkers(_data);
    });
  }

  void _updateMarkerCurrentPosition(LocationEntity _location){
    Marker marker = _mapViewerUtil.generateMarker(
      latLng: _location.latLang,
      nameMarkerId: 'CURRENT_POSITION_MARKER',
      icon: currentPinLocationIcon,
    );
    setState(() {
      location =_location;
      _markers[marker.markerId] = marker;
    });
  }

  void _addFromToMarkers(DataInterprovincialState data) async{
    InterprovincialRouteEntity route = data.route;

    if([InterprovincialStatus.loading, InterprovincialStatus.notEstablished].contains(data.status)){
      return;
    }

    Marker markerFrom = _mapViewerUtil.generateMarker(
      latLng: route.fromLocation.latLang,
      nameMarkerId: 'FROM_POSITION_MARKER',
      icon: fromPinLocationIcon,
    );
    Marker markerTo = _mapViewerUtil.generateMarker(
      latLng: route.toLocation.latLang,
      nameMarkerId: 'TO_POSITION_MARKER',
      icon: toPinLocationIcon,
    );

    Polyline polyline = await _mapViewerUtil.generatePolyline('ROUTE_FROM_TO', route.fromLocation, route.toLocation);

    setState(() {
      _markers[markerFrom.markerId] = markerFrom;
      _markers[markerTo.markerId] = markerTo;
      polylines[polyline.polylineId] = polyline;
    });
  }

  @override
  void dispose() { 
    _locationUtil.disposeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterprovincialBloc, InterprovincialState>(
      listener: (ctx, state){
        _addFromToMarkers(state);
      },
      child: _buildMapLayer(),
    );
  }

  Widget _buildMapLayer(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _mapViewerUtil.build(
        height: MediaQuery.of(context).size.height,
        currentLocation: location?.latLang,
        markers: _markers,
        polyLines: polylines
      )
    );
  }
}