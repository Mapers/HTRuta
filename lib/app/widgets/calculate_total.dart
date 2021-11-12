import 'package:flutter/material.dart';
class CalculateTotal extends StatefulWidget {
  final int seating;
  final double price;
  CalculateTotal({Key key,@required this.seating,@required this.price}) : super(key: key);

  @override
  _CalculateTotalState createState() => _CalculateTotalState();
}

class _CalculateTotalState extends State<CalculateTotal> {
  double amountTotal;
  @override
  void initState() {
    amountTotal = widget.price * widget.seating;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Monto total a pagar : PEN '+ amountTotal.toStringAsFixed(2) ,style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
}