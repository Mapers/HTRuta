import 'package:HTRuta/app/components/principal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class QualificationWidgets extends StatefulWidget {
  final String title;
  final String nameUserQuelify;
  final String routeTraveled;
  final Function(double start) accepted;
  const QualificationWidgets({Key key,@required this.title,@required this.nameUserQuelify,@required this.routeTraveled,@required this.accepted}) : super(key: key);

  @override
  _QualificationWidgetsState createState() => _QualificationWidgetsState();
}

class _QualificationWidgetsState extends State<QualificationWidgets> {
  double numberStart = 0;
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text(widget.title),
      content: Container(
        height: 100,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.person ),
                Text(widget.nameUserQuelify)
              ],
            ),
            SizedBox(height: 10,),
            Text(widget.routeTraveled,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
            RatingBar.builder(
              initialRating: 0,
              allowHalfRating: true,
              // itemSize: 18,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate:(val){
                numberStart = val;
              },
            ),
          ],
        ),
      ),
      actions: [
        PrincipalButton(
          color: Colors.red,
          width: 100,
          text: 'omitir',
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
        PrincipalButton(
          width: 100,
          text: 'Eviar',
          onPressed: (){
            widget.accepted(numberStart);
            // Navigator.of(context).pop();
          }
        )
      ],
    );
  }
}