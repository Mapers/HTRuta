import 'package:flutter/material.dart';

class RoutesInterprovincialCardWidget extends StatelessWidget {
  const RoutesInterprovincialCardWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 50,
      right: 50,
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Text('Seleccione Ruta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                height: 170,
                child: ListView.separated(
                  separatorBuilder: (ctx, i) => Divider(height: 0,),
                  itemCount: 3,
                  itemBuilder: (ctx, i){
                    return _getItemRoute();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getItemRoute(){
    return ListTile(
      title: Text('Mi nombre Ruta'),
      dense: true,
      subtitle: Column(
        children: [
          Row(
            children: [
              Icon(Icons.my_location, size: 18,),
              SizedBox(width: 3),
              Expanded(
                child: Text('Los ciprese, Huacho')
              )
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.beenhere, size: 18,),
              SizedBox(width: 3),
              Expanded(
                child: Text('Huaurochirī #1782, Lima'),
              )
            ],
          ),
        ],
      ),
      onTap: (){},
    );
  }
}