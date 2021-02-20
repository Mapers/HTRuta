import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/radioSelectMapType.dart';
import 'package:HTRuta/features/DriverTaxiApp/data/Model/mapTypeModel.dart';
import 'package:flutter/material.dart';

class ButtonLayerWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parrentScaffoldKey;
  final Function(int id, String fileName) changeMapType;
  const ButtonLayerWidget({Key key, @required this.parrentScaffoldKey, @required this.changeMapType}) : super(key: key);

  @override
  _ButtonLayerWidgetState createState() => _ButtonLayerWidgetState();
}

class _ButtonLayerWidgetState extends State<ButtonLayerWidget> {
  PersistentBottomSheetController persistentBottomSheetController;
  List<MapTypeModel> sampleData = [
    MapTypeModel(1,true, 'assets/style/maptype_nomal.png', 'Nomal', 'assets/style/nomal_mode.json'),
    MapTypeModel(2,false, 'assets/style/maptype_silver.png', 'Silver', 'assets/style/sliver_mode.json'),
    MapTypeModel(3,false, 'assets/style/maptype_dark.png', 'Dark', 'assets/style/dark_mode.json'),
    MapTypeModel(4,false, 'assets/style/maptype_night.png', 'Night', 'assets/style/night_mode.json'),
    MapTypeModel(5,false, 'assets/style/maptype_netro.png', 'Netro', 'assets/style/netro_mode.json'),
    MapTypeModel(6,false, 'assets/style/maptype_aubergine.png', 'Aubergine', 'assets/style/aubergine_mode.json')
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 10,
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(100.0),),
        ),
        child: IconButton(
          icon: Icon(Icons.layers,size: 20.0,color: blackColor),
          onPressed: (){
            persistentBottomSheetController = widget.parrentScaffoldKey.currentState.showBottomSheet((ctx) => _getContaindBottomSheet());
          },
        ),
      )
    );
  }

  Widget _getContaindBottomSheet(){
    return Container(
      height: 300.0,
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Tipo de mapa", style: heading18Black),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.close,color: blackColor,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            Expanded(
              child:
              GridView.builder(
                itemCount: sampleData.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    highlightColor: primaryColor,
                    splashColor: Colors.blueAccent,
                    onTap: () {
                      _closeBottomSheet();
                      sampleData.forEach((element) => element.isSelected = false);
                      sampleData[index].isSelected = true;
                      widget.changeMapType(sampleData[index].id, sampleData[index].fileName);
                    },
                    child: MapTypeItem(sampleData[index]),
                  );
                },
              ),
            )

          ],
        ),
      )
    );
  }

  void _closeBottomSheet() {
    if (persistentBottomSheetController != null) {
      persistentBottomSheetController.close();
      persistentBottomSheetController = null;
    }
  }
}