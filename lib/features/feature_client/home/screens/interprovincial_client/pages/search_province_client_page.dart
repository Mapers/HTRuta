import 'package:HTRuta/app/components/principal_input.dart';
import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/bloc/choose_routes_client_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnSelectProvinceDistrict = void Function(ProvinceDistrictClientEntity);

class SearchProvinceClientPage extends StatefulWidget {
  final OnSelectProvinceDistrict onSelectProvinceDistrict;
  final String title;
  SearchProvinceClientPage(
      {Key key, @required this.title, this.onSelectProvinceDistrict})
      : super(key: key);

  @override
  _SearchProvinceClientPageState createState() =>
      _SearchProvinceClientPageState();
}

class _SearchProvinceClientPageState extends State<SearchProvinceClientPage> {
  bool statePage = true;
  @override
  void initState() {
    if (widget.title != 'Buscar origen') {
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
                  hinText: 'Provincia - Distrito',
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
                  if(param.provinceDistricts.isEmpty){
                    return Center(child: Text('sin data'),);
                  }
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (ctx, i) => Divider(),
                    shrinkWrap: true,
                    itemCount: param.provinceDistricts.length,
                    itemBuilder: (context, int i) {
                      ProvinceDistrictClientEntity provincieDistrict = param.provinceDistricts[i];
                      return ListTile(
                        dense: true,
                        onTap: () {
                          widget.onSelectProvinceDistrict(provincieDistrict);
                          Navigator.of(context).pop();
                        },
                        title: Row(
                          children: [
                            Text(provincieDistrict.provinceName, style: TextStyle(fontSize: 14)),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_right_alt),
                            SizedBox(width: 5),
                            Text(provincieDistrict.districtName, style: TextStyle(fontSize: 14)),
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
