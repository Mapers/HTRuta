import 'package:HTRuta/app/components/input_map_selecction.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/widgets/loading_positioned.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/map_interprovincial_client_widget.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/choose_routes_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/change_service_client_widget.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/positioned_choose_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/injection_container.dart' as ij;

class InterprovincialClientScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  InterprovincialClientScreen({Key key, @required this.parentScaffoldKey}) : super(key: key);

  @override
  _InterprovincialClientScreenState createState() => _InterprovincialClientScreenState();
}

class _InterprovincialClientScreenState extends State<InterprovincialClientScreen> {
  LocationEntity toLocation;
  TextEditingController toController = TextEditingController();
  List<double> circularRadio = [1,2,3,4,5];
  List<int> seating = [1,2,3,4,5,6,7,8,9,10];
  bool drawCircle = false;
  double initialCircularRadio;
  int initialSeat;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<InterprovincialClientBloc>(context).add(LoadInterprovincialClientEvent());
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChooseRoutesClientBloc>(create: (_) => ij.getIt<ChooseRoutesClientBloc>()),
      ],
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          MapInterprovincialClientWidget(destinationInpit: destinationInpit,drawCircle: drawCircle,radiusCircle: initialCircularRadio ),
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
      )
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
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).push(Routes.toAvailableRoutesPage());
        },
      )
    );
  }
}

