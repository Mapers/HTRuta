

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/button.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/fromToEntity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/selecction_origen_destino.dart';
import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
class AdditRouterDrivePage extends StatefulWidget {
  AdditRouterDrivePage({Key key}) : super(key: key);

  @override
  _AdditRouterDrivePageState createState() => _AdditRouterDrivePageState();
}

class _AdditRouterDrivePageState extends State<AdditRouterDrivePage> {
  final formKey = new GlobalKey<FormState>();
  String name;
  FromToEntity dataFromTo;
  String from ="";
  String to ="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Crear ruta"),
      ),
      body: SingleChildScrollView(
        child: Form(
        key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                child: Column(
                  children: [
                    PrincipalInput(
                      hinText: "Nombre",
                      icon: FontAwesomeIcons.mapMarkedAlt,
                      onSaved: (val) => name = val,
                    ),
                    SizedBox(height: 10,),
                    PrincipalButton(
                      onPressed: ()async{
                        final geoposition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        dataFromTo = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SelecctionOriginDestination(la: geoposition.latitude ,lo: geoposition.longitude,)));
                        from = dataFromTo.provinceFrom;
                        to = dataFromTo.provinceTo;
                        setState(() {});
                      },
                      text: "Selecionar ruta",
                      color: Colors.black,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(height: 5),
                    from == "" ? Container():CartDataMap(title: "Origen", subTitle: from,),
                    to == "" ? Container():CartDataMap(title: "Destino", subTitle: to,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PrincipalButton(
                  onPressed: (){
                    formKey.currentState.save();
                    Navigator.of(context).pop();
                    BlocProvider.of<RouteDriveBloc>(context).add(AddDrivesRouteDriveEvent(dataFromTo: dataFromTo,name: name));
                  },
                  text: "Crear ruta",
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartDataMap extends StatelessWidget {
  final String title;
  final String subTitle;
  const CartDataMap({ Key key, this.title, this.subTitle,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
          Padding(
            padding: const EdgeInsets.only(top: 7,bottom: 2),
            child: Text(subTitle, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
          ),
          Container(
            color: Colors.grey,
            width: double.infinity,
            height: 1,
          )
        ],
      ),
    );
  }
}