import 'package:HTRuta/app/components/input_map_selecction.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/components/qualification_widget.dart';
import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/widgets/loading_positioned.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/local/interprovincial_client_data_local.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/entities/qualification_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/map_interprovincial_client_widget.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/change_service_client_widget.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/positioned_choose_route_widget.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterprovincialClientScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  InterprovincialClientScreen({Key key, @required this.parentScaffoldKey}) : super(key: key);

  @override
  _InterprovincialClientScreenState createState() => _InterprovincialClientScreenState();
}

class _InterprovincialClientScreenState extends State<InterprovincialClientScreen> {
  LocationEntity toLocation;
  LocationEntity fromLocation;
  TextEditingController toController = TextEditingController();
  List<double> circularRadio = [1,2,3,4,5];
  List<int> seating = [1,2,3,4,5,6,7,8,9,10];
  bool drawCircle = false;
  double initialCircularRadio;
  int initialSeat;
  Session _session = Session();
  final _prefs = UserPreferences();

  @override
  void initState() {
    initialCircularRadio = 3;
    initialSeat = 1;
    toLocation = LocationEntity(
      latLang: null,
      districtName: '',
      provinceName: '',
      regionName: '',
      streetName: '',
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      BlocProvider.of<InterprovincialClientBloc>(context).add(LoadInterprovincialClientEvent());
      await _showDialogQualification();
    });
  }
  void destinationInpit(LocationEntity to){
    toController.text = to.streetName;
    toLocation = to;
    setState(() {});
  }
  void changeStateCircle(){
    drawCircle = true;
    setState(() {
    });
  }
  void getfrom(LocationEntity from){
    fromLocation = from;
  }
  void _showDialogQualification() async{
    print('1');
    InterprovincialClientDataLocal interprovincialClientDataLocal = getIt<InterprovincialClientDataLocal>();
    String documentId = interprovincialClientDataLocal.getDocumentIdOnServiceInterprovincialToQualification;
    print('2');
    if(documentId == null){
      return;
    }
    print('3');

    InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
    bool onService = await interprovincialClientDataFirebase.checkIfInterprovincialLocationDriverEntityOnService(documentId: documentId);
    if(!onService){
      //! Considerar traer del backend los datos el driver
      showDialog(
        context: context,
        child: QualificationWidget(
          title: 'Califica el servicio',
          nameUserQuelify: '',
          routeTraveled: '',
          onAccepted: (stars, comments)async{
            //! Enviar calificacion al server
            final user = await _session.get();
            interprovincialClientDataLocal.deleteDocumentIdOnServiceInterprovincialToQualification;
            QualificationEntity qualification = QualificationEntity(
              passenger_id: int.parse(user.id),
              service_id: int.parse(_prefs.service_id),
              qualifying_person: TypeEntityEnum.passenger ,
              comment: comments,
              starts: stars,
            );
            BlocProvider.of<InterprovincialClientBloc>(context).add(SendQualificationInterprovincialClientEvent(qualificationEntity: qualification ));
            _prefs.service_id = '';
          },
          onSkip: (){
            interprovincialClientDataLocal.deleteDocumentIdOnServiceInterprovincialToQualification;
          },
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        MapInterprovincialClientWidget(
          destinationInpit: destinationInpit,
          drawCircle: drawCircle,
          radiusCircle: initialCircularRadio,
          getFrom: getfrom,
        ),
        ChangeServiceClientWidget(),
        BlocBuilder<InterprovincialClientBloc, InterprovincialClientState>(
          builder: (context, state) {
            print(state);
            if(state is DataInterprovincialClientState){
              print(state.status);
              if(state.status == InteprovincialClientStatus.loading){
                return LoadingPositioned(label: state.loadingMessage);
              }else if(state.status == InteprovincialClientStatus.notEstablished){
                return PositionedChooseRouteWidget(changeStateCircle: changeStateCircle,);
              }else if(state.status == InteprovincialClientStatus.searchInterprovincial){
                return Stack(
                  children: [
                    InputMapSelecction(
                      controller: toController,
                      onTap: (){
                      },
                      top: 110,
                      labelText: 'Seleccione destino',
                      province: toLocation.provinceName ==''?'':toLocation.provinceName  ,
                      district: toLocation.districtName ==''?'':toLocation.districtName  ,
                    ),
                    SaveButtonWidget(context),
                    Positioned(
                      left: 15,
                      top: 180,
                      child: Row(
                        children: [
                          Card(
                            elevation: 5,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Select<double>(
                                value: initialCircularRadio,
                                // placeholderIsSelected: true,
                                showPlaceholder: false,
                                items:circularRadio.map((item) => DropdownMenuItem(
                                  child: Center(child: Text(item.toString()+' km')),
                                  value: item
                                )).toList(),
                                onChanged: (val){
                                  initialCircularRadio = val;
                                    setState((){});
                                },
                              ),
                            ),
                          ),
                          Card(
                            elevation: 5,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Select<int>(
                                value: initialSeat,
                                // placeholderIsSelected: true,
                                showPlaceholder: false,
                                items:seating.map((item) => DropdownMenuItem(
                                  child: Center(child: Row(
                                    children: [
                                      Text(item.toString()),
                                      SizedBox(width: 5,),
                                      Icon(Icons.airline_seat_recline_normal ,size: 20,color: Colors.black,)
                                    ],
                                  )),
                                  value: item
                                )).toList(),
                                onChanged: (val){
                                  initialSeat = val;
                                    setState((){});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }
            return Container();
          },
        )
      ],
    );
  }
  Positioned SaveButtonWidget(BuildContext context) {
    return Positioned(
      top: 500,
      right: 15,
      left: 15,
      child: PrincipalButton(
        text: 'Buscar interprovincial',
        onPressed: ()async{
          showDialog(
            context: context,
            child: Center(
              child: Text('Buscando...',style: TextStyle(color: Colors.white, fontSize: 20,decoration: TextDecoration.none),)
            ),
          );
          print(toLocation.districtName );
          BlocProvider.of<AvailablesRoutesBloc>(context).add(GetAvailablesRoutesEvent(from: fromLocation,to: toLocation,radio: initialCircularRadio,seating: initialSeat));
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).push(Routes.toAvailableRoutesPage());
        },
      )
    );
  }
}

