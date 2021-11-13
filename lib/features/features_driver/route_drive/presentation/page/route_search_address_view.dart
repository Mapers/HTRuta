import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/driver_place_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/page/route_search_address_map.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:HTRuta/core/utils/location_util.dart';

class RouteSearchAddressView extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final DriverTaxiPlaceBloc placeBloc;
  final Position currentPosition;
  final bool from;
  RouteSearchAddressView({this.placeBloc, this.getTo, this.currentPosition, this.from});

  @override
  _RouteSearchAddressViewState createState() => _RouteSearchAddressViewState();
}

class _RouteSearchAddressViewState extends State<RouteSearchAddressView> {
  bool inputFrom = false;
  bool inputTo = true;
  
  FocusNode nodeFrom = FocusNode();
  FocusNode nodeTo = FocusNode();

  String fromLocation;
  String toLocation;

  LocationEntity from, to;
  
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  Timer _timer;

  bool lookingDirections = false;

  @override
  void initState() {
    super.initState();
    inputFrom = widget.from;
    inputTo = !widget.from;
    fromController.text = widget.placeBloc.fromLocation != null ? widget.placeBloc.fromLocation.streetName : '';
    toController.text = widget.placeBloc.toLocation != null ? widget.placeBloc.toLocation.streetName : '';
  }
  @override
  void dispose() { 
    fromController?.dispose();
    toController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: whiteColor,
          child: Column(
            children: <Widget>[
              buildForm(widget?.placeBloc),
              Container(
                height: 20,
                color: Color(0xfff5f5f5),
              ),
              ListTile(
                leading: Icon(Icons.place, color: Theme.of(context).primaryColor),
                title: Text('Seleccionar punto en el mapa', style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () async {
                  if(inputFrom){
                    final bool seleccionOk = await Navigator.push(context, MaterialPageRoute(builder: (context) => RouteSearchAddressMap(
                      placeBloc: widget.placeBloc,
                      fromLocation: true,
                      initialPosition: widget?.placeBloc?.fromLocation,
                      myCurrentPosition: widget.currentPosition,
                    )));
                    if(seleccionOk != null && seleccionOk){
                      fromController.text = widget?.placeBloc?.fromLocation?.streetName;
                      if(toController.text.isEmpty){
                        nodeTo.requestFocus();
                        setState(() {
                          inputFrom = false;
                          inputTo = true;
                        });
                      }
                    }
                  }else if (inputTo){
                    final bool seleccionOk = await Navigator.push(context, MaterialPageRoute(builder: (context) => RouteSearchAddressMap(
                      placeBloc: widget.placeBloc,
                      fromLocation: false,
                      initialPosition: widget?.placeBloc?.toLocation,
                      myCurrentPosition: widget.currentPosition,
                    )));
                    if(seleccionOk != null && seleccionOk){
                      toController.text = widget?.placeBloc?.toLocation?.streetName;
                      if(fromController.text.isEmpty){
                        nodeFrom.requestFocus();
                        setState(() {
                          inputFrom = true;
                          inputTo = false;
                        });
                      }
                    }
                  }else{
                    Dialogs.alert(context,title: 'Error', message: 'Presione primero en uno de los campos de dirección');
                  }
                }
              ),
              lookingDirections ? Center(child: Column(
                children: const [
                  Text('Buscando direcciones'),
                  CircularProgressIndicator()
                ],
              )) :
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget?.placeBloc?.listPlace?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(widget?.placeBloc?.listPlace[index].name),
                      subtitle: Text(widget?.placeBloc?.listPlace[index].formattedAddress),
                      onTap: () async {
                        if(inputFrom){
                          try{
                            Place fromPlace = widget?.placeBloc?.listPlace[index];
                            List<Placemark> placemarks = await placemarkFromCoordinates(fromPlace.lat, fromPlace.lng);
                            if (placemarks == null || placemarks.isEmpty) return;
                            Placemark newPosition = placemarks[0];
                            
                            from = LocationEntity(
                              streetName: newPosition.thoroughfare,
                              districtName: newPosition.locality,
                              provinceName: newPosition.subAdministrativeArea,
                              regionName: newPosition.administrativeArea,
                              latLang: LatLng(fromPlace.lat,fromPlace.lng),
                            );
                            widget?.placeBloc?.selectFromLocation(
                              from
                            );
                            toController.text = LocationUtil.getFullAddressName(from);
                            widget.placeBloc.clearPlacesList();
                            if(toController.text.isEmpty){
                              nodeTo.requestFocus();
                              inputFrom = false;
                            }
                          }catch(_){}
                          return;
                        }
                        if(inputTo){
                         try{
                            Place toPalce = widget?.placeBloc?.listPlace[index];
                            List<Placemark> placemarks = await placemarkFromCoordinates(toPalce.lat, toPalce.lng);
                            if (placemarks == null || placemarks.isEmpty) return;
                            Placemark newPosition = placemarks[0];
                            to = LocationEntity(
                              streetName: newPosition.thoroughfare,
                              districtName: newPosition.locality,
                              provinceName: newPosition.subAdministrativeArea,
                              regionName: newPosition.administrativeArea,
                              latLang: LatLng(toPalce.lat,toPalce.lng)
                            );
                            widget?.placeBloc?.selectToLocation(
                              to
                            );
                            toController.text = LocationUtil.getFullAddressName(to);
                            widget.placeBloc.clearPlacesList();
                            if(fromController.text.isEmpty){
                              nodeFrom.requestFocus();
                              inputFrom = true;
                            }
                          }catch(_){}
                          return;
                        }
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: greyColor.withOpacity(0.5),
                  ),
                ),
              )
            ],
          ),
        ),
        !lookingDirections ? Positioned(
          bottom: 20,
          child: Container(
            margin: EdgeInsets.all(mqWidth(context, 5)),
            width: mqWidth(context, 90),
            height: 50,
            child: MaterialButton(
              onPressed: () async {
                if(widget.placeBloc.fromLocation != null && widget.placeBloc.toLocation != null ){
                  Navigator.pop(context, true);
                }
              },
              color: (widget.placeBloc.fromLocation != null && widget.placeBloc.toLocation != null ) ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ) : Container()
      ],
    );
  }

  Widget buildForm(DriverTaxiPlaceBloc placeBloc){

    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      color: whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Icon(Icons.my_location),
                Container(
                  height: 30,
                  width: 1.0,
                  color: Colors.grey,
                ),
                Icon(Icons.location_on, color: redColor,)
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextFormField(
                      style: textStyle,
                      autofocus: widget.from,
                      controller: fromController,
                      focusNode: nodeFrom,
                      decoration: InputDecoration(
                        hintText: 'Dirección de partida',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14
                        ),
                      ),
                      onChanged: (String value) async {
                        _timer?.cancel();
                        if(!lookingDirections){
                          setState(() {
                            lookingDirections = true;
                          });
                        }
                        _timer = Timer(const Duration(milliseconds: 1000), (){
                          placeBloc.search(value, currentPosition: widget.currentPosition);
                          setState(() {
                            lookingDirections = false;
                          });
                        });
                      },
                      onEditingComplete: (){
                        nodeFrom.unfocus();
                        setState(() {
                          inputFrom = false;
                        });
                      },
                      onSaved: (String value){
                        nodeFrom.unfocus();
                        setState(() {
                          inputFrom = false;
                        });
                      },
                      onTap: (){
                        widget.placeBloc.clearPlacesList();
                        setState(() {
                          inputFrom = true;
                          inputTo = false;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextFormField(
                      style: textStyle,
                      autofocus: !widget.from,
                      focusNode: nodeTo,
                      decoration: InputDecoration(
                        hintText: 'Dirección de llegada',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14
                        ),
                      ),
                      controller: toController,
                      onChanged: (String value) async {
                        _timer?.cancel();
                        if(!lookingDirections){
                          setState(() {
                            lookingDirections = true;
                          });
                        }
                        _timer = Timer(const Duration(milliseconds: 1000), (){
                          placeBloc.search(value, currentPosition: widget.currentPosition);
                          setState(() {
                            lookingDirections = false;
                          });
                        });
                      },
                      onEditingComplete: (){
                        nodeTo.unfocus();
                        setState(() {
                          inputTo = false;
                        });
                      },
                      onSaved: (String value){
                        nodeTo.unfocus();
                        setState(() {
                          inputTo = false;
                        });
                      },
                      onTap: (){
                        widget.placeBloc.clearPlacesList();
                        setState(() {
                          inputFrom = false;
                          inputTo = true;
                        });
                      },
                    ),
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}
