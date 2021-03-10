import 'package:flutter/material.dart';

class PickSeatPage extends StatefulWidget {
  PickSeatPage({Key key}) : super(key: key);

  @override
  _PickSeatPageState createState() => _PickSeatPageState();
}

class _PickSeatPageState extends State<PickSeatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escoga sus asientos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                spacing: 10,
                children: [
                  Chip(
                    padding: EdgeInsets.zero,
                    label: Text('Conductor'),
                    backgroundColor: Colors.blue[200]
                  ),
                  Chip(
                    padding: EdgeInsets.zero,
                    label: Text('Libre', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.green
                  ),
                  Chip(
                    padding: EdgeInsets.zero,
                    label: Text('Ocupado'),
                    backgroundColor: Colors.grey[400]
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 320,
                  child: Table(
                    defaultColumnWidth: FlexColumnWidth(2),
                    columnWidths: {
                      2: FlexColumnWidth(1)
                    },
                    children: [
                      TableRow(
                        children: [
                          getDriverSeat(),
                          getNotSeat(),
                          getRoad(),
                          getSeat()
                        ]
                      ),
                      TableRow(
                        children: [
                          getSeat(),
                          getSeat(),
                          getRoad(),
                          getSeat(isOccupied: true),
                        ]
                      ),
                      TableRow(
                        children: [
                          getSeat(isOccupied: true),
                          getSeat(isOccupied: true),
                          getRoad(),
                          getSeat(),
                        ]
                      ),
                      TableRow(
                        children: [
                          getSeat(),
                          getSeat(),
                          getRoad(),
                          getSeat(),
                        ]
                      ),
                      TableRow(
                        children: [
                          getSeat(),
                          getSeat(),
                          getRoad(),
                          getSeat(),
                        ]
                      ),
                    ]
                  )
                ),
              )
            ]
          )
        ),
      ),
    );
  }

  TableCell getDriverSeat(){
    return TableCell(
      child: Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue[200]
        ),
      )
    );
  }

  TableCell getNotSeat() => TableCell(child: Container());
  TableCell getRoad() => TableCell(child: Container());

  TableCell getSeat({bool isOccupied = false}){
    Color borderColor = Colors.green;
    Color colorBackground = Colors.green[200];
    if(isOccupied){
      borderColor = Colors.grey;
      colorBackground = Colors.grey[400];
    }
    return TableCell(
      child: Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: borderColor
          ),
          borderRadius: BorderRadius.circular(5),
          color: colorBackground
        ),
        child: isOccupied ? Center(
          child: Icon(Icons.person, size: 33, color: Colors.white)
        ) : null,
      ),
    );
  }
}