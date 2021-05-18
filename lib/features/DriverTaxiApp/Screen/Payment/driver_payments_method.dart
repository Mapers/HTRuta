import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/driver_payment_method_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/save_driver_py_body.dart';
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

  List<PaymentMethod> paymentMethodsLoaded;

  final pickupApi = PickupApi();
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
        body: paymentMethodsLoaded == null ? FutureBuilder(
          future: pickupApi.getDriverPaymentMethod('27'),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasError) return Container();
            switch(snapshot.connectionState){
              case ConnectionState.waiting: return Container();
              case ConnectionState.none: return Container();
              case ConnectionState.active: {
                paymentMethodsLoaded = snapshot.data;
                return createFutureContent(snapshot.data);
              }
              case ConnectionState.done: {
                paymentMethodsLoaded = snapshot.data;
                return createFutureContent(snapshot.data);
              }
            }
            return Container();
          }
        ) : createFutureContent(paymentMethodsLoaded)
      ),
    );
  }
  Widget createFutureContent(List<PaymentMethod> paymentMethods){
    if(paymentMethods.isEmpty) return Container();
    List<Widget> elements = [];
    for(PaymentMethod paymentMethod in paymentMethods){
      elements.addAll([
        Container(height: 50),
        ListTile(
          leading: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(paymentMethod.rRuta)
              )
            ),
          ),
          trailing: Checkbox(
            value: paymentMethod.selected == 'true',
            onChanged: (bool newValue){
              paymentMethod.selected = newValue.toString();
              setState(() {});
            },
          ),
          title: Text(paymentMethod.nNombre)
        ),
      ]);
    }
    elements.addAll([
      Divider(height: 50),
      Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.6,
        child: MaterialButton(
          onPressed: () async {
            List<int> paymentMethodsSelected = [];
            for(PaymentMethod paymentMethod in paymentMethodsLoaded){
              if(paymentMethod.selected == 'true'){
                paymentMethodsSelected.add(int.parse(paymentMethod.iId));
              }
            }
            if(paymentMethodsSelected.isEmpty){
              Dialogs.alert(context, title: 'Atención', message: 'Seleccione al menos un método de pago');
              return;
            }
            SaveDriverPmBody body = SaveDriverPmBody(
              choferId: 27,
              arrFormaPagoIds: paymentMethodsSelected
            );
            bool success = await pickupApi.saveDriverPaymentMethods(body);
            if(!success){
              Dialogs.alert(context, title: 'Ha ocurrido un error', message: 'Inténtelo más tarde');
            }else{
              Dialogs.success(context, title: 'Correcto', message: 'Sus métodos han sido guardados');
            }
          },
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
    ]);

    return ListView(
      children: elements,
    );
  }
}