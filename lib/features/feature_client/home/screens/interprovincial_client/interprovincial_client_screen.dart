import 'package:HTRuta/app/components/input_button.dart';
import 'package:HTRuta/app/components/input_map_selecction.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/widgets/loading_positioned.dart';
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

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<InterprovincialClientBloc>(context).add(LoadInterprovincialClientEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChooseRoutesClientBloc>(create: (_) => ij.sl<ChooseRoutesClientBloc>()),
      ],
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          MapInterprovincialClientWidget(),
          ChangeServiceClientWidget(),
          BlocBuilder<InterprovincialClientBloc, InterprovincialClientState>(
            builder: (context, state) {
              print(state);
              if(state is DataInterprovincialClientState){
                print(state.status);
                if(state.status == InteprovincialClientStatus.loading){
                  return LoadingPositioned(label: state.loadingMessage);
                }else if(state.status == InteprovincialClientStatus.notEstablished){
                  return PositionedChooseRouteWidget();
                }else if(state.status == InteprovincialClientStatus.searchInterprovincial){
                  return Stack(
                    children: [
                      InputMapSelecction(
                        onTap: (){
                        },
                        top: 110,
                        labelText: 'Seleccione destino',
                        region: '',
                        province: '' ,
                        district: '' ,
                      ),
                      SaveButtonWidget(context),
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

