import 'dart:async';

import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/features_driver/home/data/remote/interprovincial_data_driver_firestore.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_in_service_entity.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/entities/passenger_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapInterprovincialDriverWidget extends StatefulWidget {
  MapInterprovincialDriverWidget({Key key}) : super(key: key);

  @override
  _MapInterprovincialDriverWidgetState createState() => _MapInterprovincialDriverWidgetState();
}

class _MapInterprovincialDriverWidgetState extends State<MapInterprovincialDriverWidget> {
  LocationUtil _locationUtil = LocationUtil();

  BitmapDescriptor currentPinLocationIcon;
  BitmapDescriptor fromPinLocationIcon;
  BitmapDescriptor toPinLocationIcon;
  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  LatLng currentLocation;
  LocationEntity location = LocationEntity.initalPeruPosition();
  Map<MarkerId, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  StreamSubscription subscriptionPassengers;

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
      DataInterprovincialDriverState _data = BlocProvider.of<InterprovincialDriverBloc>(context).state;
      _addFromToMarkers(_data);
    });
  }

  void _updateMarkerCurrentPosition(LocationEntity _location) async{
    Marker marker = MapViewerUtil.generateMarker(
      latLng: _location.latLang,
      nameMarkerId: 'CURRENT_POSITION_MARKER',
      icon: currentPinLocationIcon
    );
    if(mounted){
      DataInterprovincialDriverState _data = BlocProvider.of<InterprovincialDriverBloc>(context).state;
      if(_data.status == InterprovincialStatus.inRoute){
        Polyline polyline = await _mapViewerUtil.generatePolyline('ROUTE_FROM_TO', _location, _data.routeService.toLocation);
        polylines[polyline.polylineId] = polyline;
        if(subscriptionPassengers == null){
          InterprovincialDataDriverFirestore interprovincialDataFirestore = getIt<InterprovincialDataDriverFirestore>();
          subscriptionPassengers = interprovincialDataFirestore.getStreamPassengers(documentId: _data.documentId).listen((List<PassengerEntity> passengers){
            for (var passenger in passengers) {
              if(passenger.currentLocation != null){
                Marker markerPassenger = MapViewerUtil.generateMarker(
                  latLng: passenger.currentLocation.latLang,
                  nameMarkerId: 'PASSENGER_MARKER_${passenger.documentId}',
                  icon: fromPinLocationIcon,
                  onTap: () => BlocProvider.of<InterprovincialDriverLocationBloc>(context).add(SetPassengerSelectedInterprovincialDriverLocationEvent(passenger: passenger))
                );
                _markers[markerPassenger.markerId] = markerPassenger;
              }
            }
          });
        }
        // Lanzar listener de pasajeros
      }
      if(mounted){
        BlocProvider.of<InterprovincialDriverLocationBloc>(context).add(UpdateDriverLocationInterprovincialDriverLocationEvent(driverLocation: _location, status: _data.status));
        setState(() {
          location =_location;
          _markers[marker.markerId] = marker;
        });
      }
    }
  }

  void _addFromToMarkers(DataInterprovincialDriverState data) async{
    InterprovincialRouteInServiceEntity route = data.routeService;

    if([InterprovincialStatus.loading, InterprovincialStatus.notEstablished].contains(data.status)){
      return;
    }

    Marker markerFrom = MapViewerUtil.generateMarker(
      latLng: route.fromLocation.latLang,
      nameMarkerId: 'FROM_POSITION_MARKER',
      icon: fromPinLocationIcon,
    );
    Marker markerTo = MapViewerUtil.generateMarker(
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
    subscriptionPassengers?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InterprovincialDriverBloc, InterprovincialDriverState>(
      listener: (ctx, state) => _addFromToMarkers(state),
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