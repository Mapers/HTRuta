import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
class AvailableRoutesPage extends StatefulWidget {
  AvailableRoutesPage({Key key}) : super(key: key);

  @override
  _AvailableRoutesPageState createState() => _AvailableRoutesPageState();
}

class _AvailableRoutesPageState extends State<AvailableRoutesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas disponibles'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('data'),
                  Icon(Icons.arrow_forward_sharp),
                  Text('data'),
                ],
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return CardAvailiblesRoutes();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardAvailiblesRoutes extends StatelessWidget {
  const CardAvailiblesRoutes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: (){
          print('hello world');
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Huacho-Chancay-Lima',style: textStyleHeading18Black ,),
                  Text('S/. 430'),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color:Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('En Paradero',style: TextStyle(color: Colors.white),),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Text('Av.San martin N°123 '),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.directions_bus_rounded),
                  Text('Jose Carlos del sol'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time),
                  Text('02:30 PM'),
                  Icon(Icons.calendar_today),
                  Text('28/02/2021'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}