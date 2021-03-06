import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/feature_client/home/entities/availables_routes_enity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardsAvailablesRoutes extends StatefulWidget {
  CardsAvailablesRoutes({Key key}) : super(key: key);

  @override
  _CardsAvailablesRoutesState createState() => _CardsAvailablesRoutesState();
}

class _CardsAvailablesRoutesState extends State<CardsAvailablesRoutes> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<AvailablesRoutesBloc>(context).add(GetAvailablesRoutesEvent());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailablesRoutesBloc, AvailablesRoutesState>(
      builder: (context, state) {
        if(state is LoadingAvailablesRoutes){
          return Center(child: CircularProgressIndicator());
        }
        DataAvailablesRoutes param = state;
        if(param.availablesRoutes.isEmpty){
          return Center(child: Text('- Sin resultados -'),);
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: param.availablesRoutes.length ,
          itemBuilder: (BuildContext context, int index) {
            return CardAvailiblesRoutes(
              availablesRoutesEntity: param.availablesRoutes[index],
              onTap: (){}
            );
          },
        );
      },
    );
  }
}

class CardAvailiblesRoutes extends StatelessWidget {
  final AvailablesRoutesEntity availablesRoutesEntity;
  final Function onTap;
  const CardAvailiblesRoutes({Key key, this.availablesRoutesEntity, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      availablesRoutesEntity.route.name,
                      style: textStyleHeading18Black,
                    )
                  ),
                  SizedBox(width: 10),
                  Text('S/.' + availablesRoutesEntity.route.cost.toStringAsFixed(2), style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold))
                ],
              ),
              Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.symmetric(vertical: 5),
                width: 90,
                decoration: BoxDecoration(
                  color: availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? Colors.green : Colors.amber ,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  availablesRoutesEntity.status != InterprovincialStatus.onWhereabouts ? 'En paradero':'En ruta',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.black87),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(availablesRoutesEntity.route.fromLocation.streetName, style: TextStyle(color: Colors.black87, fontSize: 14)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.directions_bus_rounded, color: Colors.black87),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(availablesRoutesEntity.route.toLocation.streetName, style: TextStyle(color: Colors.black87, fontSize: 14)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.black87),
                  SizedBox(width: 5),
                  Text(availablesRoutesEntity.routeStartDateTime.formatOnlyTimeInAmPM, style: TextStyle(color: Colors.black87, fontSize: 14)),
                  SizedBox(width: 20),
                  Icon(Icons.calendar_today, color: Colors.black87),
                  SizedBox(width: 5),
                  Text(availablesRoutesEntity.routeStartDateTime.formatOnlyDate, style: TextStyle(color: Colors.black87, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
