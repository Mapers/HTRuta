import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/bloc/client_interprovincial_routes_bloc.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/widgets/list_rutas.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/injection_container.dart' as ij;
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseRouteTrasportationPage extends StatelessWidget {
  const ChooseRouteTrasportationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ij.sl<ClientInterprovincialRoutesBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rutas'),
          centerTitle: false,
        ),
        // drawer: MenuDriverScreens(activeScreenName: screenName),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10,),
                PrincipalInput(hinText: 'Origen',),
                PrincipalInput(hinText: 'Destino',),
                SizedBox(height: 10,),
                Text('Lista de rutas y conductores'),
                Divider(),
                ListRuotes()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
