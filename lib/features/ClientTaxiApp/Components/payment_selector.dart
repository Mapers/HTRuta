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
  List<bool> savedPaymentMethods;
  PaymentMethodClient selectedPaymentMethod;
  final _prefs = UserPreferences();
  double widthDropdown;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {
    try{
      paymentMethods = Provider.of<UserProvider>(context, listen: false).userPaymentMethods;
      if(paymentMethods == null){
        final data = await pickUpApi.getPaymentMethods();
        paymentMethods = getListaPaymentMethods(data);
        Provider.of<UserProvider>(context, listen: false).userPaymentMethods = paymentMethods;
        List<int> selectedPaymentMethods = [];
        for(int i = 0; i < paymentMethods.length; i++){
          selectedPaymentMethods.add(
            int.parse(paymentMethods[i].iId)
          );
        }
        List<String> methodsToSave = selectedPaymentMethods.map((e) => e.toString()).toList();
        _prefs.setClientPaymentMethods = methodsToSave;
        if(mounted){
          setState(() {});
        }
      }else{
        savedPaymentMethods = List.generate(paymentMethods.length, (index) => false);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    widthDropdown = MediaQuery.of(context).size.width * 0.6;
    if(paymentMethods == null || savedPaymentMethods == null){
      return Container();
    }
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
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Método de pago', 
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey
                ),
              ),
            ),
            Container(
              width: widthDropdown,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  buttonColor: Colors.white,
                  highlightColor: Colors.white,
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    autofocus: true,
                    hint: Text('Método de pago'),
                    selectedItemBuilder: (BuildContext context) {
                      List<Widget> widgetItems = [];
                      for(int i = 0; i < data.length; i++){
                        if(savedPaymentMethods[i]){
                          widgetItems.add(
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Image.network(
                                data[i].rRuta,
                                width: 25,
                                height: 25,
                              ),
                            )
                          );
                        }
                      }
                      return data.map<Widget>((PaymentMethodClient item) {
                        return Row(
                          children: widgetItems
                        );
                      }).toList();
                    },
                    value: selectedPaymentMethod.nNombre,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                      );
                    }).toList(),
                  )
                )
              ),
            )
          ],
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