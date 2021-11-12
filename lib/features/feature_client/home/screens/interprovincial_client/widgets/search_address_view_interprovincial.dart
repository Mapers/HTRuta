import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/search_address_map_inteprovincial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchAddressViewInterprovincial extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final Function(LocationEntity) getFrom;
  final LocationEntity fromSelect;
  final LocationEntity toSelect;
  final ClientTaxiPlaceBloc placeBloc;
  final Position currentPosition;
  final bool from;
  final bool isSelecte;
  SearchAddressViewInterprovincial({this.placeBloc, this.getTo, this.currentPosition, this.from, this.getFrom, this.fromSelect, this.toSelect, this.isSelecte});

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressViewInterprovincial> {
  bool inputFrom = true;
  bool inputTo = false;
  FocusNode nodeFrom = FocusNode();
  FocusNode nodeTo = FocusNode();
  LocationEntity from, to;
  String fromLocation;
  String toLocation;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  Timer _timer;

  bool lookingDirections = false;

  @override
  void initState() {
    if (widget.isSelecte) {
      inputFrom = true;
      inputTo = false;
      nodeFrom.requestFocus();
    }else{
      inputFrom = false;
      inputTo = true;
      nodeTo.requestFocus();
    }
    from = widget.fromSelect;
    to = widget.toSelect;
    if(from.latLang != null){
      fromController.text = from.streetName == '' ? from.districtName +', ' + from.provinceName  :from.streetName + ', '+ from.districtName + ', ' + from.provinceName;
    }
    if(to.latLang != null){
      toController.text = to.streetName == '' ? to.districtName +', ' + to.provinceName  :to.streetName + ', '+ to.districtName + ', ' + to.provinceName;
    }
    super.initState();
  }

  @override
  void dispose() {
    fromController?.dispose();
    toController?.dispose();
    super.dispose();
  }
  void getLocationFromOrTo(LocationEntity newLocation ){
    if(inputFrom){
      fromController.text =  newLocation.streetName == '' ? newLocation.districtName +', ' + newLocation.provinceName  :newLocation.streetName + ', '+ newLocation.districtName + ', ' + newLocation.provinceName;
      from = newLocation;
      if(toController.text.isEmpty){
        nodeTo.requestFocus();
        inputFrom = false;
      }
    }else{
      toController.text = newLocation.streetName == '' ? newLocation.districtName +', ' + newLocation.provinceName  :newLocation.streetName + ', '+ newLocation.districtName + ', ' + newLocation.provinceName;
      to = newLocation;
      if(fromController.text.isEmpty){
        nodeFrom.requestFocus();
        inputFrom = true;
      }
    }
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAddressMapInteprovicnial(
                      placeBloc: widget.placeBloc,
                      fromLocation: inputFrom,
                      initialPosition:  inputFrom ? from.latLang : to.latLang,
                      myCurrentPosition: widget.currentPosition,
                      getLocationFromOrTo: getLocationFromOrTo,
                    )));
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
                            widget.placeBloc.selectFromLocation(widget?.placeBloc?.listPlace[index]);
                            Place fromPalce = widget?.placeBloc?.listPlace[index];
                            List<Placemark> placemarks = await placemarkFromCoordinates(fromPalce.lat, fromPalce.lng);
                            if (placemarks == null || placemarks.isEmpty) return;
                            Placemark newPosition = placemarks[0];
                            from = LocationEntity(
                              streetName: newPosition.thoroughfare,
                              districtName: newPosition.locality,
                              provinceName: newPosition.subAdministrativeArea,
                              regionName: newPosition.administrativeArea,
                              latLang: LatLng(fromPalce.lat,fromPalce.lng)
                            );
                            fromController.text = from.streetName == '' ? from.districtName +', ' + from.provinceName  :from.streetName + ', '+ from.districtName + ', ' + from.provinceName;
                            widget.placeBloc.clearPlacesList();
                            if(toController.text.isEmpty){
                              nodeTo.requestFocus();
                              inputFrom = false;
                            }
                          }catch(_){}
                        }else {
                          try{
                            widget.placeBloc.selectLocation(widget?.placeBloc?.listPlace[index]);
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
                            toController.text = to.streetName == '' ? to.districtName +', ' + to.provinceName + ', ' + to.regionName  :to.streetName + ', '+ to.districtName + ', ' + to.provinceName;
                            widget.placeBloc.clearPlacesList();
                            if(fromController.text.isEmpty){
                              nodeFrom.requestFocus();
                              inputFrom = true;
                            }
                          }catch(_){}
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
          bottom: 10,
          child: Container(
            margin: EdgeInsets.all(mqWidth(context, 5)),
            width: mqWidth(context, 90),
            height: 50,
            child: MaterialButton(
              onPressed: () {
                widget.getFrom(from);
                widget.getTo(to);
                Navigator.of(context).pop();
                // if(widget.placeBloc.formLocation != null && widget.placeBloc.locationSelect != null ){
                //   Navigator.pop(context, true);
                // }
              },
              color: (widget.placeBloc.formLocation != null && widget.placeBloc.locationSelect != null ) ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.6),
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

  Widget buildForm(ClientTaxiPlaceBloc placeBloc){

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
