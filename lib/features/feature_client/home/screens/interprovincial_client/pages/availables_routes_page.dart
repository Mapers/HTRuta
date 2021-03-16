import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/cards_availables_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/injection_container.dart' as ij;


class AvailableRoutesPage extends StatefulWidget {
  final ProvinceDistrictClientEntity origin;
  final ProvinceDistrictClientEntity destination;
  AvailableRoutesPage({Key key, this.origin, this.destination})
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
          create: (context) => ij.getIt<AvailablesRoutesBloc>(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Expanded(
                //       child: Text(widget.origin.provinceName + ' - ' + widget.origin.districtName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center,),
                //     ),
                //     SizedBox(width: 5),
                //     Icon(Icons.arrow_forward_sharp),
                //     SizedBox(width: 5),
                //     Expanded(
                //       child: Text(widget.destination.provinceName + ' - ' + widget.destination.districtName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center,),
                //     ),
                //   ],
                // ),
                SizedBox(height: 10),
                CardsAvailablesRoutes()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
