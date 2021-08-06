import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/historical_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'detail.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';

class HistoryDriverScreen extends StatefulWidget {
  @override
  _HistoryDriverScreenState createState() => _HistoryDriverScreenState();
}

class _HistoryDriverScreenState extends State<HistoryDriverScreen> {
  final String screenName = 'HISTORY';
  DateTime selectedDate = DateTime.now();
  List<dynamic> event = [];
  String selectedMonth = '';
  final pickupApi = PickupApi();
  final _prefs = UserPreferences();
  List<HistoryItem> historyItemsLoaded;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void navigateToDetail(String id) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryDetail(id: id,)));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Historial',
            style: TextStyle(color: blackColor),
          ),
          centerTitle: true,
          backgroundColor: whiteColor,
          elevation: 0.0,
          iconTheme: IconThemeData(color: blackColor),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        drawer:MenuDriverScreens(activeScreenName: screenName),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: CalendarCarousel(
                  locale: 'es',
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                    headerTextStyle: TextStyle(
                    color: Colors.black45
                  ),
                    inactiveWeekendTextStyle: TextStyle(
                      color: Colors.black45
                    ),
                  headerMargin: EdgeInsets.all(0.0),
                  thisMonthDayBorderColor: Colors.grey,
                  weekFormat: true,
                  height: 150.0,
                  selectedDateTime: DateTime.now(),
                  selectedDayBorderColor: blue1,
                  selectedDayButtonColor: blue2,
                  todayBorderColor: primaryColor,
                  todayButtonColor: primaryColor,
                  onDayPressed: (DateTime date, List<dynamic> events) {
                    print(date);
                    historyItemsLoaded = null;
                    setState(() => selectedDate = date);
                  },
                  onCalendarChanged: (DateTime date) {
                    setState(() => selectedMonth = DateFormat.yMMM().format(date));
                  },
                ),
              ),
              historyItemsLoaded == null ? FutureBuilder(
                future: pickupApi.getHistoricalRequest(_prefs.idChoferReal, selectedDate.toString().substring(0,10)),
                builder: (context, snapshot) {
                  if(snapshot.hasError) return Center(child: Text('No hay data'));
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return gainResumeEmpty(screenSize);
                    case ConnectionState.none: return gainResumeEmpty(screenSize);
                    case ConnectionState.active: {
                      historyItemsLoaded = snapshot.data;
                      return gainResume(screenSize, snapshot.data);
                    }
                    case ConnectionState.done: {
                      historyItemsLoaded = snapshot.data;
                      return gainResume(screenSize, snapshot.data);
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                }
              ) : gainResume(screenSize, historyItemsLoaded),
              Container(
                color: primaryColor,
                child: TabBar(
                  tabs: [ 
                    Tab(child: Text('TAXI', style: TextStyle(color: Colors.white,fontSize: 11),),),
                    Tab(child: Text('INTERPROVINCIAL', style: TextStyle(color: Colors.white,fontSize: 10),)),
                    Tab(child: Text('CARGA', style: TextStyle(color: Colors.white,fontSize: 11),))
                  ],
                  indicatorColor: Color(0xFF6734BA),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: TabBarView(
                    children: [
                      historyItemsLoaded == null ? FutureBuilder(
                        future: pickupApi.getHistoricalRequest(_prefs.idChoferReal, selectedDate.toString().substring(0,10)),
                        builder: (context, snapshot) {
                          if(snapshot.hasError) return Center(child: Text('No hay data'));
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
                            case ConnectionState.none: return Center(child: CircularProgressIndicator());
                            case ConnectionState.active: {
                              historyItemsLoaded =  snapshot.data;
                              return historyTaxisList(historyItemsLoaded);
                            }
                            case ConnectionState.done: {
                              historyItemsLoaded =  snapshot.data;
                              return historyTaxisList(historyItemsLoaded);
                            }
                          }
                          return Center(child: CircularProgressIndicator());
                        }
                      ) : historyTaxisList(historyItemsLoaded),
                      ListView.builder(
                        shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  navigateToDetail(index.toString());
                                },
                                child: historyItem2()
                            );
                          }
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  navigateToDetail(index.toString());
                                },
                                child: historyItem3()
                            );
                          }
                      ),
                    ]
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
  Widget gainResumeEmpty(Size screenSize){
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: screenSize.width*0.4,
              child: Row(
                children: <Widget>[
                  Icon(Icons.content_paste,size: 30.0,),
                  SizedBox(width: 10,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Viajes',style: heading18,),
                        Text('',style: headingWhite,)
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.0,),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: screenSize.width*0.4,
              child: Row(
                children: <Widget>[
                  Text('S/ ', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 28)),
                  SizedBox(width: 10,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Ganancia',style: heading18,),
                        Text('',style: headingWhite,)
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget gainResume(Size screenSize, List<HistoryItem> historyItems){
    double gain = 0;
    if(historyItems.isNotEmpty){
      for(HistoryItem item in historyItems){
        if(item.precio != null  && item.comision != null){
          gain += double.parse(item.precio)- double.parse(item.comision);
        }
      }
    }
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: screenSize.width*0.4,
              child: Row(
                children: <Widget>[
                  Icon(Icons.content_paste,size: 30.0,),
                  SizedBox(width: 10,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Viajes',style: heading18,),
                        Text(historyItems.length.toString(),style: headingWhite,)
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.0,),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: screenSize.width*0.4,
              child: Row(
                children: <Widget>[
                  Text('S/ ', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 28)),
                  SizedBox(width: 10,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Ganancia',style: heading18,),
                        Text(gain.toStringAsFixed(1),style: headingWhite,)
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget historyTaxisList(List<HistoryItem> historyItems){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: historyItems.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              navigateToDetail(historyItems[index].iIdViaje);
            },
            child: historyItem(historyItems[index])
        );
      }
    );
  }

  Widget historyItem(HistoryItem item) {
    return Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                          fit: BoxFit.cover,
                          width: 40.0,
                          height: 40.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text(item.,style: textBoldBlack,),
                          Text(DateTimeExtension.changeDateFormat(item.fechaRegistro.toString().substring(0, 10)), style: textGrey,),
                          // Text('08 Ene 2019 12:00 PM', style: textGrey,),
                          /* Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: primaryColor
                                  ),
                                  child: Text('ApplePay',style: textBoldWhite,),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: primaryColor
                                  ),
                                  child: Text('Descuento',style: textBoldWhite,),
                                ),
                              ],
                            ),
                          ), */
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          // Text(item.mPrecio,style: textBoldBlack,),
                          // Text('S/.250.0',style: textBoldBlack,),
                          Text('${(double.parse(item.distanciaMeters)/1000).toStringAsFixed(1)} km',style: textGrey,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Recoger'.toUpperCase(),style: textGreyBold,),
                          Text(item.origen,style: textStyle,),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Llegada'.toUpperCase(),style: textGreyBold,),
                          Text(item.destino,style: textStyle,),

                        ],
                      ),
                    ),

                  ],
                )
              ),
            ],
          ),
        ),
      );
  }

  Widget historyItem2() {
    return Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                          fit: BoxFit.cover,
                          width: 40.0,
                          height: 40.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Mario Ramos',style: textBoldBlack,),
                          Text('08 Ene 2019 12:00 PM', style: textGrey,),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: primaryColor
                                  ),
                                  child: Text('Débito',style: textBoldWhite,),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: primaryColor
                                  ),
                                  child: Text('Descuento',style: textBoldWhite,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('S/.250.0',style: textBoldBlack,),
                          Text('152.2 Km',style: textGrey,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Recoger'.toUpperCase(),style: textGreyBold,),
                          Text('Av. America 456',style: textStyle,),

                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Llegada'.toUpperCase(),style: textGreyBold,),
                          Text('Chiclayo, Lambayeque',style: textStyle,),

                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      );
  }
  
  Widget historyItem3() {
    return Card(
        margin: EdgeInsets.all(10.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          imageUrl: 'https://source.unsplash.com/1600x900/?portrait',
                          fit: BoxFit.cover,
                          width: 40.0,
                          height: 40.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Olivia Ramos',style: textBoldBlack,),
                          Text('08 Ene 2019 12:00 PM', style: textGrey,),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: primaryColor
                                  ),
                                  child: Text('ApplePay',style: textBoldWhite,),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  height: 25.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: primaryColor
                                  ),
                                  child: Text('Descuento',style: textBoldWhite,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('S/.250.0',style: textBoldBlack,),
                          Text('2.2 Km',style: textGrey,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Recoger'.toUpperCase(),style: textGreyBold,),
                                Text('Av. Peru 657',style: textStyle,),

                              ],
                            ),
                          ),
                          Divider(),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Llegada'.toUpperCase(),style: textGreyBold,),
                                Text('Av. Tupac Amaru 567',style: textStyle,),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 30,),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Observaciones'.toUpperCase(),style: textGreyBold,),
                          Text('6 mesas chicas, 20 sillas y un frio y tres vitrinas chiquitas',style: textStyle)
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      );
  }
  
}
