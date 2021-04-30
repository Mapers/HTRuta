import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Menu/Menu.dart';
import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';


class DriverPaymentsMethods extends StatefulWidget {
  @override
  _DriverPaymentsMethodsState createState() => _DriverPaymentsMethodsState();
}

class _DriverPaymentsMethodsState extends State<DriverPaymentsMethods> {
  final String screenName = 'PAYMENT';

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  bool efectivo = false;

  bool plin = false;

  bool yape = false;

  bool pos = false;

  bool agora = false;

  bool bitcoin = false;

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      background: primaryColor,
      key: _sideMenuKey,
      type: SideMenuType.slideNRotate,
      menu: MenuDriverScreens(activeScreenName: screenName),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
              final _state = _sideMenuKey.currentState;
              if (_state.isOpened)
                _state.closeSideMenu(); // close side menu
              else
                _state.openSideMenu();// open side menu
            },
          ),
        ),
        body: ListView(
          children: [
            Container(height: 50),
            ListTile(
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/image/money.png')
                  )
                ),
              ),
              trailing: Checkbox(
                value: efectivo,
                onChanged: (bool newValue){
                  efectivo = newValue;
                  setState(() {});
                },
              ),
              title: Text('Efectivo')
            ),
            Divider(height: 50),
            ListTile(
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/image/plin.png')
                  )
                ),
              ),
              trailing: Checkbox(
                value: plin,
                onChanged: (bool newValue){
                  plin = newValue;
                  setState(() {});
                },
              ),
              title: Text('Plin')
            ),
            Divider(height: 50),
            ListTile(
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/image/yape.png')
                  )
                ),
              ),
              trailing: Checkbox(
                value: yape,
                onChanged: (bool newValue){
                  yape = newValue;
                  setState(() {});
                },
              ),
              title: Text('Yape')
            ),
            Divider(height: 50),
            ListTile(
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/image/credit-card.png')
                  )
                ),
              ),
              trailing: Checkbox(
                value: pos,
                onChanged: (bool newValue){
                  pos = newValue;
                  setState(() {});
                },
              ),
              title: Text('POS')
            ),
            Divider(height: 50),
            ListTile(
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/image/bitcoin.png')
                  )
                ),
              ),
              trailing: Checkbox(
                value: bitcoin,
                onChanged: (bool newValue){
                  bitcoin = newValue;
                  setState(() {});
                },
              ),
              title: Text('Bitcoin')
            ),
            Divider(height: 50),
            ListTile(
              leading: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/image/agora.png')
                  )
                ),
              ),
              trailing: Checkbox(
                value: agora,
                onChanged: (bool newValue){
                  agora = newValue;
                  setState(() {});
                },
              ),
              title: Text('Agora')
            ),
            Divider(height: 50),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              child: MaterialButton(
                onPressed: (){},
                elevation: 0.2,
                minWidth: MediaQuery.of(context).size.width * 0.6,
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Text('Guardar', style: TextStyle(color: Colors.white)),
              ),
            ),
            Divider(height: 50),
          ],
        )
      ),
    );
  }
}