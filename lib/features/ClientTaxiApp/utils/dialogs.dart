import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Dialogs{
  static void alert(BuildContext context, {title = '', message= '', VoidCallback onConfirm  }){
    showDialog(
      context: context,
      builder: (context){
        return CupertinoAlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
          content: Text(message, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0)),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        );
      }
    );
  }

  static void confirm(BuildContext context, {title = '', message= '', VoidCallback onCancel, VoidCallback onConfirm, String textoConfirmar='Ok', String textoCancelar = 'Cancelar'}){
    showDialog(
      context: context,
      builder: (context){
        return CupertinoAlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
          content: Text(message, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0)),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: onConfirm,
              child: Text('Ok'),
            ),
            CupertinoDialogAction(
              onPressed: onCancel,
              child: Text('Cancel',style: TextStyle(color: Colors.redAccent),),
            ),
          ],
        );
      }
    );
  }

  static void openLoadingDialog(BuildContext context) {
    final responsive = Responsive(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListTile(
            leading: CircularProgressIndicator(),
            title: Text("Espere por favor...",style: TextStyle(fontSize: responsive.ip(1.6)),),
          ),
        );
      },
    );
  }

  static void openLoadingDialogWithText(BuildContext context,String message) {
    final responsive = Responsive(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListTile(
            leading: CircularProgressIndicator(backgroundColor: Colors.white),
            title: Text(message, style: TextStyle(fontSize: responsive.ip(1.6), color: Colors.white),),
          ),
        );
      },
    );
  }
}