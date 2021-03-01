import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/cards_availables_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/injection_container.dart' as ij;


class AvailableRoutesPage extends StatefulWidget {
  final String provinceOrigin;
  final String provinceDestination;
  AvailableRoutesPage({Key key, this.provinceOrigin, this.provinceDestination})
      : super(key: key);

  @override
  _AvailableRoutesPageState createState() => _AvailableRoutesPageState();
}

class _AvailableRoutesPageState extends State<AvailableRoutesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas disponibles'),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => ij.sl<AvailablesRoutesBloc>(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(widget.provinceOrigin),
                    Icon(Icons.arrow_forward_sharp),
                    Text(widget.provinceDestination),
                  ],
                ),
                CardsAvailablesRoutes()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
