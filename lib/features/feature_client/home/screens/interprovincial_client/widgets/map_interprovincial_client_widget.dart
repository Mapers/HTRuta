import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInterprovincialClientWidget extends StatefulWidget {
  final Function destinationInpit;
  final bool circle;
  final double radiusCircle;
  MapInterprovincialClientWidget({Key key, this.destinationInpit, this.circle = false, this.radiusCircle}) : super(key: key);

  @override
  _MapInterprovincialClientWidgetState createState() => _MapInterprovincialClientWidgetState();
}

class _MapInterprovincialClientWidgetState extends State<MapInterprovincialClientWidget> {
  LocationUtil _locationUtil = LocationUtil();

  BitmapDescriptor currentPinLocationIcon;
  BitmapDescriptor fromPinLocationIcon;
  BitmapDescriptor toPinLocationIcon;
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  Position currentLocation;
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
      _mapViewerUtil.cameraMoveLatLngZoom(location.latLang, zoom: 16);
      _updateMarkerCurrentPosition(location);
      _locationUtil.initListener(listen: (_location) => _updateMarkerCurrentPosition(_location));
      DataInterprovincialClientState _data = BlocProvider.of<InterprovincialClientBloc>(context).state;
      _addFromToMarkers(datan: _data);
    });
  }
  

  void _updateMarkerCurrentPosition(LocationEntity _location) async{
    Marker marker = _mapViewerUtil.generateMarker(
      latLng: _location.latLang,
      nameMarkerId: 'CURRENT_POSITION_MARKER',
      icon: currentPinLocationIcon,
    );
    BlocProvider.of<InterprovincialClientLocationBloc>(context).add(UpdateInterprovincialClientLocationEvent(driverLocation: _location));
    setState(() {
      location =_location;
      _markers[marker.markerId] = marker;
    });
  }

  void _addFromToMarkers({DataInterprovincialClientState datan, LatLng pos}) async{
    if(pos != null){
      List<Placemark> placemarkFrom = await Geolocator().placemarkFromCoordinates(pos.latitude,pos.longitude);
      Placemark placemark = placemarkFrom.first;
      LocationEntity to = LocationEntity(
        latLang: LatLng( placemark.position.latitude,placemark.position.longitude),
        regionName: placemark.administrativeArea,
        provinceName: placemark.subAdministrativeArea ,
        districtName: placemark.locality ,
        streetName: placemark.thoroughfare
      );
      Marker marker = _mapViewerUtil.generateMarker(
        latLng: to.latLang ,
        nameMarkerId: 'DESTINATIPN_POSITION_MARKER',
        icon: currentPinLocationIcon,
      );
      _markers[marker.markerId] = marker;
      setState(() {});
      widget.destinationInpit(to);

    }

  }

  @override
  void dispose() {
    _locationUtil.disposeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterprovincialClientBloc, InterprovincialClientState>(
      listener: (ctx, state) => _addFromToMarkers(datan: state),
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
        polyLines: polylines,
        circle: widget.circle,
        
        radiusCircle: widget.radiusCircle,
        onTap: (val){
          _addFromToMarkers(pos: val);
          // BlocProvider.of<InterprovincialClientBloc>(context).add(DestinationInterprovincialClientEvent(to: val));
        }
      )
    );
  }
}