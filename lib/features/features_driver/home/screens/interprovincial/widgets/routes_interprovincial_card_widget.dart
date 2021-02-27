import 'package:HTRuta/features/features_driver/home/data/remote/inteprovincial_data_remote.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_route_entity.dart';
import 'package:HTRuta/features/features_driver/home/screens/interprovincial/bloc/interprovincial_bloc.dart';
import 'package:HTRuta/core/utils/extensions/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutesInterprovincialCardWidget extends StatefulWidget {
  RoutesInterprovincialCardWidget({Key key}) : super(key: key);

  @override
  _RoutesInterprovincialCardWidgetState createState() => _RoutesInterprovincialCardWidgetState();
}

class _RoutesInterprovincialCardWidgetState extends State<RoutesInterprovincialCardWidget> {
  List<InterprovincialRouteEntity> interprovincialRoutes = [];

  bool isLoading = true;

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      InterprovincialDataRemote interprovincialDataRemote = InterprovincialDataRemote();
      interprovincialRoutes = await interprovincialDataRemote.getAllRoutesByUser();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 20,
      right: 20,
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Text('Seleccione Ruta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 170,
                child: isLoading ? Center(
                  child: CircularProgressIndicator()
                ) : ListView.separated(
                  separatorBuilder: (ctx, i) => Divider(height: 0),
                  itemCount: interprovincialRoutes.length,
                  itemBuilder: (ctx, i){
                    return _getItemRoute(interprovincialRoutes[i]);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getItemRoute(InterprovincialRouteEntity interprovincialRoute){
    return ListTile(
      title: Text(interprovincialRoute.name),
      dense: true,
      subtitle: Row(
        children: [
          Expanded(
            child: Text(interprovincialRoute.fromLocation.name)
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_right_alt_outlined, size: 28,),
          ),
          Expanded(
            child: Text(interprovincialRoute.toLocation.name),
          )
        ],
      ),
      onTap: () => _showModalConfirmationRoute(interprovincialRoute),
    );
  }

  void _showModalConfirmationRoute(InterprovincialRouteEntity interprovincialRoute) async{
    DateTime dateTime = await showDatePicker(
      context: context,
      helpText: 'Seleccione día de Inicio de ruta',
      confirmText: 'Aceptar',
      cancelText: 'Cancelar',
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 5)),
      fieldLabelText: 'el label',
      fieldHintText: 'el hint',
      errorFormatText: 'Formato no válido',
      errorInvalidText: 'Formato no válido'
    );
    if(dateTime == null){
      return;
    }
    TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      helpText: 'Ingrese Hora de Inicio de Ruta',
      confirmText: 'Aceptar',
      cancelText: 'Cancelar',
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if(timeOfDay == null){
      return;
    }
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text('¿Desea iniciar con esta ruta?'),
        content: ListView(
          shrinkWrap: true,
          children: [
            Text('Iniciará el servicio interprovincial con la ruta ${interprovincialRoute.name}.'),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time_outlined),
                SizedBox(width: 5),
                Text(timeOfDay.formatPeriod, style: TextStyle(color: Colors.black54)),
                Spacer(),
                Icon(Icons.calendar_today),
                SizedBox(width: 5),
                Text('12/05/2021', style: TextStyle(color: Colors.black54)),
              ]
            )
          ],
        ),
        actions: [
          OutlineButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          RaisedButton(
            child: Text('Iniciar ruta', style: TextStyle(color: Colors.white)),
            onPressed: (){
              Navigator.of(context).pop();
              BlocProvider.of<InterprovincialBloc>(context).add(SelectRouteInterprovincialEvent(route: interprovincialRoute));
            },
          )
        ],
      )
    );
  }
}