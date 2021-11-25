import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_interpronvincal_state_enum.dart';

class PositionedSeatManagerWidget extends StatefulWidget {
  final Widget child;

  PositionedSeatManagerWidget({Key key, this.child}) : super(key: key);

  @override
  _PositionedSeatManagerWidgetState createState() => _PositionedSeatManagerWidgetState();
}

class _PositionedSeatManagerWidgetState extends State<PositionedSeatManagerWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterprovincialDriverBloc, InterprovincialDriverState>(
      builder: (ctx, state){
        DataInterprovincialDriverState data = state;
        final status = [InterprovincialStatus.inRoute];
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: 10, right: 10, bottom: 3, left: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
              )
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(width: 150),
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.green
                        ),
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data.availableSeats.toString()),
                          Icon(Icons.airline_seat_recline_normal_rounded, color: Colors.green)
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Costo del pasaje:'),
                          Text('PEN ${data.routeService.cost}', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      )
                    )
                  ],
                ),
                widget.child ?? Container(),
                SizedBox(height: widget.child == null ? 5 : 0),
              ],
            )
          )
        );  
      }
    );
  }
}