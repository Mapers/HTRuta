import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/whereabouts_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/whereabouts_bloc.dart';
import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/page/map_selecction_from_to_page.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/page/map_selecction_whereabouts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class FormRouterDrivePage extends StatefulWidget {
  final RoutesEntity roterDrive;
  final bool statAddEdit;
  FormRouterDrivePage({Key key, this.roterDrive, this.statAddEdit}) : super(key: key);

  @override
  _FormRouterDrivePageState createState() => _FormRouterDrivePageState();
}

class _FormRouterDrivePageState extends State<FormRouterDrivePage> {
  final formKey = GlobalKey<FormState>();
  final keyformPhysicalStock = GlobalKey<FormState>();
  String name;
  RoutesEntity roterDrives;
  ScrollController scrollController = ScrollController();
  LatLng latLagFrom;
  LatLng latLagTo;
  TextEditingController nameConroller = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  @override
  void initState() {
    roterDrives =  RoutesEntity(
      nameFrom: '',
      nameTo: '',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<WhereaboutsBloc>(context).add(GetwhereaboutsWhereaboutsEvent());
    });
    if(!widget.statAddEdit){
      nameConroller.text = widget.roterDrive.name;
      // from = widget.roterDrive.nameFrom;
      // to = widget.roterDrive.nameTo;
      latLagFrom = widget.roterDrive.latLagFrom;
      latLagTo = widget.roterDrive.latLagTo;
    }
    super.initState();
  }
  List<WhereaboutsEntity> whereaabouts = [];
  void getFromAndTo(RoutesEntity roterDrive){
    roterDrives = roterDrive;
    print(roterDrives.nameFrom);
    setState(() {});
  }

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
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MapSelecctionFromToMapPage(la: geoposition.latitude ,lo: geoposition.longitude,getFromAndTo: getFromAndTo,)));
                      },
                      text: 'Selecionar ruta',
                      color: Colors.black,
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    SizedBox(height: 5),
                    roterDrives.nameFrom == '' ? Container():CartDataMap(title: 'Origen', subTitle: roterDrives.nameFrom,),
                    roterDrives.nameTo == '' ? Container():CartDataMap(title: 'Destino', subTitle: roterDrives.nameTo,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paraderos', style: heading20Black,),
                        IconButton(
                          icon: Icon(Icons.add_location,size: 30,),
                          onPressed: ()async{
                            final geoposition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapSelecctionWhereaboutsPage(la:geoposition.latitude ,lo: geoposition.longitude,routesFromTo: roterDrives,)));
                          }
                        )
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
                          height: 220,
                          child: ReorderableListView(
                            scrollController: scrollController,
                            children: List.generate(whereaabouts.length, (i) {
                              WhereaboutsEntity whereaabout = whereaabouts[i];
                              return Card(
                                key: UniqueKey(),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(whereaabout.whereabouts.provinceName ),
                                            Text(whereaabout.whereabouts.streetName ),
                                            Text(whereaabout.cost),
                                          ],
                                        ),
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
                              BlocProvider.of<WhereaboutsBloc>(context).add(OnReorderwhereaboutsWhereaboutsEvent(oldIndex: oldIndex,newIndex: newIndex ));
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
                      RoutesEntity roterDrive = RoutesEntity(
                        name: name,
                        nameFrom: roterDrives.nameFrom,
                        nameTo: roterDrives.nameTo,
                        latLagFrom: latLagFrom,
                        latLagTo:  latLagTo
                      );
                      BlocProvider.of<RouteDriveBloc>(context).add(AddDrivesRouteDriveEvent(roterDrive: roterDrive));
                      Navigator.of(context).pop();
                    }else{
                      RoutesEntity newRoterDrive = RoutesEntity(
                        name: name,
                        nameFrom: roterDrives.nameFrom,
                        nameTo: roterDrives.nameTo,
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

