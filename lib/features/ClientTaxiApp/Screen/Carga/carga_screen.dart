import 'package:HTRuta/app/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/animation_list_view.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Menu/menu_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';


class CargaPage extends StatefulWidget {

  @override
  _CargaPageState createState() => _CargaPageState();
}

class _CargaPageState extends State<CargaPage> {
  final String screenName = 'CARGA';
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SideMenu(
      key: _sideMenuKey,
      background: primaryColor,
      menu: MenuScreens(activeScreenName: screenName),
      type: SideMenuType.slideNRotate, // check above images
      child: Scaffold(
        appBar: AppBar(
          title: Text('Carga'),
          bottom: TabBar(tabs: [
            Tab(child: Text('Solicitar un auto',style: TextStyle(fontSize: 12))),
            Tab(child: Text('Autos que van a donde usted va',style: TextStyle(fontSize: 12),)),
            Tab(child: Text('Mis viajes',style: TextStyle(fontSize: 12),))
          ]),
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
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: TabBarView(
            children: [
              solicitarAutoView(),
              verAutosView(),
              misViajesView(),
            ]
          ),
        )
      )
      ),
    );
  }

  Widget solicitarAutoView() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              dataView(iconData: Icons.arrow_back, placeholder: 'Lugar de recogida',textInput: TextInputType.text),
              dataView(iconData: Icons.arrow_forward, placeholder: 'Destino',textInput: TextInputType.text),
              dataView(iconData: FontAwesomeIcons.coins, placeholder: 'Precio',textInput: TextInputType.number),
              dataView(iconData: Icons.edit, placeholder: 'Fecha, hora, tamaño y tipo de carga (detalles para los conductores de camionetas)',textInput: TextInputType.multiline),
            ],
          ),
          Container(
            width: double.infinity,
            height: 40,
            child: FlatButton(
              onPressed: (){},
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: primaryColor, 
              child: Text('Solicitar un auto', style: TextStyle(color: Colors.white,fontSize: 16))
            ),
          )
        ],
      ),
    );
  }

  Widget verAutosView() {
    return ListView.separated(

      separatorBuilder: (context,index) => Divider(), 
      itemCount: 20,
      itemBuilder: (context,index){
        return ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              'https://source.unsplash.com/300x300/?portrait',
            )
          ),
          title: Text('Royer Paúl'),
          subtitle: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Icon(Icons.calendar_today,size: 9,),
                SizedBox(width: 4,),
                Text('21 ago.,20:24',style: TextStyle(fontSize: 9),)
              ],),
              Text('Camioneta Amplia, con parrilla grande para cualquier movilidad. Camas, colchones, closet, mudanzas'),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.call, color: primaryColor,),
            ],
          ),
        );
      }, 
    );
  }

  Widget misViajesView() {
    return NotificationListener<OverscrollIndicatorNotification>(
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
                  // navigateToDetail(index.toString());
                },
                child: rideHistory()
              )
            );
          }
        ),
      ),
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

  Widget dataView({IconData iconData, String placeholder, TextInputType textInput = TextInputType.text, int maxLine = 1}) {
    return TextFormField(
      keyboardType: textInput,
      maxLines: maxLine,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData,size: 20,),
        labelText: placeholder,
        labelStyle: TextStyle(fontSize: 14),
        hintText: placeholder,
        hintStyle: TextStyle(fontSize: 14)
      ),
    );
  }
}