import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/cards_availables_routes.dart';
import 'package:flutter/material.dart';

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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              CardsAvailablesRoutes()
            ],
          ),
        ),
      ),
    );
  }
}
