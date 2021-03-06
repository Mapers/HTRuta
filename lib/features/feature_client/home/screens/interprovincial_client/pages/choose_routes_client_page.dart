import 'package:HTRuta/app/components/input_button.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/features/feature_client/home/entities/province_district_client_entity.dart';
import 'package:flutter/material.dart';

class ChooseRouteClientPage extends StatefulWidget {
  const ChooseRouteClientPage({Key key}) : super(key: key);

  @override
  _ChooseRouteClientPageState createState() => _ChooseRouteClientPageState();
}

class _ChooseRouteClientPageState extends State<ChooseRouteClientPage> {
  ProvinceDistrictClientEntity provinceOrigin;
  ProvinceDistrictClientEntity provinceDestination;
  TextEditingController provinceOriginController = TextEditingController();
  TextEditingController provinceDestinationController = TextEditingController();

  void setProvinceOrigin(ProvinceDistrictClientEntity _provinceDistrict){
    provinceOrigin = _provinceDistrict;
    provinceOriginController.text = _provinceDistrict.provinceName + ' - ' + _provinceDistrict.districtName;
  }
  void setProvinceDstination(ProvinceDistrictClientEntity _provinceDistrict){
    provinceDestination = _provinceDistrict;
    provinceDestinationController.text = _provinceDistrict.provinceName + ' - ' + _provinceDistrict.districtName;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10,),
              InputButton(
                controller: provinceOriginController,
                enabled: false,
                onTap: () => Navigator.of(context).push(Routes.toSearchProvinceClientPage(title: 'Buscar distrito origen', onSelectProvinceDistrict: setProvinceOrigin)),
                hinText: 'Origen',
                // enabled: false,
              ),
              InputButton(
                controller: provinceDestinationController,
                hinText: 'Destino',
                enabled: false,
                onTap: () => Navigator.of(context).push(Routes.toSearchProvinceClientPage(title: 'Buscar distrito destino',onSelectProvinceDistrict: setProvinceDstination)),
              ),
              PrincipalButton(
                text: 'Buscar rutas',
                onPressed: (){
                  Navigator.of(context).push(Routes.toAvailableRoutesPage(origin: provinceOrigin ,destination: provinceDestination));
                }
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
