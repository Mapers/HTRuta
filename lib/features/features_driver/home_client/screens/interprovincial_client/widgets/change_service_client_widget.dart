import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/features/ClientTaxiApp/enums/type_client_service_enum.dart';
import 'package:HTRuta/features/DriverTaxiApp/enums/type_driver_service_enum.dart';
import 'package:HTRuta/features/features_driver/home_client/presentation/bloc/client_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeServiceClientWidget extends StatelessWidget {
  const ChangeServiceClientWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 42,
      child: BlocBuilder<ClientServiceBloc, ClientServiceState>(
        builder: (ctx, state){
          DataClientServiceState data = state;
          return Card(
            elevation: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Select<TypeClientService>(
                value: data.typeService,
                showPlaceholder: false,
                items: TypeClientService.values.map((item) => DropdownMenuItem(
                  child: Center(child: Text(getTextByTypeClientService(item))),
                  value: item
                )).toList(),
                onChanged: (newItem){
                  print('newItem:'+ newItem.index.toString());
                  BlocProvider.of<ClientServiceBloc>(context).add(ChangeDriverServiceEvent(type: newItem));
                },
              ),
            ),
          );
        },
      )
    );
  }
}