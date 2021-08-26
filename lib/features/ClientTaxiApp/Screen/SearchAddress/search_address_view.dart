import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SearchAddress/search_address_map_taxi.dart';
import 'package:geolocator/geolocator.dart';

class SearchAddressView extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final ClientTaxiPlaceBloc placeBloc;
  final Position currentPosition;
  final bool from;
  SearchAddressView({this.placeBloc, this.getTo, this.currentPosition, this.from});

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
  bool inputFrom = false;
  bool inputTo = true;
  
  FocusNode nodeFrom = FocusNode();
  FocusNode nodeTo = FocusNode();

  String fromLocation;
  String toLocation;
  
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  Timer _timer;

  bool lookingDirections = false;

  /* void navigator(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DirectionScreen())
    );
  } */
  @override
  void initState() {
    super.initState();
    inputFrom = widget.from;
    inputTo = !widget.from;
    fromController.text = widget.placeBloc.formLocation != null ? widget.placeBloc.formLocation.name : '';
    toController.text = widget.placeBloc.locationSelect != null ? widget.placeBloc.locationSelect.name : '';
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
                    final bool seleccionOk = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAddressMapTaxi(
                      placeBloc: widget.placeBloc,
                      fromLocation: true,
                      initialPosition: widget?.placeBloc?.formLocation,
                      myCurrentPosition: widget.currentPosition,
                    )));
                    if(seleccionOk != null && seleccionOk){
                      fromController.text = widget?.placeBloc?.formLocation?.name;
                      if(toController.text.isEmpty){
                        nodeTo.requestFocus();
                        setState(() {
                          inputFrom = false;
                          inputTo = true;
                        });
                      }
                    }
                  }else if (inputTo){
                    final bool seleccionOk = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAddressMapTaxi(
                      placeBloc: widget.placeBloc,
                      fromLocation: false,
                      initialPosition: widget?.placeBloc?.locationSelect,
                      myCurrentPosition: widget.currentPosition,
                    )));
                    if(seleccionOk != null && seleccionOk){
                      toController.text = widget?.placeBloc?.locationSelect?.name;
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
                      onTap: () {
                        if(inputFrom){
                          widget.placeBloc.selectFromLocation(widget?.placeBloc?.listPlace[index]);
                          fromController.text = widget?.placeBloc?.listPlace[index].name;
                          widget.placeBloc.clearPlacesList();
                          if(toController.text.isEmpty){
                            nodeTo.requestFocus();
                            setState(() {
                              inputFrom = false;
                              inputTo = true;
                            });
                          }
                          return;
                        }
                        if(inputTo){
                          widget.placeBloc.selectLocation(widget?.placeBloc?.listPlace[index]);
                          toController.text = widget?.placeBloc?.listPlace[index].name;
                          widget.placeBloc.clearPlacesList();
                          if(fromController.text.isEmpty){
                            nodeFrom.requestFocus();
                            setState(() {
                              inputFrom = true;
                              inputTo = false;
                            });
                          }
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
                if(widget.placeBloc.formLocation != null && widget.placeBloc.locationSelect != null ){
                  Navigator.pop(context, true);
                }
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

  /* Widget addressDefault(){
    return Container(
      color: Color(0xfff5f5f5),
      padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: (){
            },
            child: Material(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.home, color: greyColor,),
                    SizedBox(width: 10),
                    Text('Inicio',
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: (){
            },
            child: Material(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.work, color: greyColor,),
                    SizedBox(width: 10),
                    Text('Empresa',
                      style: TextStyle(
                          color: blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } */
}
