import 'dart:async';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Blocs/place_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Directions/direction_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SearchAddress/search_address_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';

class SearchAddressView extends StatefulWidget {
  final Function(LocationEntity) getTo;
  final ClientTaxiPlaceBloc placeBloc;
  final Position currentPosition;
  SearchAddressView({this.placeBloc, this.getTo, this.currentPosition});

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
  String valueFrom,valueTo;
  bool checkAutoFocus = false,inputFrom = false,inputTo = false;
  FocusNode nodeFrom = FocusNode();
  FocusNode nodeTo = FocusNode();
  String formLocation;
  String toLocation;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    formLocation = widget?.placeBloc?.formLocation?.name;
  }

  void navigator(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DirectionScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Column(
        children: <Widget>[
          buildForm(widget?.placeBloc),
          Container(
            height: 20,
            color: Color(0xfff5f5f5),
          ),
          widget?.placeBloc?.listPlace != null ?
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget?.placeBloc?.listPlace?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget?.placeBloc?.listPlace[index].name),
                  subtitle: Text(widget?.placeBloc?.listPlace[index].formattedAddress),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAddressMap(
                      placeBloc: widget.placeBloc, 
                      initialPlace: widget?.placeBloc?.listPlace[index], 
                      getTo: widget.getTo, 
                    )));
                    /* widget?.placeBloc?.selectLocation(widget?.placeBloc?.listPlace[index])?.then((_){
                      toLocation = widget?.placeBloc?.locationSelect?.name;
                      FocusScope.of(context).requestFocus(nodeTo);
                      Navigator.pop(context);
                      // navigator();
                    }); */
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: greyColor.withOpacity(0.5),
              ),
            ),
          ): addressDefault(),
        ],
      ),
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
                  TextField(
                    style: textStyle,
                    focusNode: nodeFrom,
                    decoration: InputDecoration(
                      fillColor: whiteColor,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: greyColor),
                      hintText: 'De',
                    ),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        // ignore: prefer_if_null_operators
                        text: formLocation != null ? formLocation :'',
                        selection: TextSelection.collapsed(
                          offset: formLocation != null ? formLocation?.length : 0),
                      ),
                    ),
                    onChanged: (String value) async {
                      formLocation = value;
                      await placeBloc?.search(value);
                    },
                    onTap: (){
                      setState(() {
                        inputFrom = true;
                        inputTo = false;
                      });
                    },
                  ),
                  Container(
                      child: Divider(color: Colors.grey,)
                  ),
                  TextField(
                    style: textStyle,
                    autofocus: true,
                    focusNode: nodeTo,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'A',
                      hintStyle: TextStyle(
                        color: greyColor,
                        fontSize: 14
                      ),
                      contentPadding: EdgeInsets.only(top: 15.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.place),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAddressMap(
                            placeBloc: widget.placeBloc,
                            initialPlace: Place(
                              lat: widget.currentPosition.latitude,
                              lng: widget.currentPosition.longitude,
                            )
                          )));
                        },
                      )
                    ),
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        // ignore: prefer_if_null_operators
                        text: toLocation != null ? toLocation :'',
                        selection: TextSelection.collapsed(
                          offset: toLocation != null ? toLocation?.length : 0
                        ),
                      ),
                    ),
                    onChanged: (String value) async {
                      toLocation = value;
                      _timer?.cancel();
                      _timer = Timer(Duration(milliseconds: 1000), (){
                        placeBloc?.search(value);
                      });
                    },
                    onTap: (){
                      setState(() {
                        inputTo = true;
                        inputFrom = false;
                      });
                    },
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget addressDefault(){
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
  }
}
