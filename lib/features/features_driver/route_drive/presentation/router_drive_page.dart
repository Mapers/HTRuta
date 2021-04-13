import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features/features_driver/route_drive/domain/entities/router_drive_entity.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/page/form_router_drive_page.dart';
import 'package:HTRuta/features/features_driver/route_drive/presentation/bloc/route_drive_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          if (param.routerDrives.isEmpty) {
            return Center(
              child: Text('- Sin datos -'),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
            itemCount: param.routerDrives.length,
            itemBuilder: (BuildContext context, int i) {
              RouteEntity routeDrive = param.routerDrives[i];
              return Card(
                elevation: 5,
                child: InkWell(
                  onTap:  () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FormRouterDrivePage(routeDrive: routeDrive, statAddEdit: false, )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(routeDrive.name, style: TextStyle(fontWeight: FontWeight.bold),),
                            Icon(Icons.delete)
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.trip_origin, color: Colors.black,),
                            SizedBox(width: 10,),
                            Container(
                              width: 275,
                              child: Text(routeDrive.from.provinceName +' - ' + routeDrive.from.districtName+ ' - ' + routeDrive.from.streetName ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Icon(Icons.assistant_photo, color: Colors.black,),
                            SizedBox(width: 10,),
                            Container(
                              width: 275,
                              child: Text(routeDrive.to.provinceName +' - ' + routeDrive.to.districtName+ ' - ' + routeDrive.to.streetName ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.black,),
                            SizedBox(width: 10,),
                            Text('S/. '+routeDrive.cost.toString()),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
