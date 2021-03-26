import 'package:HTRuta/app/components/principal_button.dart';
import 'package:HTRuta/app/components/principal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class QualificationWidget extends StatefulWidget {
  final String title;
  final String nameUserQuelify;
  final String routeTraveled;
  final Function(double start,String commentary) onAccepted;
  final Function onSkip;
  const QualificationWidget({Key key, @required this.title, @required this.nameUserQuelify, @required this.routeTraveled, @required this.onAccepted, @required this.onSkip}) : super(key: key);

  @override
  _QualificationWidgetState createState() => _QualificationWidgetState();
}

class _QualificationWidgetState extends State<QualificationWidget> {
  final formKey = GlobalKey<FormState>();
  String commenctary;
  double numberStart = 0;
  @override
  Widget build(BuildContext context) {
    return  Form(
      key: formKey ,
      child: AlertDialog(
        title: Text(widget.title),
        content: Container(
          height: 180,
          child: SingleChildScrollView(
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
                PrincipalInput(
                  hinText: 'Comentario',
                  onSaved: (val) => commenctary = val,
                )
              ],
            ),
          ),
        ),
        actions: [
          PrincipalButton(
            color: Colors.red,
            width: 100,
            text: 'Omitir',
            onPressed: (){
              widget.onSkip();
              Navigator.of(context).pop();
            }
          ),
          PrincipalButton(
            width: 100,
            text: 'Enviar',
            onPressed: (){
              formKey.currentState.save();
              widget.onAccepted(numberStart,commenctary);
              Navigator.of(context).pop();
            }
          )
        ],
      ),
    );
  }
}