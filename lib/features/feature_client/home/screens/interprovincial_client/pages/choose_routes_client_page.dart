import 'package:HTRuta/app/components/input_button.dart';
import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:flutter/material.dart';

class ChooseRouteClientPage extends StatefulWidget {
  const ChooseRouteClientPage({Key key}) : super(key: key);

  @override
  _ChooseRouteClientPageState createState() => _ChooseRouteClientPageState();
}

class _ChooseRouteClientPageState extends State<ChooseRouteClientPage> {
  String provinceOrigin = '';
  String provinceDestination = '';
  TextEditingController _provinceOrigin = TextEditingController();
  TextEditingController _provinceDestination = TextEditingController();

  void getPrivinceOrigin(privinceOrigin,privinceDestination){
    if(privinceOrigin != ''){
      _provinceOrigin.text = privinceOrigin;
      provinceOrigin = privinceOrigin;
    }else{
      _provinceDestination.text = privinceDestination;
      provinceDestination = privinceDestination;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas'),
        centerTitle: false,
      ),
      // drawer: MenuDriverScreens(activeScreenName: screenName),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10,),
              InputButton(
                controller: _provinceOrigin,
                enabled: false,
                onTap: (){
                  Navigator.of(context).push(Routes.toSearchProvinceClientPage(title: 'Buscar provincia origen', onTap: getPrivinceOrigin));
                },
                hinText: 'Origen',
                // enabled: false,
              ),
              InputButton(
                controller: _provinceDestination,
                hinText: 'Destino',
                enabled: false,
                onTap: (){
                  Navigator.of(context).push(Routes.toSearchProvinceClientPage(title: 'Buscar provincia destino',onTap: getPrivinceOrigin));
                },
              ),
              PrincipalButton(
                text: 'Buscar rutas',
                onPressed: (){
                  print(provinceOrigin);
                  print(provinceDestination);
                  Navigator.of(context).push(Routes.toAvailableRoutesPage(provinceOrigin: provinceOrigin ,provinceDestination: provinceDestination));
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
