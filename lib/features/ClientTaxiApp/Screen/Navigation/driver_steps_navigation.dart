/* import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_mapbox_navigation/library.dart';

class DriverStepsNavigation extends StatefulWidget {
  @override
  _DriverStepsNavigationState createState() => _DriverStepsNavigationState();
}

class _DriverStepsNavigationState extends State<DriverStepsNavigation> {

  MapBoxNavigation _directions;
  MapBoxOptions _options;
  GlobalKey keyMap = GlobalKey(debugLabel: 'mapa');

  MapBoxNavigationViewController _controller;

  String _instruction = "";

  bool _arrived = false;
  bool _isMultipleStop = false;
  double _distanceRemaining;
  double _durationRemaining;
  bool _routeBuilt = false;
  bool _isNavigating = false;


  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initialize(){
    _options = MapBoxOptions(
      initialLatitude: -13,
      initialLongitude: -74,
      zoom: 15.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      units: VoiceUnits.metric,
      simulateRoute: false,
      animateBuildRoute: true,
      longPressDestinationEnabled: true,
      language: 'es'
    );
    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
  }
  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        if(!mounted) return;
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        if(!mounted) return;
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        if(!mounted) return;
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        if(!mounted) return;
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    if(!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        flex: 1,
        child: Container(
          color: Colors.grey,
          child: MapBoxNavigationView(
            key: keyMap,
            options: _options,
            onRouteEvent: _onEmbeddedRouteEvent,
            onCreated: (MapBoxNavigationViewController controller) async {
              _controller = controller;
              controller.initialize();
            }
          ),
        ),
      )
    );
  }
}
 */