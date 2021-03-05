import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/features/feature_client/home/entities/privince_client_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/choose_routes_client_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchProvinceClientPage extends StatefulWidget {
  final Function getPrivinceOrigin;
  final String title;
  SearchProvinceClientPage(
      {Key key, @required this.title, this.getPrivinceOrigin})
      : super(key: key);

  @override
  _SearchProvinceClientPageState createState() =>
      _SearchProvinceClientPageState();
}

class _SearchProvinceClientPageState extends State<SearchProvinceClientPage> {
  bool statePage = true;
  @override
  void initState() {
    if (widget.title != 'Buscar provincia origen') {
      statePage = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ChooseRoutesClientBloc>(context).add(GetProvincesChooseRoutesClientEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: PrincipalInput(
                  onChanged: (val) {},
                  hinText: 'Provincia',
                ),
              ),
              BlocBuilder<ChooseRoutesClientBloc, ChooseRoutesClientState>(
                builder: (context, state) {
                  if(state is LoadingChooseRoutesClient){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  DataChooseRoutesClient param = state;
                  if(param.provinces.isEmpty){
                    return Center(child: Text('sin data'),);
                  }
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: param.provinces.length,
                    itemBuilder: (context, int i) {
                      ProvincesClientEntity privinces = param.provinces[i];
                      return InkWell(
                        onTap: () {
                          if (statePage) {
                            widget.getPrivinceOrigin(privinces.nameProvince, '');
                          } else {
                            widget.getPrivinceOrigin('', privinces.nameProvince);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          children: [
                            Text(privinces.nameProvince),
                            Divider()
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
