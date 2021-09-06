import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/app/widgets/card_informativa_location.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/entities/location_entity.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';
import 'package:HTRuta/features/feature_client/home/entities/available_route_enity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/availables_routes_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/comments_drive_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/widgets/coments_widgets.dart';
import 'package:HTRuta/models/minutes_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/injection_container.dart' as ij;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CardsAvailablesRoutes extends StatefulWidget {
  CardsAvailablesRoutes({Key key}) : super(key: key);

  @override
  _CardsAvailablesRoutesState createState() => _CardsAvailablesRoutesState();
}

class _CardsAvailablesRoutesState extends State<CardsAvailablesRoutes> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailablesRoutesBloc, AvailablesRoutesState>(
      builder: (context, state) {
        if (state is LoadingAvailablesRoutes) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10,),
                Text('Buscado 5km a la redonda...', style: TextStyle(color: Colors.white ),)
              ],
            ),
          );
        }
        DataAvailablesRoutes param = state;
        if (param.availablesRoutes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('- Sin resultados -'),
              ],
            ),
          );
        }
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      param.distictfrom.districtName ,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward_sharp),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      param.distictTo.districtName ,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: param.availablesRoutes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CardAvailiblesRoutes(
                        availablesRoutesEntity: param.availablesRoutes[index],
                        onTap: () => Navigator.of(context).push(Routes.toTravelNegotationPage( availablesRoutesEntity: param.availablesRoutes[index] ) )
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardAvailiblesRoutes extends StatefulWidget {
  final AvailableRouteEntity availablesRoutesEntity;
  final Function onTap;

  const CardAvailiblesRoutes({Key key, this.availablesRoutesEntity, this.onTap})
      : super(key: key);

  @override
  _CardAvailiblesRoutesState createState() => _CardAvailiblesRoutesState();
}

class _CardAvailiblesRoutesState extends State<CardAvailiblesRoutes> {
  final pickUpApi = PickupApi();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentsDriveBloc>(
      create: (_) => ij.getIt<CommentsDriveBloc>(),
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: widget.onTap,
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
                      widget.availablesRoutesEntity.route.name,
                      style: textStyleHeading18Black,
                    )),
                    SizedBox(width: 10),
                    Text(
                      'S/.' + widget.availablesRoutesEntity.route.cost.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: 90,
                      decoration: BoxDecoration(
                        color: widget.availablesRoutesEntity.status == InterprovincialStatus.onWhereabouts
                        ? Colors.green
                        : Colors.amber,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.availablesRoutesEntity.status == InterprovincialStatus.onWhereabouts
                        ? 'En paradero'
                        : 'En ruta',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RatingBar.builder(
                      initialRating: widget.availablesRoutesEntity.route.starts,
                      allowHalfRating: true,
                      itemSize: 18,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: null,
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ComentsWirdgets(availablesRoutesEntity: widget.availablesRoutesEntity,);
                            }
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Ver comentarios', style: TextStyle(color: Colors.lightBlue, decoration: TextDecoration.underline,),),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.face, color: Colors.black87),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(widget.availablesRoutesEntity.route.driverName,
                          style: TextStyle(color: Colors.black87, fontSize: 14)),
                    ),
                  ],
                ),
                CardInformationLocation(location: widget.availablesRoutesEntity.route.fromLocation,icon: Icons.trip_origin, iconColor: Colors.amber,),
                SizedBox(height: 5),
                CardInformationLocation(location: widget.availablesRoutesEntity.route.toLocation,icon: Icons.location_on,iconColor: Colors.red,),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.black87),
                    SizedBox(width: 5),
                    Text(
                      widget.availablesRoutesEntity.routeStartDateTime.formatOnlyTimeInAmPM,
                      style: TextStyle(color: Colors.black87, fontSize: 14)
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.calendar_today, color: Colors.black87),
                    SizedBox(width: 5),
                    Text(
                      widget.availablesRoutesEntity.routeStartDateTime.formatOnlyDate,
                      style: TextStyle(color: Colors.black87, fontSize: 14)
                    ),
                    Expanded(child: SizedBox()),
                    Icon(Icons.airline_seat_recline_normal_rounded, color: Colors.green),
                    SizedBox(width: 8),
                    Text(widget.availablesRoutesEntity.availableSeats.toString(),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ],
                ),
                FutureBuilder(
                  future: pickUpApi.calculateMinutes( widget.availablesRoutesEntity.route.fromLocation.latLang.latitude, widget.availablesRoutesEntity.route.fromLocation.latLang.longitude, widget.availablesRoutesEntity.route.toLocation.latLang.latitude, widget.availablesRoutesEntity.route.toLocation.latLang.longitude),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasError) return Container();
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting: return Container();
                      case ConnectionState.none: return Container();
                      case ConnectionState.active: {
                        final AproxElement element = snapshot.data;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/image/tracking.png',width: 22,height: 22,),
                                SizedBox(width: 8,),
                                Text(element.distance.text),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset('assets/image/pngwing.png',width: 22,height: 22,),
                                SizedBox(width: 8,),
                                Text(element.duration.text),
                              ],
                            ),
                          ]
                        );
                      }
                      case ConnectionState.done: {
                        final AproxElement element = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/image/tracking.png',width: 22,height: 22,),
                                  SizedBox(width: 8,),
                                  Text(element.distance.text),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset('assets/image/pngwing.png',width: 22,height: 22,),
                                  SizedBox(width: 8,),
                                  Text(element.duration.text),
                                ],
                              ),
                            ]
                          ),
                        );
                      }
                    }
                    return Container();
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

