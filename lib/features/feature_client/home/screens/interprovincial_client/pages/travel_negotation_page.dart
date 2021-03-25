import 'dart:ffi';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class TravelNegotationPage extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  const TravelNegotationPage({Key key, this.availablesRoutesEntity}) : super(key: key);

  @override
  _TravelNegotationPageState createState() => _TravelNegotationPageState();
}

class _TravelNegotationPageState extends State<TravelNegotationPage> {
  final formKey = GlobalKey<FormState>();
  bool expectedSteate = true;
  TextEditingController amountController = TextEditingController();
  String amount;
  @override
  void initState() {
    amountController.text = '344';
    // amountController.text = widget.availablesRoutesEntity.route.cost.toStringAsFixed(2);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
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

            expectedSteate ? PrincipalButton(
              text: 'Negociar',
              onPressed: ()async{
                formKey.currentState.save();
                print(amount);
                final _prefs = PreferenciaUsuario();
                LocationEntity from = await LocationUtil.currentLocation();
                DataAvailablesRoutes param = BlocProvider.of<AvailablesRoutesBloc>(context).state;
                InterprovincialRequestEntity interprovincialRequest = InterprovincialRequestEntity(
                  condition: InterprovincialRequestCondition.offer,
                  documentId: null,
                  fcmToken: _prefs.tokenPush,
                  from: from.streetName + ' ' + from.districtName + ' ' + from.provinceName,
                  to: param.distictTo,
                  //! Corregir con data del usuario
                  fullNames: 'juancarlos peres',
                  price: double.parse(amount),
                  //! Corregir con data del usuario
                  seats: 3
                );
                interprovincialClientDataFirebase.addRequestTest(documentId: widget.availablesRoutesEntity.documentId ,request: interprovincialRequest,fcmTokenDriver: widget.availablesRoutesEntity.fcm_token );
                expectedSteate = false;
                
                //! codigo para calificar servicio
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return AlertDialog(
                //       title: Text('Califica el servicio'),
                //       content: Container(
                //         height: 100,
                //         child: Column(
                //           children: [
                //             Row(
                //               children: [
                //                 Icon(Icons.padding ),
                //                 Text('Gran terminal XD')
                //               ],
                //             ),
                //             Text('Huacho Carlos'),
                //             RatingBar.builder(
                //               initialRating: 0,
                //               allowHalfRating: true,
                //               // itemSize: 18,
                //               itemCount: 5,
                //               itemBuilder: (context, _) => Icon(
                //                 Icons.star,
                //                 color: Colors.amber,
                //               ),
                //               onRatingUpdate:(val){
                //                 print(val);
                //               },
                //             ),
                //           ],
                //         ),
                //       ),
                //       actions: [
                //         PrincipalButton(
                //           color: Colors.red,
                //           width: 100,
                //           text: 'omitir',
                //           onPressed: (){}
                //         ),
                //         PrincipalButton(
                //           width: 100,
                //           text: 'Eviar',
                //           onPressed: (){}
                //         )
                //       ],
                //     );
                //   },
                // );
                //! 
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Column(
                        children: [
                          Text('Gracias por su calificacion!',style: TextStyle(fontSize: 30),),
                          PrincipalButton(
                            width: 200,
                            text: 'Aceptar',
                            onPressed: (){}
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ):Text('Esperado contraoferta')
          ],
        ),
      ),

    );
  }
}