import 'package:HTRuta/features/features_driver/home/entities/location_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/routes_interprovincial_card_widget.dart';
import 'package:HTRuta/utils/location_util.dart';
import 'package:HTRuta/utils/map_viewer_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InterprovincialScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  InterprovincialScreen({Key key, @required this.parentScaffoldKey}) : super(key: key);

  @override
  _InterprovincialScreenState createState() => _InterprovincialScreenState();
}

class _InterprovincialScreenState extends State<InterprovincialScreen> {

  MapViewerUtil _mapViewerUtil = MapViewerUtil();
  LatLng currentLocation;
  Map<MarkerId, Marker> markers = {};
  LocationEntity location = LocationEntity.initalPeruPosition();

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      location = await LocationUtil.currentLocation();
      _mapViewerUtil.cameraMoveLatLngZoom(location.latLang);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildMapLayer(),
        RoutesInterprovincialCardWidget()
      ],
    );
  }

  Widget _buildMapLayer(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _mapViewerUtil.build(
        height: MediaQuery.of(context).size.height,
        currentLocation: location?.latLang,
        markers: markers
      )
    );
  }
}