import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/whereabouts_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/selecction_origen_destino.dart';
import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class AdditRouterDrivePage extends StatefulWidget {
  final RoterDriveEntity roterDrive;
  final bool statAddEdit;
  AdditRouterDrivePage({Key key, this.roterDrive, this.statAddEdit}) : super(key: key);

  @override
  _AdditRouterDrivePageState createState() => _AdditRouterDrivePageState();
}

class _AdditRouterDrivePageState extends State<AdditRouterDrivePage> {
  final formKey = GlobalKey<FormState>();
  final keyformPhysicalStock = GlobalKey<FormState>();
  String name;
  RoterDriveEntity roterDrive;
  String from = '';
  LatLng latLagFrom;
  LatLng latLagTo;
  TextEditingController nameConroller = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  String to = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<WhereaboutsBloc>(context).add(GetwhereaboutsWhereaboutsEvent());
    });
    if(!widget.statAddEdit){
      nameConroller.text = widget.roterDrive.name;
      from = widget.roterDrive.nameFrom;
      to = widget.roterDrive.nameTo;
      latLagFrom = widget.roterDrive.latLagFrom;
      latLagTo = widget.roterDrive.latLagTo;
    }
    super.initState();
  }
  List<WhereaaboutsEntity> whereaabouts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Crear ruta'),
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
                      controller: nameConroller,
                      hinText: 'Nombre',
                      icon: FontAwesomeIcons.mapMarkedAlt,
                      onSaved: (val) => name = val,
                    ),
                    SizedBox(height: 10,),
                    PrincipalButton(
                      onPressed: ()async{
                        final geoposition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        roterDrive = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SelecctionOriginDestination(la: geoposition.latitude ,lo: geoposition.longitude,)));
                          from = roterDrive.nameFrom;
                          to = roterDrive.nameTo;
                          setState(() {});
                      },
                      text: 'Selecionar ruta',
                      color: Colors.black,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(height: 5),
                    from == '' ? Container():CartDataMap(title: 'Origen', subTitle: from,),
                    to == '' ? Container():CartDataMap(title: 'Destino', subTitle: to,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paraderos', style: heading20Black,),
                        Icon(Icons.add_location,size: 30,),
                      ],
                    ),
                    Divider(),
                    BlocBuilder<WhereaboutsBloc, WhereaboutsState>(
                      builder: (context, state) {
                        if(state is LoadingWhereaboutsState){
                          return Center(child: CircularProgressIndicator());
                        }
                        DataWhereaboutsState param = state;
                        if(param.whereaabouts.isEmpty){
                          return Center(child: Text('sin data'),);
                        }
                        whereaabouts = param.whereaabouts;
                        return Container(
                          height: 200,
                          child: ReorderableListView(
                            children: List.generate(whereaabouts.length, (i) {
                              WhereaaboutsEntity whereaabout = whereaabouts[i];
                              return Card(
                                key: UniqueKey(),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(whereaabout.province ),
                                          Text(whereaabout.adress ),
                                          Text(whereaabout.cost),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(icon: Icon(Icons.edit), onPressed: (){}),
                                          IconButton(icon: Icon(Icons.delete), onPressed: (){})
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final WhereaaboutsEntity newString = whereaabouts.removeAt(oldIndex);
                                whereaabouts.insert(newIndex, newString);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PrincipalButton(
                  onPressed: (){
                    formKey.currentState.save();
                    if( widget.statAddEdit){
                      RoterDriveEntity roterDrive = RoterDriveEntity(
                        name: name,
                        nameFrom: from,
                        nameTo: to,
                        latLagFrom: latLagFrom,
                        latLagTo:  latLagTo
                      );
                      BlocProvider.of<RouteDriveBloc>(context).add(AddDrivesRouteDriveEvent(roterDrive: roterDrive));
                      Navigator.of(context).pop();
                    }else{
                      RoterDriveEntity newRoterDrive = RoterDriveEntity(
                        name: name,
                        nameFrom: from,
                        nameTo: to,
                        latLagFrom: latLagFrom ,
                        latLagTo:  latLagTo
                      );
                      BlocProvider.of<RouteDriveBloc>(context).add(EditDrivesRouteDriveEvent(roterDrive: widget.roterDrive, newRoterDrive: newRoterDrive));
                      Navigator.of(context).pop();
                    }
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

