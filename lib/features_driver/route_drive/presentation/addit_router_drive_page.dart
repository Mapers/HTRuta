

import 'package:HTRuta/ClientTaxiApp/theme/style.dart';
import 'package:HTRuta/features_driver/route_drive/presentation/selecction_origen_destino.dart';
import 'package:HTRuta/features_driver/route_drive/presentation/widgets/principal_button.dart';
import 'package:HTRuta/features_driver/route_drive/presentation/widgets/input.dart';
import 'package:flutter/material.dart';
class AdditRouterDrivePage extends StatefulWidget {
  AdditRouterDrivePage({Key key}) : super(key: key);

  @override
  _AdditRouterDrivePageState createState() => _AdditRouterDrivePageState();
}

class _AdditRouterDrivePageState extends State<AdditRouterDrivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Crear ruta"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            child: Column(
              children: [
                Input(hinText: "Nombre",),
                SizedBox(height: 10,),
                PrincipalButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SelecctionOriginDestination()));
                  },
                  text: "Selecionar ruta",
                  color: Colors.black,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                SizedBox(height: 5),
                CartDataMap(title: "Orogen", subTitle: "lima",),
                CartDataMap(title: "Destino", subTitle: "Huacho",),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PrincipalButton(
              onPressed: (){},
              text: "Crear ruta",
              color: primaryColor,
            ),
          ),
        ],
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
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.only(top: 7,bottom: 2),
            child: Text(subTitle, style: TextStyle(fontSize: 18),),
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