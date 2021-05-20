import 'package:HTRuta/features/ClientTaxiApp/Model/payment_methods_response.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/driver_payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';

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
  @override
  Widget build(BuildContext context) {
    return paymentMethods == null ? FutureBuilder(
      future: pickUpApi.getPaymentMethods(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasError) return Container();
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return Container();
          case ConnectionState.none: return Container();
          case ConnectionState.active: {
            paymentMethods = getListaPaymentMethods(snapshot.data);
            savedPaymentMethods = List.generate(paymentMethods.length, (index) => false);
            List<String> paymentsLocally = _prefs.getClientPaymentMethods;
            print(paymentsLocally);
            for(int i = 0; i < paymentMethods.length; i++){
              if(paymentsLocally.contains(paymentMethods[i])){
                savedPaymentMethods[i] = true;
              }
            }
            selectedPaymentMethod = paymentMethods.first;
            return buildContent(paymentMethods);
          }
          case ConnectionState.done:{
            paymentMethods = getListaPaymentMethods(snapshot.data);
            savedPaymentMethods = List.generate(paymentMethods.length, (index) => false);
            List<String> paymentsLocally = _prefs.getClientPaymentMethods;
            for(int i = 0; i < paymentMethods.length; i++){
              if(paymentsLocally.contains(paymentMethods[i])){
                savedPaymentMethods[i] = true;
              }
            }
            selectedPaymentMethod = paymentMethods.first;
            return buildContent(paymentMethods);
          }
        }
        return Container();
      }
    ) : buildContent(paymentMethods);
  }

  Widget buildContent(List<PaymentMethodClient> data){
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
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
              return widget.onSelected(selectedPaymentMethods);
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
                            stateSetter(() {
                            });
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