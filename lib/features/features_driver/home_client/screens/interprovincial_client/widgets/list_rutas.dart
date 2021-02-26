import 'package:HTRuta/features/features_driver/home_client/entities/Client_interprovicial_routes_entity.dart';
import 'package:HTRuta/features/features_driver/home_client/screens/interprovincial_client/bloc/client_interprovincial_routes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app_router.dart';

class ListRuotes extends StatefulWidget {
  ListRuotes({Key key}) : super(key: key);

  @override
  _ListRuotesState createState() => _ListRuotesState();
}

class _ListRuotesState extends State<ListRuotes> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ClientInterprovincialRoutesBloc>(context).add(GetRoutesFoundClientInterprovincialRoutesEvent());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientInterprovincialRoutesBloc, ClientInterprovincialRoutesState>(
      builder: (context, state) {
        if (state is LoadingClientInterprovincialRoutes) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        DataClientInterprovincialRoutes  param = state;
        if (param.routesFound.isEmpty) {
            return Center(
              child: Text('falta data '),
            );
          }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: param.routesFound.length ,
          itemBuilder: (ctx, i) {
            ClientInterporvincialRoutesEntity routeFound = param.routesFound[i];
            return CartRoutes(
              title: routeFound.nameDriver,
              from: routeFound.from ,
              to: routeFound.to ,
            );
          },
        );
      },
    );
  }
}

class CartRoutes extends StatelessWidget {
  final String title;
  final String from;
  final String to;
  const CartRoutes({
    Key key,
    @required this.title,
    @required this.from,
    @required this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeClientScreen, (route) => false);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(title),
                subtitle: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(width: 100, child: Text(from)),
                      Icon(Icons.arrow_forward_rounded),
                      Container(width: 100, child: Text(to)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
