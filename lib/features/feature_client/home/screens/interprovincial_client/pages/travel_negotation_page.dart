import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:flutter/material.dart';
class TravelNegotationPage extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  const TravelNegotationPage({Key key, this.availablesRoutesEntity}) : super(key: key);

  @override
  _TravelNegotationPageState createState() => _TravelNegotationPageState();
}

class _TravelNegotationPageState extends State<TravelNegotationPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  String amount;
  @override
  void initState() {
    amountController.text = widget.availablesRoutesEntity.route.cost.toStringAsFixed(2);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Negociacion del viaje'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 15,),
            Text(widget.availablesRoutesEntity.route.name),
            SizedBox(height: 15,),
            Text( widget.availablesRoutesEntity.route.nameDriver ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: (){
                    amountController.text = (double.parse(amountController.text)  - 1.00 ).toStringAsFixed(2);
                  },
                  icon: Icon(Icons.remove),
                ),
                SizedBox(width: 20,),
                Card(
                  color: backgroundInputColor,
                  child: Container(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        onSaved: (val)=> amount = val,
                        controller: amountController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                IconButton(
                  onPressed: (){
                    amountController.text = (double.parse(amountController.text)  + 1.00 ).toStringAsFixed(2);
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 15,),
            PrincipalButton(
              text: 'Negociar',
              onPressed: (){
                formKey.currentState.save();
                print(amount);
              },
            )
          ],
        ),
      ),
    );
  }
}