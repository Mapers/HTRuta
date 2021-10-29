import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/payment_selector.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/stateinput_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAddressWidget extends StatefulWidget {
  final Place fromAddress,toAddress;
  final Function(bool) onTapTo;
  final int distancia;
  final String unidad;
  final Function() onSearch;
  final Function(int) getSeating;

  SelectAddressWidget({
    this.fromAddress,
    this.toAddress,
    this.onTapTo,
    this.distancia,
    this.unidad,
    this.onSearch,
    this.getSeating,
  });

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddressWidget> {
  String selectedAddress, precio = '', comentarios = '';
  List<int> seating = [1,2,3,4,5,6,7,8,9,10];
  int initialSeat;
  FocusNode precioFocus = FocusNode();
  final pickUpApi = PickupApi();
  bool isSelectFrom = true, isSelectTo = false;
  List<int> paymentMethodsSelected = [];
  @override
  void initState() {
    super.initState();
    initialSeat = 1;
  }

  void whatInputWasSelect({bool selectFrom, bool selectTo}){
    isSelectFrom = selectFrom;
    isSelectTo = selectTo;
    if(selectFrom){
      BlocProvider.of<StateinputBloc>(context).add(IsStateinputEvent(isStateSelect: true));
    }else{
      BlocProvider.of<StateinputBloc>(context).add(IsStateinputEvent(isStateSelect: false));
    }
    Navigator.of(context).pop();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: mqHeigth(context, 42),
        padding: EdgeInsets.only(top: 20, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.my_location),
                        Container(
                          height: 50,
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        Icon(Icons.location_on,color: redColor,)
                      ],
                    ),
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
                        onTap: (){
                          widget.onTapTo(true);
                        },
                        onLongPress: () {
                          if(!isSelectFrom){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text('¿Esta seguro que desea cambiar el punto de origen?'),
                                actions: [
                                  FlatButton(
                                    child: Text('Atras', style: TextStyle( color: Colors.grey)),
                                    onPressed: () => Navigator.of(context).pop()
                                  ),
                                  FlatButton(
                                    child: Text('Si'),
                                    onPressed: ()  => whatInputWasSelect(selectFrom: true, selectTo: false)
                                  ),
                                ],
                              )
                            );
                          }
                        },
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Recoger',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                                ),
                              ),
                              Container(height: 5),
                              Text(
                                widget.fromAddress != null ? widget.fromAddress.name : 'Selecionar origen',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5, 
                          bottom: 5,
                          right: 20
                        ),
                        child: Container(
                          height: isSelectFrom ? 2 :0.5,
                          color: isSelectFrom ? Colors.amber : Colors.grey,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.onTapTo(false);
                        },
                        onLongPress: (){
                          if(!isSelectTo){
                            showDialog(
                              context: context,
                              builder: (context) =>AlertDialog(
                                content: Text('¿Esta seguro que desea cambiar el punto de destino?'),
                                actions: [
                                  FlatButton(
                                    child: Text('Atras', style: TextStyle( color: Colors.grey),),
                                    onPressed: () => Navigator.of(context).pop()
                                  ),
                                  FlatButton(
                                    child: Text('Si'),
                                    onPressed: () => whatInputWasSelect(selectFrom: false, selectTo: true)
                                  ),
                                ],
                              )
                            );
                          }
                        },
                        child: Container(
                          width: mqWidth(context, 60),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Destino',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                                ),
                              ),
                              Container(height: 5),
                              Text(
                                widget.toAddress != null ? widget.toAddress.name : 'Selecionar destino ',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5, 
                          bottom: 5,
                          right: 20
                        ),
                        child: Container(
                          height: isSelectTo ? 2 :0.5,
                          color: isSelectTo ? Colors.amber : Colors.grey,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: PaymentSelector(
                      onSelected: (List<int> selectedPaymentMethods){
                        paymentMethodsSelected = selectedPaymentMethods;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Select<int>(
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
                  ),
                )
              ],
            ),
            FlatButton(
              onPressed: widget.onSearch ,
              child: Text('Buscar interprovincial', style: TextStyle(color: Colors.white,fontSize: 14),),
              color: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 80),
            )
          ],
        ),
      ),
    );
  }
}
