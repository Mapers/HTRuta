import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class MyWalletDriver extends StatefulWidget {
  @override
  _MyWalletDriverState createState() => _MyWalletDriverState();
}

class _MyWalletDriverState extends State<MyWalletDriver> {
  final String screenName = 'MY WALLET';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
//IconData icon, String title, String date, String balance
  List<Map<String, dynamic>> listService = [
    {'id': '0','icon' : Icons.local_taxi, 'title' : 'Recarga Taxi','date' : '22-05-2020','balance' : 'S/.+10'},
    {'id': '1','icon' : Icons.local_taxi, 'title' : 'Recarga Interprovincial','date' : '19-05-2019','balance' : 'S/.+5'},
    {'id': '2','icon' : Icons.local_taxi, 'title' : 'Recarga Carga ','date' : '19-05-2019','balance' : 'S/. +15'},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SideMenu(
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
          bottom: TabBar(
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            tabs: [
              Tab(text: 'Taxi'),
              Tab(text: 'Interprovincial'),
              Tab(text: 'Carga'),
            ]
          ),
        ),
        drawer:MenuDriverScreens(activeScreenName: screenName),
        body: TabBarView(
          children: [
            Scrollbar(
          child: ListView(
            children: <Widget>[
              /* Container(
                alignment: Alignment.center,
                child: BankCard(
                  card: BankCardModel('assets/image/credit_card_empty.png','Debit Card', 'JOHN',
                      '4221 5168 7464 2283', '08/20', 10000000),
                ),
              ), */
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50.0,bottom: 30.0),
                child: Column(
                  children: <Widget>[
                    Text('Balance',style: textStyle,),
                    Text('S/. 150.00',style: heading35Primary,),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                child: MaterialButton(
                  onPressed: (){

                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Text('Recargar', style: TextStyle(color: Colors.white)),
                )
              ),

              /* GestureDetector(
                onTap: (){
                  // Navigator.of(context).pushNamed('/payment_method_driver');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0,right: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x88999999),
                          offset: Offset(0, 5),
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Icon(FontAwesomeIcons.wallet,color: blackColor,),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Agrega nueva tarjeta',style: textBoldBlack,)
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward_ios,color: blackColor,),
                      ),
                    ],
                  ),
                ),
              ), */
              Container(
                margin: EdgeInsets.only(top: 30.0,bottom: 10.0,left: 20.0),
                child: Text('Historial de recargas',style: textStyle,),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listService.length,
                itemBuilder: (BuildContext context, index){
                  return Container(
                    margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10.0),
                    child: historyCard(listService[index]['icon'],listService[index]['title'],listService[index]['date'],listService[index]['balance'])
                  );
                }
              ),
            ],
          ),
        ),
        Scrollbar(
          child: ListView(
            children: <Widget>[
              /* Container(
                alignment: Alignment.center,
                child: BankCard(
                  card: BankCardModel('assets/image/credit_card_empty.png','Debit Card', 'JOHN',
                      '4221 5168 7464 2283', '08/20', 10000000),
                ),
              ), */
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50.0,bottom: 30.0),
                child: Column(
                  children: <Widget>[
                    Text('Balance',style: textStyle,),
                    Text('S/. 150.00',style: heading35Primary,),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                child: MaterialButton(
                  onPressed: (){

                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Text('Recargar', style: TextStyle(color: Colors.white)),
                )
              ),

              /* GestureDetector(
                onTap: (){
                  // Navigator.of(context).pushNamed('/payment_method_driver');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0,right: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x88999999),
                          offset: Offset(0, 5),
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Icon(FontAwesomeIcons.wallet,color: blackColor,),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Agrega nueva tarjeta',style: textBoldBlack,)
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward_ios,color: blackColor,),
                      ),
                    ],
                  ),
                ),
              ), */
              Container(
                margin: EdgeInsets.only(top: 30.0,bottom: 10.0,left: 20.0),
                child: Text('Historial de recargas',style: TextStyle(fontSize: 18)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listService.length,
                itemBuilder: (BuildContext context, index){
                  return Container(
                    margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10.0),
                    child: historyCard(listService[index]['icon'],listService[index]['title'],listService[index]['date'],listService[index]['balance'])
                  );
                }
              ),
            ],
          ),
        ),
        Scrollbar(
          child: ListView(
            children: <Widget>[
              /* Container(
                alignment: Alignment.center,
                child: BankCard(
                  card: BankCardModel('assets/image/credit_card_empty.png','Debit Card', 'JOHN',
                      '4221 5168 7464 2283', '08/20', 10000000),
                ),
              ), */
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 50.0,bottom: 30.0),
                child: Column(
                  children: <Widget>[
                    Text('Balance',style: textStyle,),
                    Text('S/. 150.00',style: heading35Primary,),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                child: MaterialButton(
                  onPressed: (){

                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Text('Recargar', style: TextStyle(color: Colors.white)),
                )
              ),

              /* GestureDetector(
                onTap: (){
                  // Navigator.of(context).pushNamed('/payment_method_driver');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0,right: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x88999999),
                          offset: Offset(0, 5),
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Icon(FontAwesomeIcons.wallet,color: blackColor,),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Agrega nueva tarjeta',style: textBoldBlack,)
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.arrow_forward_ios,color: blackColor,),
                      ),
                    ],
                  ),
                ),
              ), */
              Container(
                margin: EdgeInsets.only(top: 30.0,bottom: 10.0,left: 20.0),
                child: Text('Historial de recargas',style: textStyle,),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listService.length,
                itemBuilder: (BuildContext context, index){
                  return Container(
                    margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10.0),
                    child: historyCard(listService[index]['icon'],listService[index]['title'],listService[index]['date'],listService[index]['balance'])
                  );
                }
              ),
            ],
          ),
        ),
          ],
        ) 
        
      )
      ),
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
          ]),
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
                    child: Text(date, style: textGrey,)
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(balance, style: textStyleHeading18Black,)
            ),
          ),
        ],
      ),
    );
  }
}
