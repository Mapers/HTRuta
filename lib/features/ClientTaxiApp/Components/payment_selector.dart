import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/payment_methods_response.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:provider/provider.dart';

class PaymentSelector extends StatefulWidget {

  final Function(List<int>) onSelected;

  PaymentSelector({this.onSelected});

  @override
  _PaymentSelectorState createState() => _PaymentSelectorState();
}

class _PaymentSelectorState extends State<PaymentSelector> {
  final pickUpApi = PickupApi();
  List<PaymentMethodClient> paymentMethods;
  List<bool> savedPaymentMethods = [];
  PaymentMethodClient selectedPaymentMethod;
  final _prefs = UserPreferences();
  double widthDropdown;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }
  Future<void> loadData() async {
    try{
      // paymentMethods = Provider.of<UserProvider>(context, listen: false).userPaymentMethods;
      final data = await pickUpApi.getPaymentMethods();
      paymentMethods = getListaPaymentMethods(data);
      Provider.of<UserProvider>(context, listen: false).userPaymentMethods = paymentMethods;
      if(mounted){
        setState(() {});
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    widthDropdown = MediaQuery.of(context).size.width * 0.6;
    if(paymentMethods == null){
      return Container();
    }
    savedPaymentMethods = List.generate(paymentMethods.length, (index) => false);
    List<String> paymentsLocally = _prefs.getClientPaymentMethods;
    for(int i = 0; i < paymentMethods.length; i++){
      if(paymentsLocally.contains(paymentMethods[i].iId)){
        savedPaymentMethods[i] = true;
      }
    }
    selectedPaymentMethod = paymentMethods.first;
    return buildContent(paymentMethods, savedPaymentMethods);
  }

  Widget buildContent(List<PaymentMethodClient> data, List<bool> savedPaymentMethods){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Método de pago', 
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            buttonColor: Colors.white,
            highlightColor: Colors.white,
            alignedDropdown: true,
            child: Container(
              width: widthDropdown,
              child: DropdownButton<String>(
                autofocus: true,
                isExpanded: true,
                hint: Text('Método de pago'),
                selectedItemBuilder: (BuildContext context) {
                  List<Widget> widgetItems = [];
                  for(int i = 0; i < data.length; i++){
                    if(savedPaymentMethods[i]){
                      widgetItems.add(
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Image.network(
                                data[i].rRuta,
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Container(child: Text(data[i]?.nNombre), margin: EdgeInsets.only(right: 5))
                          ],
                        )
                      );
                    }
                  }
                  return data.map<Widget>((PaymentMethodClient item) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widgetItems,
                      ),
                    );
                  }).toList();
                },
                value: selectedPaymentMethod?.nNombre,
                onChanged: (String newValue) async {
                  selectedPaymentMethod = data.where((element) => element.nNombre == newValue).toList().first;
                  setState(() {});
                  List<PaymentMethodClient> selectedPaymentMethods = [];
                  for(int i = 0; i < data.length; i++){
                    if(savedPaymentMethods[i]){
                      selectedPaymentMethods.add(
                        data[i]//.iId
                      );
                    }
                  }
                  List<String> methodsToSave = selectedPaymentMethods.map((e) => e.iId.toString()).toList();
                  List<int> methodsToSaveInt = selectedPaymentMethods.map((e) => int.parse(e.iId)).toList();
                  Provider.of<UserProvider>(context, listen: false).userPaymentMethods = selectedPaymentMethods;
                  _prefs.setClientPaymentMethods = methodsToSave;
                  return widget.onSelected(methodsToSaveInt);
                },
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black
                ),
                items: data.map((PaymentMethodClient paymentMethod) {
                  int index = data.indexOf(paymentMethod);
                  return DropdownMenuItem<String>(
                    value: paymentMethod.nNombre,
                    child: Container(
                      width: mqWidth(context, 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                paymentMethod.rRuta,
                                width: 25,
                                height: 25,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(paymentMethod.nNombre)
                              ),
                            ],
                          ),
                          StatefulBuilder(
                            builder: (BuildContext context, StateSetter stateSetter) {
                              return Checkbox(
                                value: savedPaymentMethods[index],
                                onChanged: (bool newValue){
                                  savedPaymentMethods[index] = newValue;
                                  List<int> selectedPaymentMethods = [];
                                  for(int i = 0; i < data.length; i++){
                                    if(savedPaymentMethods[i]){
                                      selectedPaymentMethods.add(
                                        int.parse(data[i].iId)
                                      );
                                    }
                                  }
                                  List<String> methodsToSave = selectedPaymentMethods.map((e) => e.toString()).toList();
                                  _prefs.setClientPaymentMethods = methodsToSave;
                                  stateSetter(() {
                                  });
                                  setState(() {});
                                },
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          )
        ),
      ],
    );
  }

  List<PaymentMethodClient> getListaPaymentMethods(PaymentMethodsResponse data){
    List<PaymentMethodClient> lista = [];
    lista.add(data.the0);
    lista.add(data.the1);
    lista.add(data.the2);
    lista.add(data.the3);
    lista.add(data.the4);
    return lista;
  }
}