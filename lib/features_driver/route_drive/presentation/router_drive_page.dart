
import 'package:HTRuta/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:HTRuta/features_driver/route_drive/presentation/addit_router_drive_page.dart';
import 'package:flutter/material.dart';

class RouterDrivePage extends StatefulWidget {
  RouterDrivePage({Key key}) : super(key: key);

  @override
  _RouterDrivePageState createState() => _RouterDrivePageState();
}

class _RouterDrivePageState extends State<RouterDrivePage> {
  final String screenName = "Rutas";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rutas"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AdditRouterDrivePage()));
            },
            icon: Icon(Icons.add_location_alt_sharp),
          )
        ],
      ),
      drawer: MenuDriverScreens(activeScreenName: screenName),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (BuildContext context,int index){
          return ListTile(
            leading: Icon(Icons.list),
            trailing: Text("GFG", style: TextStyle(color: Colors.green,fontSize: 15),),
            title:Text("List item $index")
            );
        }
      )
      ,
    );
  }
}