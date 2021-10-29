import 'package:HTRuta/core/utils/helpers.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_location_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/stateinput_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInterprovincialClientWidget extends StatefulWidget {
  final Function getFrom;
  final Function destinationInput;
  final Function pickUpInput;
  final bool drawCircle;
  final double radiusCircle;
  final bool iselect;
  final Function(bool) stateselected;
  MapInterprovincialClientWidget(
      {Key key,
      this.drawCircle = false,
      this.radiusCircle,
      this.getFrom,
      this.destinationInput,
      this.pickUpInput,
      this.iselect,
      this.stateselected})
      : super(key: key);

  @override
  _MapInterprovincialClientWidgetState createState() =>
      _MapInterprovincialClientWidgetState();
}

class _MapInterprovincialClientWidgetState
    extends State<MapInterprovincialClientWidget> with WidgetsBindingObserver {
  LocationUtil _locationUtil = LocationUtil();

  BitmapDescriptor currentPinLocationIcon;
  BitmapDescriptor fromPinLocationIcon;
  BitmapDescriptor toPinLocationIcon;
  BitmapDescriptor circlePinLocationIcon;
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  Position currentLocation;
  LocationEntity location = LocationEntity.initalPeruPosition();
  Map<PolylineId, Polyline> polylines = {};
  bool isSelectFrom = true, isSelectTo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      circlePinLocationIcon = await BitmapDescriptor.fromBytes(await assetToBytes('assets/image/car2.png'));
      dynamic result = await Future.wait([
        LocationUtil.currentLocation(),
        BitmapDescriptor.fromAssetImage( ImageConfiguration(devicePixelRatio: 10),'assets/image/marker/ic_pick_48.png'),
        BitmapDescriptor.fromAssetImage( ImageConfiguration(devicePixelRatio: 10),'assets/image/marker/gps_point_24.png'),
        BitmapDescriptor.fromAssetImage( ImageConfiguration(devicePixelRatio: 10),'assets/image/marker/ic_marker_32.png'),
        // BitmapDescriptor.fromAssetImage( ImageConfiguration(devicePixelRatio: 10),'assets/image/marker/circularadio.png'),
      ]);
      location = result[0];
      currentPinLocationIcon = result[1];
      fromPinLocationIcon = result[2];
      toPinLocationIcon = result[3];
      // _mapViewerUtil.changeToDarkMode;
      _mapViewerUtil.cameraMoveLatLngZoom(location.latLang, zoom: 16);
      // _updateMarkerCurrentPosition(location);
      _locationUtil.initListener(listen: (_location) => _updateMarkerCurrentPosition(_location));
      DataInterprovincialClientState _data =
          BlocProvider.of<InterprovincialClientBloc>(context).state;
      // _addFromToMarkers(datan: _data);
    });
  }

  void _updateMarkerCurrentPosition(LocationEntity _location) async {
    // widget.getFrom(_location);
    Marker marker = MapViewerUtil.generateMarker(
      latLng: _location.latLang,
      nameMarkerId: 'CURRENT_POSITION_MARKER',
      icon: circlePinLocationIcon,
    );
    if(context == null) return;
    BlocProvider.of<InterprovincialClientLocationBloc>(context).add(
        UpdateInterprovincialClientLocationEvent(driverLocation: _location));
    setState(() {
      location = _location;
    });
  }

  void _addFromToMarkers({DataInterprovincialClientState datan,LatLng pos, bool isSelectedFromOrTo = false}) async {
    if (isSelectedFromOrTo) {
      if (pos != null) {
        List<Placemark> placemarkFrom = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        Placemark placemark = placemarkFrom.first;
        LocationEntity from = LocationEntity(
                latLang: LatLng(pos.latitude, pos.longitude),
                regionName: placemark.administrativeArea,
                provinceName: placemark.subAdministrativeArea,
                districtName: placemark.locality,
                streetName: placemark.thoroughfare)
            .formatNames;

        Marker markerFrom = MapViewerUtil.generateMarker(
          latLng: from.latLang,
          nameMarkerId: 'FROM_POSITION_MARKER',
          icon: circlePinLocationIcon,
        );
        BlocProvider.of<StateinputBloc>(context).add(AddMarkerStateinputEvent(markers: markerFrom));
        setState(() {});
        widget.pickUpInput(from);
      }
    } else {
      if (pos != null) {
        List<Placemark> placemarkFrom = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        Placemark placemark = placemarkFrom.first;
        LocationEntity to = LocationEntity(
              latLang: LatLng(pos.latitude, pos.longitude),
              regionName: placemark.administrativeArea,
              provinceName: placemark.subAdministrativeArea,
              districtName: placemark.locality,
              streetName: placemark.thoroughfare)
          .formatNames;
        Marker markerTo = MapViewerUtil.generateMarker(
          latLng: to.latLang,
          nameMarkerId: 'TO_POSITION_MARKER',
          icon: currentPinLocationIcon,
        );
        BlocProvider.of<StateinputBloc>(context).add(AddMarkerStateinputEvent(markers: markerTo));
        setState(() {});
        widget.destinationInput(to);
      }
    }
  }

  @override
  void dispose() {
    _locationUtil.disposeListener();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _mapViewerUtil.changeMapType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterprovincialClientBloc, InterprovincialClientState>(
      listener: (ctx, state) => _addFromToMarkers(datan: state,),
      child: _buildMapLayer(),
    );
  }

  Widget _buildMapLayer() {
    return BlocBuilder<StateinputBloc, StateinputState>(
      builder: (context, state) {
        StateinputInitial param = BlocProvider.of<StateinputBloc>(context).state;
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _mapViewerUtil.build(
            height: MediaQuery.of(context).size.height,
            currentLocation: location?.latLang,
            markers: param.markers,
            polyLines: polylines,
            drawCircle: widget.drawCircle,
            radiusCircle: widget.radiusCircle * 1000,
            onTap: (val) {
              _addFromToMarkers( pos: val, isSelectedFromOrTo: param.stateSelect);
              BlocProvider.of<InterprovincialClientBloc>(context).add(DestinationInterprovincialClientEvent(to: val));
            }
          )
        );
      },
    );
  }
}
