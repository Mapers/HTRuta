import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/animation_list_view.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final String screenName = 'HISTORY';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  void navigateToDetail(String id) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryDetail(id: id,)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
        appBar: AppBar(
          title: Text('Historia de viajes',style: TextStyle(fontSize: 16.0)),
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
              final _state = _sideMenuKey.currentState;
              if (_state.isOpened)
                _state.closeSideMenu(); // close side menu
              else
                _state.openSideMenu();// open side menu
            },
          ),
        ),
        drawer: MenuScreens(activeScreenName: screenName),
        // body: NestedScrollView(
        //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        //     return <Widget>[
        //       SliverAppBar(
        //         expandedHeight: 80.0,
        //         floating: false,
        //         pinned: true,
        //         flexibleSpace: FlexibleSpaceBar(
        //           centerTitle: true,
        //           title: Text('Historial',
        //             style: TextStyle(
        //               color: Colors.black,
        //               fontSize: 16.0,
        //             )
        //           ),
        //           background: Container(
        //             color: whiteColor,
        //           ),
        //         ),
        //       ),
        //     ];
        //   },
          body: TabBarView(
            children:[
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
                                print('$index');
                                navigateToDetail(index.toString());
                              },
                              child: rideHistory()
                          )
                      );
                    }
                ),
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
                                print('$index');
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
        ),
      )
    );
  }

  Widget rideHistory(){
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
                Text('Cancelado'.toUpperCase(),
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
                          Text('10:24',
                            style: TextStyle(
                              color: Color(0xFF97ADB6),
                              fontSize: 13.0
                            ),
                          ),
                          Text('10:50',
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
                        Text('Av. Los incas 567, Trujillo , Perú',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text('Av. Pumacahua 678, El Porvenir, Perú',
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

}
