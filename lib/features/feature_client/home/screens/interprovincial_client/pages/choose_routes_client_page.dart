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

  TextEditingController provinceOrigin = TextEditingController();
  TextEditingController provinceDestination = TextEditingController();

  void getPrivinceOrigin(privinceOrigin,privinceDestination){
    if(privinceOrigin != ''){
      provinceOrigin.text = privinceOrigin;
    }else{
      provinceDestination.text = privinceDestination;
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
                controller: provinceOrigin,
                enabled: false,
                onTap: (){
                  Navigator.of(context).push(Routes.toSearchProvinceClientPage(title: 'Buscar provincia origen', onTap: getPrivinceOrigin));
                },
                hinText: 'Origen',
                // enabled: false,
              ),
              InputButton(
                controller: provinceDestination,
                hinText: 'Destino',
                enabled: false,
                onTap: (){
                  Navigator.of(context).push(Routes.toSearchProvinceClientPage(title: 'Buscar provincia destino',onTap: getPrivinceOrigin));
                },
              ),
              PrincipalButton(
                text: 'Buscar rutas',
                onPressed: (){
                  Navigator.of(context).push(Routes.toAvailableRoutesPage());
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
