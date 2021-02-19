import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookingDetailWidget extends StatelessWidget {
  @required final VoidCallback bookingSubmit;
  @required final PanelController panelController;
  @required final String distance;
  @required final String duration;
  final VoidCallback onTapOptionMenu;
  final VoidCallback onTapPromoMenu;

  BookingDetailWidget({
    this.bookingSubmit,
    this.panelController,
    this.distance,
    this.duration,
    this.onTapOptionMenu,
    this.onTapPromoMenu
  });

  final pickupApi = PickupApi();

  @override
  Widget build(BuildContext context) {

    final pedidoProvider = Provider.of<PedidoProvider>(context);
    final responsive = Responsive(context);
    return Container(
      height: 270.0,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.my_location),
                      Container(
                        height: 40,
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      Icon(Icons.location_on,color: redColor,)
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              pedidoProvider.request.vchNombreInicial,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15,bottom: 15),
                        child: Divider(color: Colors.grey,)
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              pedidoProvider.request.vchNombreFinal,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.attach_money),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${int.parse(pedidoProvider.request.mPrecio).toStringAsFixed(2)}, efectivo',
                              overflow: TextOverflow.ellipsis,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: responsive.wp(10), right: responsive.wp(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlineButton(
                  borderSide: BorderSide(color: primaryColor, width: 2.0),
                  shape: new RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.circular(10.0),
                  ),
                  onPressed: pedidoProvider.contador==0 ? null :(){
                    pedidoProvider.reducirPrecio();
                  },
                  child: Text('-0.5', style: TextStyle(color:pedidoProvider.contador==0 ? Colors.grey : primaryColor),),
                ),
                Text('S/${pedidoProvider.precio.toStringAsFixed(1)}',style: TextStyle(fontSize: responsive.ip(2.2), fontWeight: FontWeight.w600),),
                OutlineButton(
                  borderSide: BorderSide(color: primaryColor, width: 2.0),
                  shape: new RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.circular(10.0),
                  ),
                  onPressed: (){
                    pedidoProvider.incrementarPrecio();
                  },
                  child: Text('+0.5',style: TextStyle(color: primaryColor),),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width - 50.0,
              height: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0.0,
                color: primaryColor,
                child: Text('Aumentar precio',style: headingWhite,
                ),
                onPressed: pedidoProvider.contador==0 ? null : ()async{
                  try{
                    Dialogs.openLoadingDialog(context);
                    await pickupApi.updatePriceTravelUser(pedidoProvider.idSolicitud, pedidoProvider.precio.toString());
                    Navigator.pop(context);
                  }on ServerException catch(error){
                    Navigator.pop(context);
                    Dialogs.alert(context,title: 'Error', message: '${error.message}');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
