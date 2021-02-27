import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/inteprovincial_location_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/widgets/map_interprovincia_widget.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/widgets/change_service_client_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      BlocProvider.of<InterprovincialBloc>(context).add(GetDataInterprovincialEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ij.sl<InterprovincialLocationBloc>(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          MapInterprovincialWidget(),
          ChangeServiceClientWidget(),
          Positioned(
            bottom: 20,
            child: PrincipalButton(
              onPressed: (){
                Navigator.of(context).push(Routes.toChooseRouteTrasportationPage());
              },
              text: 'Elegir ruta y trasporte'
            ),
          ),
          // BlocBuilder<ClientInterprovincialBloc, ClientInterprovincialState>(
          //   builder: (context, state) {
          //     if(state is DataInterprovincialState){
          //     }
          //     return Container();
          //   },
          // )
        ],
      )
    );
  }
}

