import 'package:HTRuta/app/widgets/loading_positioned.dart';
import 'package:HTRuta/core/utils/location_util.dart';
import 'package:HTRuta/core/utils/map_viewer_util.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/custom_dropdown_client.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/stateinput_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/availables_routes_page.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/map_interprovincial_client_widget.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/positioned_choose_route_widget.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/search_address_screen_interprovincial.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/select_address_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InterprovincialClientScreen extends StatefulWidget {
  final bool rejected;
  InterprovincialClientScreen({Key key, this.rejected = false}) : super(key: key);

  @override
  _InterprovincialClientScreenState createState() => _InterprovincialClientScreenState();
}

class _InterprovincialClientScreenState extends State<InterprovincialClientScreen> {
  LocationEntity toLocation;
  LocationEntity fromLocation;
  Place fromAddress;
  Place toAddress;
  TextEditingController toController = TextEditingController();
  LocationEntity location = LocationEntity.initalPeruPosition();
  bool drawCircle = false;
  double initialCircularRadio;
  int seat;
  bool isSelect;
  BitmapDescriptor currentPinLocationIcon;
  final _prefs = UserPreferences();

  @override
  void initState() {
    seat = 1;
    initialCircularRadio = 2;
    fromLocation = LocationEntity(
      latLang: null,
      districtName: '',
      provinceName: '',
      regionName: '',
      streetName: '',
    );
    toLocation = LocationEntity(
      latLang: null,
      districtName: '',
      provinceName: '',
      regionName: '',
      streetName: '',
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      location = await LocationUtil.currentLocation();
      currentPinLocationIcon = await BitmapDescriptor.fromAssetImage( ImageConfiguration(devicePixelRatio: 2.5),'assets/image/marker/ic_pick_48.png');
      BlocProvider.of<InterprovincialClientBloc>(context).add(LoadInterprovincialClientEvent());
      if(widget.rejected){
        BlocProvider.of<InterprovincialClientBloc>(context).add(SearchcInterprovincialClientEvent());
        changeStateCircle();
        DataAvailablesRoutes param = BlocProvider.of<AvailablesRoutesBloc>(context).state;
        seat = param.requiredSeats;
        getfrom(param.distictfrom);
        fromAddress = Place(
          formattedAddress: param.distictfrom.districtName,
          name: param.distictfrom.streetName == '' ? param.distictfrom.districtName +', ' + param.distictfrom.provinceName  :param.distictfrom.streetName + ', '+ param.distictfrom.districtName + ', ' + param.distictfrom.provinceName,
          lat: param.distictfrom.latLang.latitude,
          lng: param.distictfrom.latLang.longitude,
        );
        getTo( param.distictTo);
        toAddress = Place(
          formattedAddress: param.distictTo.districtName,
          name: param.distictTo.streetName == '' ? param.distictTo.districtName +', ' + param.distictTo.provinceName  :param.distictTo.streetName + ', '+ param.distictTo.districtName + ', ' + param.distictTo.provinceName,
          lat: param.distictTo.latLang.latitude,
          lng: param.distictTo.latLang.longitude,
        );
        BlocProvider.of<InterprovincialClientBloc>(context).add(AvailablesInterprovincialClientEvent());
        BlocProvider.of<AvailablesRoutesBloc>(context).add(GetAvailablesRoutesEvent(from: param.distictfrom ,to: param.distictTo ,radio: param.radio ,seating: param.requiredSeats , paymentMethods: _prefs.getClientPaymentMethods.map((e) => int.parse(e)).toList()));
      }
    });
  }

  void changeStateCircle(){
    drawCircle = true;
    setState(() {
    });
  }
  void getfrom(LocationEntity from){
    Marker markerFrom = MapViewerUtil.generateMarker(
      latLng: from.latLang,
      nameMarkerId: 'FROM_POSITION_MARKER',
      icon: currentPinLocationIcon,
    );
    BlocProvider.of<StateinputBloc>(context).add(AddMarkerStateinputEvent(markers: markerFrom));
    fromLocation = from;
    fromAddress = Place(
      formattedAddress: fromLocation.districtName ,
      name: fromLocation.streetName == '' ? fromLocation.districtName +', ' + fromLocation.provinceName  :fromLocation.streetName + ', '+ fromLocation.districtName + ', ' + fromLocation.provinceName,
      lat: fromLocation.latLang.latitude,
      lng: fromLocation.latLang.longitude
    );
  }
  void getTo( LocationEntity to){
    toLocation = to;
    Marker markerTo = MapViewerUtil.generateMarker(
      latLng: to.latLang,
      nameMarkerId: 'TO_POSITION_MARKER',
      icon: currentPinLocationIcon,
    );
    BlocProvider.of<StateinputBloc>(context).add(AddMarkerStateinputEvent(markers: markerTo));
    toAddress = Place(
      formattedAddress: toLocation.districtName ,
      name: toLocation.streetName == '' ? toLocation.districtName +', ' + toLocation.provinceName  :toLocation.streetName + ', '+ toLocation.districtName + ', ' + toLocation.provinceName,
      lat: toLocation.latLang.latitude,
      lng: toLocation.latLang.longitude
    );
    setState(() {});
  }
  void getSeating(int seating){
    seat = seating;
  }
  void onSearch() async {
    if(toLocation.districtName == ''){
      Fluttertoast.showToast(
        msg: 'Seleccione su destino',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    BlocProvider.of<InterprovincialClientBloc>(context).add(AvailablesInterprovincialClientEvent());
    BlocProvider.of<AvailablesRoutesBloc>(context).add(
      GetAvailablesRoutesEvent(
        from: fromLocation,
        to: toLocation,
        radio: initialCircularRadio,
        seating: seat,
        paymentMethods: _prefs.getClientPaymentMethods.map((e) => int.parse(e)).toList())
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          MapInterprovincialClientWidget(
            destinationInput: getTo,
            pickUpInput: getfrom,
            drawCircle: false,
            radiusCircle: initialCircularRadio,
            getFrom: getfrom,
            iselect: isSelect,
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
                      Positioned(
                        bottom: 10,
                        left: 20,
                        right: 20,
                        child: Container(
                            height: 230,
                            child: SelectAddressWidget(
                              fromAddress: fromAddress,
                              toAddress: toAddress,
                              onSearch: onSearch,
                              getSeating: getSeating,
                              onTapTo: (val){
                                Navigator.of(context).push( MaterialPageRoute( builder: (context) =>
                                  SearchAddressScreenInterprovincial(
                                    getTo: getTo,
                                    getfrom: getfrom,
                                    fromSelect: fromLocation,
                                    toSelect: toLocation,
                                    isSelect: val,
                                    currentLocation: Position(longitude: location.latLang.longitude,latitude: location.latLang.latitude)
                                  ),
                                    fullscreenDialog: true ));
                              },
                            )
                        ),
                      ),
                    ],
                  );
                } else if( state.status == InterprovincialClientStatus.availablesInterprovincial ){
                  return Stack(
                    children: [
                      Positioned(
                        top: 100,
                        bottom: 10,
                        left: 5,
                        right: 5,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          height: 230,
                          child: AvailableRoutesPage(),
                        ),
                      ),
                      Positioned(
                        top: 52,
                        right: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            )
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: (){
                              BlocProvider.of<InterprovincialClientBloc>(context).add(SearchcInterprovincialClientEvent());
                            }
                          ),
                        )
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
}

