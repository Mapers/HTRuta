import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/features/DriverTaxiApp/enums/type_driver_service_enum.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeServiceDriverWidget extends StatelessWidget {
  const ChangeServiceDriverWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 42,
      child: BlocBuilder<DriverServiceBloc, DriverServiceState>(
        builder: (ctx, state){
          DataDriverServiceState data = state;
          return Card(
            elevation: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Select<TypeDriverService>(
                value: data.typeService,
                showPlaceholder: false,
                items: TypeDriverService.values.map((item) => DropdownMenuItem(
                  child: Center(child: Text(getTextByTypeDriverService(item))),
                  value: item
                )).toList(),
                onChanged: (newItem){
                  print("XD");
                  BlocProvider.of<DriverServiceBloc>(context).add(ChangeDriverServiceEvent(type: newItem));
                },
              ),
            ),
          );
        },
      )
    );
  }
}