import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_driver_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PositionedSeatManagerWidget extends StatelessWidget {
  final Widget child;
  const PositionedSeatManagerWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  width: 120,
                  child: OutlineButton.icon(
                    icon: Icon(Icons.exposure_minus_1),
                    label: Expanded(
                      child: Text('Asiento disponible', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ),
                    onPressed: (){
                      BlocProvider.of<InterprovincialDriverBloc>(context).add(MinusOneAvailabelSeatInterprovincialDriverEvent());
                    },
                  )
                ),
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
                      BlocBuilder<InterprovincialDriverBloc, InterprovincialDriverState>(
                        builder: (ctx, state){
                          DataInterprovincialDriverState data = state;
                          return Text(data.availableSeats.toString());
                        },
                      ),
                      Icon(Icons.airline_seat_recline_normal_rounded, color: Colors.green)
                    ],
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: OutlineButton.icon(
                    icon: Icon(Icons.exposure_plus_1),
                    label: Expanded(
                      child: Text('Asiento disponible', style: TextStyle(color: Colors.black54, fontSize: 12)),
                    ),
                    onPressed: (){
                      //! Se requiere tener el maximo de total de asientos
                      BlocProvider.of<InterprovincialDriverBloc>(context).add(PlusOneAvailabelSeatInterprovincialDriverEvent(maxSeats: 60));
                    },
                  )
                ),
              ],
            ),
            child ?? Container(),
            SizedBox(height: child == null ? 5 : 0),
          ],
        )
      )
    );
  }
}