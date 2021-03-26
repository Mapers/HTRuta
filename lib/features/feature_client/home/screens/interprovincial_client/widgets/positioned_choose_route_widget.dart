import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/interprovincial_client_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PositionedChooseRouteWidget extends StatelessWidget {
  final Function changeStateCircle;
  const PositionedChooseRouteWidget({Key key, this.changeStateCircle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: PrincipalButton(
        onPressed: (){
          BlocProvider.of<InterprovincialClientBloc>(context).add(SearchcInterprovincialClientEvent());
          changeStateCircle();
        },
        text: '¿A dónde quieres ir?'
      ),
    );
  }
}