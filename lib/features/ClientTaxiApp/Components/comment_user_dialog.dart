import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/save_qualification_body.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/pedido_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CommentUserDialog extends StatefulWidget {
  @override
  _CommentUserDialogState createState() => _CommentUserDialogState();
}

class _CommentUserDialogState extends State<CommentUserDialog> {
  double stars = 3;
  String commentary = '';
  final pickupApi = PickupApi();
  
  @override
  Widget build(BuildContext context) {
    final pedidoProvider = Provider.of<PedidoProvider>(context, listen: false);
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Califica tu viaje'),
          IconButton(
            icon: Icon(Icons.close),
            color: primaryColor,
            onPressed: () async {
              print(pedidoProvider.idViaje);
            },
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      contentPadding: EdgeInsets.all(20),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  stars = rating;
                  setState(() {});
                },
              ),
              Container(height: 5),
              Text(stars.toString(), style: TextStyle(fontSize: 18)),
              Container(height: 20),
              Text('También puedes dejar un comentario'),
              Container(height: 5),
              Container(
                height: 50,
                child: TextFormField(
                  onChanged: (String newValue){
                    commentary = newValue;
                  },
                  decoration: InputDecoration(
                    hintText: 'Tu comentario...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                ),
              ),
              Container(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: MaterialButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Guardar', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    SaveQualificationBody body = SaveQualificationBody(
                      viajeId: int.parse(pedidoProvider.idViaje),
                      stars: stars,
                      comment: commentary
                    );
                    bool success = await pickupApi.sendUserQualification(body);
                    if(!success){
                      Dialogs.alert(context,title: 'Lo sentimos', message: 'No se pudo guardar su calificación');
                      return;
                    }else{
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Container(height: 10),
              FlatButton(
                child: Text('Por ahora no', style: TextStyle(color: Colors.black54)),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}