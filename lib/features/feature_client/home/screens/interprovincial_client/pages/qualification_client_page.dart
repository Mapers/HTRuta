import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/data/remote/interprovincial_remote_firestore.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/entities/qualification_entity.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class QualificationClientPage extends StatefulWidget {
  final String documentId;
  final String passengerId;
  final AvailableRouteEntity availablesRoutesEntity;
  QualificationClientPage({Key key, @required this.documentId, @required this.passengerId, @required this.availablesRoutesEntity}) : super(key: key);

  @override
  _QualificationClientPageState createState() => _QualificationClientPageState();
}

class _QualificationClientPageState extends State<QualificationClientPage> {

  final formKey = GlobalKey<FormState>();
  String commenctary;
  double numberStart = 0;
  Session _session = Session();
  InterprovincialDataFirestore interprovincialDataFirestore =  getIt<InterprovincialDataFirestore>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric( horizontal: 20 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('Gracias por su preferencia. Tenga un buen dia!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold ),textAlign: TextAlign.center ,),
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person ),
                      SizedBox(width: 7,),
                      Container(
                        width: 200,
                        child: Text(widget.availablesRoutesEntity.route.driverName)
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text( widget.availablesRoutesEntity.route.name ,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  RatingBar.builder(
                    initialRating: 0,
                    allowHalfRating: true,
                    // itemSize: 18,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate:(val){
                      numberStart = val;
                    },
                  ),
                  PrincipalInput(
                    hinText: 'Comentario',
                    onSaved: (val) => commenctary = val,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround ,
                    children: [
                      PrincipalButton(
                        color: Colors.red,
                        width: 100,
                        text: 'Omitir',
                        onPressed: (){
                          interprovincialDataFirestore.deletePassenger(documentId: widget.documentId, passengerId: widget.passengerId );
                          BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: TypeServiceEnum.interprovincial));
                          Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
                        }
                      ),
                      PrincipalButton(
                        width: 100,
                        text: 'Enviar',
                        onPressed: ()async{
                          final user = await _session.get();
                          formKey.currentState.save();
                          QualificationEntity qualification = QualificationEntity(
                            passengerId: user.id,
                            serviceId: widget.availablesRoutesEntity.id,
                            qualifying_person: TypeEntityEnum.passenger ,
                            comment: commenctary,
                            starts: numberStart,
                          );
                          BlocProvider.of<InterprovincialClientBloc>(context).add(SendQualificationInterprovincialClientEvent(qualificationEntity: qualification ));
                          showDialog(
                            // barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    Center(child: Text('¡ Gracias por su calificación !',style: TextStyle(fontSize: 20,color: Colors.grey ),textAlign: TextAlign.center ,)),
                                    SizedBox(height: 10,),
                                    PrincipalButton(
                                      width: 200,
                                      text: 'Aceptar',
                                      onPressed: ()async{
                                        bool deletePaggenger = await interprovincialDataFirestore.deletePassenger(documentId: widget.documentId, passengerId: widget.passengerId );
                                        if(deletePaggenger){
                                          BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: TypeServiceEnum.interprovincial));
                                          Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
                                        }
                                      }
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}