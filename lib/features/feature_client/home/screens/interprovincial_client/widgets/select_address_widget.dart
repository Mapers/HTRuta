import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/payment_selector.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:flutter/material.dart';

class SelectAddressWidget extends StatefulWidget {
  final Place fromAddress,toAddress;
  final VoidCallback onTap;
  final int distancia;
  final String unidad;
  final Function() onSearch;
  final Function(int) getSeating;

  SelectAddressWidget({
    this.fromAddress,
    this.toAddress,
    this.onTap,
    this.distancia,
    this.unidad,
    this.onSearch,
    this.getSeating
  });

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddressWidget> {
  String selectedAddress;
  String precio = '';
  String comentarios = '';
  List<int> seating = [1,2,3,4,5,6,7,8,9,10];
  int initialSeat;
  FocusNode precioFocus = FocusNode();
  final pickUpApi = PickupApi();
  List<int> paymentMethodsSelected = [];
  @override
  void initState() {
    super.initState();
    initialSeat = 1;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Recoger',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey
                                ),
                              ),
                              Text(
                                widget.fromAddress != null ? widget.fromAddress.name : 'Recoger',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5,bottom: 5),
                        child: Divider(color: Colors.grey,)
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Dejar',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey
                                ),
                              ),
                              Text(
                                widget.toAddress != null ? widget.toAddress.name : 'Dirigirse',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 60),
              child: Divider(color: Colors.grey,)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PaymentSelector(
                  onSelected: (List<int> selectedPaymentMethods){
                    paymentMethodsSelected = selectedPaymentMethods;
                  },
                ),
                Select<int>(
                  value: initialSeat,
                  // placeholderIsSelected: true,
                  showPlaceholder: false,
                  items:seating.map((item) => DropdownMenuItem(
                    child: Center(child: Row(
                      children: [
                        Text(item.toString(),style: TextStyle(fontSize: 15 ,color: Colors.black87),),
                        SizedBox(width: 5,),
                        Icon(Icons.airline_seat_recline_normal ,size: 15,color: Colors.black87,)
                      ],
                    )),
                    value: item
                  )).toList(),
                  onChanged: (val){
                    initialSeat = val;
                    widget.getSeating(initialSeat);
                      setState((){});
                  },
                )
              ],
            ),
            Expanded(
              child: FlatButton(
                onPressed: widget.onSearch ,
                child: Text('Buscar interprovincial', style: TextStyle(color: Colors.white,fontSize: 14),),
                color: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 80),
              )
            )
          ],
        ),
      ),
    );
  }
}