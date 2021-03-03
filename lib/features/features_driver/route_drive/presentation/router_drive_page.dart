import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/page/form_router_drive_page.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RouterDrivePage extends StatefulWidget {
  RouterDrivePage({Key key}) : super(key: key);

  @override
  _RouterDrivePageState createState() => _RouterDrivePageState();
}

class _RouterDrivePageState extends State<RouterDrivePage> {
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<RouteDriveBloc>(context).add(GetRouterDrivesEvent());
    });
    super.initState();
  }

  final String screenName = 'Rutas';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute( builder: (context) => FormRouterDrivePage(statAddEdit: true,)));
            },
            icon: Icon(
              Icons.add_location_alt_sharp,
              color: Colors.white,
            ),
          )
        ],
      ),
      drawer: MenuDriverScreens(activeScreenName: screenName),
      body: BlocBuilder<RouteDriveBloc, RouteDriveState>(
        builder: (context, state) {
          if (state is LoadingRouteDriveState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          RouteDriveInitial  param = state;
          if (param.roterDrives.isEmpty) {
            return Center(
              child: Text('- Sin datos -'),
            );
          }
          return ListView.builder(
          itemCount: param.roterDrives.length,
          itemBuilder: (BuildContext context, int i) {
            RoutesEntity roterDrive = param.roterDrives[i];
            return ListTile(
                title: Text(roterDrive.name),
                subtitle: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 90,
                            child: Text(roterDrive.nameFrom)
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(FontAwesomeIcons.arrowRight,size: 15, ),
                          ),
                          Container(
                            width: 90,
                            child: Text(roterDrive.nameTo)
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black,),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute( builder: (context) => FormRouterDrivePage(roterDrive: roterDrive,statAddEdit: false,)));
                            }
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.black,),
                            onPressed: (){
                              BlocProvider.of<RouteDriveBloc>(context).add(DeleteDrivesRouteDriveEvent(roterDrive: roterDrive));
                            }
                          )
                        ],
                      ),
                    ],
                  ),
                ),
            );
          });
        },
      ),
    );
  }
}
