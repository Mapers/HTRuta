import 'package:flutter/material.dart';

class ComentsWirdgets extends StatefulWidget {
  ComentsWirdgets({Key key}) : super(key: key);

  @override
  _ComentsWirdgetsState createState() => _ComentsWirdgetsState();
}

class _ComentsWirdgetsState extends State<ComentsWirdgets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title:Text('Calificaciones del Chofer'),
        content: Container(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('SaraMedina Perez',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text('21/02/2020',style: TextStyle(fontSize: 15,color: Colors.grey )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Ecxelente conductor',style: TextStyle(fontSize: 15),),
              ),
              Row(
                children: [
                  Text('SaraMedina Perez',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text('21/02/2020',style: TextStyle(fontSize: 15,color: Colors.grey )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Ecxelente conductor',style: TextStyle(fontSize: 15),),
              ),
              Row(
                children: [
                  Text('SaraMedina Perez',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text('21/02/2020',style: TextStyle(fontSize: 15,color: Colors.grey )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Ecxelente conductor',style: TextStyle(fontSize: 15),),
              ),
             
            ],
          ),
        ),
        actions: [],
      ),
    );
  }
}