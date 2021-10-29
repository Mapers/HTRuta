import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/cards_availables_routes.dart';
import 'package:flutter/material.dart';

class AvailableRoutesPage extends StatefulWidget {
  AvailableRoutesPage({Key key,})
      : super(key: key);

  @override
  _AvailableRoutesPageState createState() => _AvailableRoutesPageState();
}

class _AvailableRoutesPageState extends State<AvailableRoutesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: CardsAvailablesRoutes(),
      ),
    );
  }
}
