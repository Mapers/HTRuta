import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyWallet/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/my_wallet_response.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/izi_pay_webview.dart';

class MyWalletDriver extends StatefulWidget {
  @override
  _MyWalletDriverState createState() => _MyWalletDriverState();
}

class _MyWalletDriverState extends State<MyWalletDriver> {
  final String screenName = 'MY WALLET';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
//IconData icon, String title, String date, String balance
  List<Map<String, dynamic>> listService = [
    {'id': '0','icon' : Icons.local_taxi, 'title' : 'Recarga Taxi','date' : '22-05-2020','balance' : '+2 viajes'},
    {'id': '1','icon' : Icons.local_taxi, 'title' : 'Recarga Interprovincial','date' : '19-05-2019','balance' : '+5 viajes'},
    {'id': '2','icon' : Icons.local_taxi, 'title' : 'Recarga Carga ','date' : '19-05-2019','balance' : '+2 viajes'},
  ];
  final pickupApi = PickupApi();
  final prefs = UserPreferences();
  PageController pageController = PageController();
  String ammount;
  WalletData loadedData;
  String amountValue = '5';
  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuDriverScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
      appBar: AppBar(
        title: Text('Billetera',style: TextStyle(color: blackColor),),
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: blackColor),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            final _state = _sideMenuKey.currentState;
            if (_state.isOpened)
              _state.closeSideMenu(); // close side menu
            else
              _state.openSideMenu();// open side menu
          },
        ),
      ),
      drawer: MenuDriverScreens(activeScreenName: screenName),
      body: loadedData == null ? FutureBuilder(
        future: pickupApi.getDriverPaymentsHistory(prefs.idChoferReal),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasError) return Container();
            switch(snapshot.connectionState){
              case ConnectionState.waiting: return Container();
              case ConnectionState.none: return Container();
              case ConnectionState.active: {
                loadedData = snapshot.data;
                return tabBarView(loadedData);
              }
              case ConnectionState.done: {
                loadedData = snapshot.data;
                return tabBarView(loadedData);
              }
            }
            return Container();
          }
        ): tabBarView(loadedData)
      )
    );
  }
  Widget tabBarView(WalletData data){
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scrollbar(
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50.0,bottom: 30.0),
                child: Column(
                  children: <Widget>[
                    Text('Saldo disponible',style: textStyle),
                    Container(height: 20),
                    Text('S/ ${data.saldo}',style: heading35Primary,),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                child: MaterialButton(
                  onPressed: (){
                    pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Text('Recargar', style: TextStyle(color: Colors.white)),
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0,bottom: 10.0,left: 20.0),
                child: Text('Historial de recargas',style: textStyle,),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: data.historial.length,
                reverse: false,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10.0),
                    child: historyCard(Icons.local_taxi, 'Recarga', data.historial[index].date.substring(0, 10), data.historial[index].mMontoRecarga.toString())
                  );
                }
              ),
            ],
          ),
        ),
        PaymentView(
          pageController: pageController,
          amountSelected: amountValue,
          onAmountChange: (String newAmount){
            amountValue = newAmount;
            setState(() {});
          }
        ),
        Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 36,
                      ),
                      onPressed: (){
                        pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                      },
                    )
                  ],
                ),
                IzipayWebView(
                  pageController: pageController,
                  onPaymentComplete: (bool success){
                    loadedData = null;
                    setState(() {});
                  },
                  ammount: amountValue + '00',
                )
              ]
            )
          )
        ),
      ],
    );
  }
  Widget historyCard(IconData icon, String title, String date, String balance) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color(0x88999999),
            offset: Offset(0, 5),
            blurRadius: 5.0,
          ),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Icon(icon, color: whiteColor, size: 30.0,),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(title, style: textBoldBlack,)
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(date, style: textGrey)
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text('S/ $balance', style: textStyleHeading18Black,)
            ),
          ),
        ],
      ),
    );
  }
}

