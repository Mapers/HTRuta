import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/app/components/input_button.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/page/route_search_address_screen.dart';
import 'package:provider/provider.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/driver_place_bloc.dart';

class FormRouterDrivePage extends StatefulWidget {
  final InterprovincialRouteEntity routeDrive;
  final bool statAddEdit;
  FormRouterDrivePage({Key key, this.routeDrive, this.statAddEdit}) : super(key: key);

  @override
  _FormRouterDrivePageState createState() => _FormRouterDrivePageState();
}

class _FormRouterDrivePageState extends State<FormRouterDrivePage> {
  final formKey = GlobalKey<FormState>();
  final keyformPhysicalStock = GlobalKey<FormState>();
  String name;
  String cost;
  bool dataArrived = false;
  InterprovincialRouteEntity routerDrives;
  ScrollController scrollController = ScrollController();
  TextEditingController nameConroller = TextEditingController();
  TextEditingController costConroller = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  @override
  void initState() {
    if(!widget.statAddEdit){
      nameConroller.text = widget.routeDrive.name;
      costConroller.text = widget.routeDrive.cost.toStringAsFixed(2);
      getFromAndTo(widget.routeDrive );
    }
    super.initState();
  }
  void getFromAndTo(InterprovincialRouteEntity routerDrive){
    routerDrives = routerDrive;
    dataArrived = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.statAddEdit ? 'Crear ruta': 'Actualizar ruta' ),
      ),
      body: SingleChildScrollView(
        child: Form(
        key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: Column(
                  children: [
                    InputButton(
                      enabled: false,
                      onTap: () async {
                        final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        if(widget.routeDrive != null){
                          var bloc = Provider.of<DriverTaxiPlaceBloc>(context, listen: false);
                          bloc.selectFromLocation(widget.routeDrive.from);
                          bloc.selectToLocation(widget.routeDrive.to);
                        }
                        final bool ready = await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RouteSearchAddressScreen(
                            currentLocation: geoposition,
                            from: true,
                          ),
                          fullscreenDialog: true,
                        ));
                        var bloc = Provider.of<DriverTaxiPlaceBloc>(context, listen: false);
                        if(ready != null && ready){
                          getFromAndTo(InterprovincialRouteEntity(
                            from: bloc.fromLocation,
                            to: bloc.toLocation,
                            cost: null,
                            name: null
                          ));
                        }
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MapSelecctionFromToMapPage(la: geoposition.latitude ,lo: geoposition.longitude,getFromAndTo: getFromAndTo,)));
                      },
                      hinText: 'Seleccionar origen-destino',
                    ),
                    PrincipalInput(
                      controller: nameConroller,
                      hinText: 'Nombre',
                      maxLines: 1,
                      icon: FontAwesomeIcons.mapMarkedAlt,
                      onSaved: (val) => name = val,
                    ),
                    PrincipalInput(
                      keyboardType: TextInputType.number,
                      controller: costConroller,
                      hinText: 'Costo',
                      maxLines: 1,
                      icon: Icons.monetization_on,
                      onSaved: (val) => cost = val,
                    ),
                    SizedBox(height: 5),
                    dataArrived ? Column(
                      children: [
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Text('Origen', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Divider(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Departamento: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(routerDrives.from.regionName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Provincia: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(routerDrives.from.provinceName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Distrito: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(routerDrives.from.districtName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Calle: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(routerDrives.from.streetName),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Text('Destino', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Divider(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Departamento: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(routerDrives.to.regionName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Provincia: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text(routerDrives.to.provinceName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Distrito: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(routerDrives.to.districtName),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Calle: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(routerDrives.to.streetName),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ),
                          ),
                        ),
                      ],
                    ):Container(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PrincipalButton(
                  onPressed: (){
                    formKey.currentState.save();
                    if(costConroller.text == ''){
                      Dialogs.alert(context, title: 'Atención', message: 'Escriba un precio');
                      return;
                    }
                    if(nameConroller.text == ''){
                      Dialogs.alert(context, title: 'Atención', message: 'Escriba un nombre');
                      return;
                    }
                    if(double.tryParse(costConroller.text) == null){
                      Dialogs.alert(context, title: 'Atención', message: 'Escriba un precio válido');
                      return;
                    }
                    if( widget.statAddEdit){
                      InterprovincialRouteEntity routerDrive = InterprovincialRouteEntity(
                        name: name,
                        cost: double.parse(cost) ,
                        from: routerDrives.from,
                        to: routerDrives.to,
                      );
                      BlocProvider.of<RouteDriveBloc>(context).add(AddDrivesRouteDriveEvent(routerDrive: routerDrive));
                      Navigator.of(context).pop();
                    }else{
                      InterprovincialRouteEntity newRouterDrive = InterprovincialRouteEntity(
                        id: widget.routeDrive.id,
                        name: name,
                        cost: double.parse(cost) ,
                        from: routerDrives.from,
                        to: routerDrives.to,
                      );
                      BlocProvider.of<RouteDriveBloc>(context).add(EditDrivesRouteDriveEvent(routerDrive:  newRouterDrive));
                      Navigator.of(context).pop();
                    }
                    var bloc = Provider.of<DriverTaxiPlaceBloc>(context, listen: false);
                    bloc.selectFromLocation(widget.routeDrive.from);
                    bloc.selectToLocation(widget.routeDrive.to);
                  },
                  text: widget.statAddEdit?'Crear ruta':'Actualizar ruta',
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

