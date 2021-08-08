import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/animation_list_view.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/historical_model.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final String screenName = 'HISTORY';
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final _prefs = UserPreferences();
  final pickupApi = PickupApi();
  List<HistoryItem> historyItemsLoaded;

  void navigateToDetail(String id) async {
    bool newComment = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryDetail(id: id,)));
    if(newComment != null && newComment){
      historyItemsLoaded = null;
      setState(() {});
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Historial de viajes',style: TextStyle(fontSize: 16.0)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: TabBar(
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            tabs: [
              Tab(text: 'Servicio taxi',),
              Tab(text: 'Interprovincial',)
            ]
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        drawer: MenuScreens(activeScreenName: screenName),
          body: TabBarView(
            children:[
              NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: createFutureList()
              ),
            ),
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return false;
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.separated(
                    itemCount: 5,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    separatorBuilder:(_,int i){
                      return Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationListView(
                        index: index,
                        child: GestureDetector(
                          onTap: () {
                            navigateToDetail(index.toString());
                          },
                          child: interprovincialHistory()
                        )
                      );
                    }
                ),
              ),
            ),
            ] 
          ),
        )
    );
  }
  Widget createFutureList(){
    return historyItemsLoaded == null ? FutureBuilder(
      future: pickupApi.getHistoricalClient(_prefs.idUsuario),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasError) return Container();
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return Container();
          case ConnectionState.none: return Container();
          case ConnectionState.active: {
            historyItemsLoaded = snapshot.data;
            return rideHistoryList(historyItemsLoaded);
          }
          case ConnectionState.done: {
            historyItemsLoaded = snapshot.data;
            return rideHistoryList(historyItemsLoaded);
          }
        }
        return Container();
      }
    ) : rideHistoryList(historyItemsLoaded);
  }

  Widget rideHistoryList(List<HistoryItem> historyItems){
    return ListView.separated(
      itemCount: historyItems.reversed.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      separatorBuilder:(_,int i){
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        HistoryItem item = historyItems.reversed.toList()[index];
        return AnimationListView(
          index: index,
          child: GestureDetector(
            onTap: () {
              navigateToDetail(item.iIdViaje);
            },
            child: rideHistory(item)
          )
        );
      }
    );
  }

  Widget rideHistory(HistoryItem item){
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: whiteColor,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: whiteColor
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(DateTimeExtension.changeDateFormat(item.fechaRegistro.toString().substring(0, 10)),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(codeToEstado(item.estado),
                  style: TextStyle(
                    color: redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0
                  ),
                )
              ],
            ),

            Divider(),
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(item.fechaRegistro.toString().substring(11, 16),
                            style: TextStyle(
                              color: Color(0xFF97ADB6),
                              fontSize: 13.0
                            ),
                          ),
                          Text(item.fechaRegistro.add(Duration(minutes: 10)).toString().substring(11, 16),
                            style: TextStyle(
                              color: Color(0xFF97ADB6),
                              fontSize: 13.0
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.my_location, color: blackColor,),
                        Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          height: 25,
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        Icon(Icons.location_on, color: blackColor,)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.origen,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(item.destino,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget interprovincialHistory(){
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: whiteColor,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: whiteColor
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('8 Junio 2019, 18:39',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text('Realizado'.toUpperCase(),
                  style: TextStyle(
                    
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0
                  ),
                )
              ],
            ),

            Divider(),
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('18:50',
                            style: TextStyle(
                              color: Color(0xFF97ADB6),
                              fontSize: 13.0
                            ),
                          ),

                          Text('21:36',
                            style: TextStyle(
                              color: Color(0xFF97ADB6),
                              fontSize: 13.0
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.my_location, color: blackColor,),
                        Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          height: 25,
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        Icon(Icons.location_on, color: blackColor,)
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Trujillo,La Libertad, Peru',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text('Chiclayo, Lambayeque, Peru',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  String codeToEstado(String code){
    switch(code){
      case '1':
      return 'Aceptado por el chofer';
      case '2':
      return 'Rechazado por el chofer';
      case '3':
      return 'Aceptado por el cliente';
      case '4':
      return 'Rechazado por el cliente';
      default : 
      return '';
    }
  }
}
