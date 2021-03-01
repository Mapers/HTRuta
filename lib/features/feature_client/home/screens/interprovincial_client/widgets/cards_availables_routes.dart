import 'package:HTRuta/app/styles/style.dart';
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
          return Center(child: Text('sin data'),);
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: param.availablesRoutes.length ,
          itemBuilder: (BuildContext context, int index) {
            return CardAvailiblesRoutes(availablesRoutesEntity: param.availablesRoutes[index],onTap: (){},);
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
                  Text(
                    availablesRoutesEntity.origin+' '+availablesRoutesEntity.destination,
                    style: textStyleHeading18Black,
                  ),
                  Text(availablesRoutesEntity.costo),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: availablesRoutesEntity.state == true ? Colors.green:Colors.amber ,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    availablesRoutesEntity.state == true ? 'En Paradero':'En ruta',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Text(availablesRoutesEntity.street ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.directions_bus_rounded),
                  Text(availablesRoutesEntity.nameDriver),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time),
                  Text(availablesRoutesEntity.time),
                  Icon(Icons.calendar_today),
                  Text(availablesRoutesEntity.date),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
