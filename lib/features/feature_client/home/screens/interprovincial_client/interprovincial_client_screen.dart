import 'package:HTRuta/app/components/input_map_selecction.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/widgets/loading_positioned.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/custom_dropdown_client.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/payment_selector.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/map_interprovincial_client_widget.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/positioned_choose_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';

class InterprovincialClientScreen extends StatefulWidget {
  final bool rejected;
  InterprovincialClientScreen({Key key, this.rejected = false}) : super(key: key);

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
      if(widget.rejected){
        BlocProvider.of<InterprovincialClientBloc>(context).add(SearchcInterprovincialClientEvent());
        changeStateCircle();
        DataAvailablesRoutes param = BlocProvider.of<AvailablesRoutesBloc>(context).state;
        initialSeat = param.requiredSeats;
        destinationInput( param.distictTo);
        BlocProvider.of<AvailablesRoutesBloc>(context).add(GetAvailablesRoutesEvent(from: param.distictfrom ,to: param.distictTo ,radio: param.radio ,seating: param.requiredSeats , paymentMethods: _prefs.getClientPaymentMethods.map((e) => int.parse(e)).toList()));
        Navigator.of(context).push(Routes.toAvailableRoutesPage());
      }
    });
  }
  void destinationInput(LocationEntity to){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          MapInterprovincialClientWidget(
            destinationInpit: destinationInput,
            drawCircle: drawCircle,
            radiusCircle: initialCircularRadio,
            getFrom: getfrom,
          ),
          // ChangeServiceClientWidget(),
          CustomDropdownClient(),
          BlocBuilder<InterprovincialClientBloc, InterprovincialClientState>(
            builder: (context, state) {
              if(state is DataInterprovincialClientState){
                if(state.status == InterprovincialClientStatus.loading){
                  return LoadingPositioned(label: state.loadingMessage);
                }else if(state.status == InterprovincialClientStatus.notEstablished){
                  return PositionedChooseRouteWidget(changeStateCircle: changeStateCircle);
                }else if(state.status == InterprovincialClientStatus.searchInterprovincial){
                  return Stack(
                    children: [
                      InputMapSelecction(
                        controller: toController,
                        top: 110,
                        labelText: 'Seleccione destino',
                        province: toLocation.provinceName ==''?'':toLocation.provinceName  ,
                        district: toLocation.districtName ==''?'':toLocation.districtName  ,
                      ),
                      SaveButtonWidget(context),
                      Positioned(
                        left: 15,
                        top: 180,
                        child: Wrap(
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
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 250,
                        child: Row(
                          children: [
                            Card(
                              elevation: 5,
                              color: Colors.white,
                              child: PaymentSelector(),
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
      ),
    );
  }
  Positioned SaveButtonWidget(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 15,
      left: 15,
      child: PrincipalButton(
        text: 'Buscar interprovincial',
        onPressed: () async{
          if(toLocation == null){
            Fluttertoast.showToast(
              msg: 'Seleccione su destino',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            return;
          }
          if(_prefs.getClientPaymentMethods.isEmpty){
            Fluttertoast.showToast(
              msg: 'Seleccione al menos un método de pago que disponga',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            return;
          }
          showDialog(
            context: context,
            child: Center(
              child: Text('Buscando...',style: TextStyle(color: Colors.white, fontSize: 20,decoration: TextDecoration.none),)
            ),
          );
          BlocProvider.of<AvailablesRoutesBloc>(context).add(GetAvailablesRoutesEvent(from: fromLocation,to: toLocation,radio: initialCircularRadio,seating: initialSeat, paymentMethods: _prefs.getClientPaymentMethods.map((e) => int.parse(e)).toList()));
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).push(Routes.toAvailableRoutesPage());
        },
      )
    );
  }
}

