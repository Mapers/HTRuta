import 'package:HTRuta/app/components/select.dart';
import 'package:HTRuta/enums/type_service_enum.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
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
              child: Select<TypeServiceEnum>(
                value: data.typeService,
                showPlaceholder: false,
                items: TypeServiceEnum.values.map((item) => DropdownMenuItem(
                  child: Center(child: Text(getTextByTypeServiceEnum(item))),
                  value: item
                )).toList(),
                onChanged: (newItem){
                  BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: newItem));
                },
              ),
            ),
          );
        },
      )
    );
  }
}