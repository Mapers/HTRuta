import 'package:HTRuta/entities/location_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HTRuta/core/map_network/map_network.dart';
import 'package:HTRuta/google_map_helper.dart';
import 'package:HTRuta/features/ClientTaxiApp/data/Model/get_routes_request_model.dart';

class PointMeetingClient extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final GeoPoint geoPoint;
  final LocationEntity currentLocation;
  final bool withMap;
  const PointMeetingClient({Key key, this.geoPoint, this.icon, this.iconColor, this.currentLocation, this.withMap = false}) : super(key: key);

  @override
  _PointMeetingClientState createState() => _PointMeetingClientState();
}

class _PointMeetingClientState extends State<PointMeetingClient> {
  LocationEntity pointMeeting;
  bool mapVisible = false;
  @override
  void initState() {
    pointMeeting = LocationEntity.initialWithLocation(latitude: widget.geoPoint.latitude , longitude: widget.geoPoint.longitude );
    List<Placemark> placemarks;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        try{
          do {
            placemarks = await placemarkFromCoordinates(widget.geoPoint.latitude, widget.geoPoint.longitude);
          } while (placemarks == null || placemarks.isEmpty);
          Placemark newPosition = placemarks.first ;
          pointMeeting = LocationEntity.fillIn(placemark: newPosition, latLng: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude));
          setState(() {
          });
        }catch(e){
          print(e);
        }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print('Claro que yes');
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(widget.icon, color: widget.iconColor),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationComplement(title: 'Región: ',subTitle: pointMeeting.regionName,),
                    LocationComplement(title: 'Provincia: ',subTitle: pointMeeting.provinceName,),
                    LocationComplement(title: 'Distrito: ',subTitle: pointMeeting.districtName,),
                    LocationComplement(title: 'Calle: ',subTitle: pointMeeting.streetName,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(mapVisible ? 'Ocultar' : 'Ver en mapa', style: TextStyle(color: Theme.of(context).primaryColor)),
                          onPressed: (){
                            mapVisible = !mapVisible;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    mapVisible && widget.withMap ? OriginMap(
                      to: LocationEntity(
                        latLang: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude),
                      ),
                      from: widget.currentLocation,
                    ) : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class LocationComplement extends StatelessWidget {
  final String title;
  final String subTitle;
  const LocationComplement({Key key, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
        Expanded(
          child: Container(
            child: Text(subTitle, style: TextStyle(color: Colors.black87, fontSize: 14))
          ),
        ),
      ],
    );
  }
}

class OriginMap extends StatefulWidget {
  final LocationEntity to;
  final LocationEntity from;
  OriginMap({this.from, this.to});

  @override
  _OriginMapState createState() => _OriginMapState();
}

class _OriginMapState extends State<OriginMap> {
  final MapViewerUtil _mapViewerUtil = MapViewerUtil();
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
        router = data?.result?.routes[0]?.overviewPolyline?.points;
      }
    }).catchError((_) {});


    polylines[polylineId] = GMapViewHelper.createPolyline(
      polylineIdVal: polylineIdVal,
      router: router,
    );
    final MarkerId markerInicioId = MarkerId('marker${widget?.from?.streetName}');
    final Marker markerInicio = Marker(
      markerId: markerInicioId,
      position: LatLng(widget?.from?.latLang?.latitude, widget?.from?.latLang?.longitude),
      infoWindow: InfoWindow(title: ''),
    );
    final MarkerId markerFinalId = MarkerId('marker${widget?.to?.streetName}');
    final Marker markerFinal = Marker(
      markerId: markerFinalId,
      position: LatLng(widget?.to?.latLang?.latitude, widget?.from?.latLang?.longitude),
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