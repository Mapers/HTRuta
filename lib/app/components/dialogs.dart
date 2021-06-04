import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/app/colors.dart';

class Dialogs{
  static void alert(BuildContext context, {title = '', message= '', VoidCallback onConfirm  }){
    /* showDialog(
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
    ); */
    AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      width: MediaQuery.of(context).size.width * 0.8,
      headerAnimationLoop: true,
      dialogType: DialogType.INFO,
      title: title,
      desc: message,
      btnOkOnPress: onConfirm,
      btnOkIcon: Icons.check_circle,
      onDissmissCallback: () {
        debugPrint('Dialog Dissmiss from callback');
      })
    ..show();
  }

  static void confirm(BuildContext context, {title = '', message= '', VoidCallback onCancel, VoidCallback onConfirm, String textoConfirmar='Ok', String textoCancelar = 'Cancelar'}){
    /* showDialog(
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
    ); */
    AwesomeDialog(
      context: context,
      borderSide: BorderSide(color: primaryColor, width: 2),
      width: MediaQuery.of(context).size.width * 0.8,
      dialogType: DialogType.INFO,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: true,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: message,
      btnOkText: 'Ok',
      btnCancelText: 'Cancel',
      showCloseIcon: true,
      btnCancelOnPress: onCancel,
      btnOkOnPress: onConfirm,
    )..show();
  }
  static void success(BuildContext context, {title = '', message= '', VoidCallback onCancel, VoidCallback onConfirm, String textoConfirmar='Ok', String textoCancelar = 'Cancelar'}){
    /* showDialog(
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
    ); */
    AwesomeDialog(
      context: context,
      borderSide: BorderSide(color: primaryColor, width: 2),
      width: MediaQuery.of(context).size.width * 0.8,
      dialogType: DialogType.SUCCES,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: true,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: message,
      btnOkText: 'Ok',
      btnCancelText: 'Cancel',
      showCloseIcon: true,
      btnCancelOnPress: onCancel,
      btnOkOnPress: onConfirm,
    )..show();
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
            title: Text('Espere por favor...',style: TextStyle(fontSize: responsive.ip(1.6)),),
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