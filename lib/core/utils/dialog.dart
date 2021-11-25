import 'package:HTRuta/app/components/dialogs.dart';
import 'package:flutter/material.dart';

void showDialogUtil(context, {@required String title, @required String content, Function onClose}) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          FlatButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
              if(onClose != null){
                onClose();
              }
            },
          ),
        ],
      );
    },
  );
}

void showDialogOpcion(context, {@required  String title, @required String content, String acceptTextButton='Aceptar', @required Function aceptar, bool closeOnAccept=true}) {
  // flutter defined function
  bool isAccept = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
            FlatButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(acceptTextButton),
            onPressed: () async{
              if(!isAccept){
                isAccept = true;
                aceptar();
                if(closeOnAccept){
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
      );
    },
  );
}

void showDialogCustomOneOption(context, {@required  String title, @required String content, String acceptTextButton='Aceptar', @required Function aceptar, bool closeOnAccept=true}) {
  // flutter defined function
  bool isAccept = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(acceptTextButton),
            onPressed: () async{
              if(!isAccept){
                isAccept = true;
                aceptar();
                if(closeOnAccept){
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
      );
    },
  );
}

void openLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: ListTile(
          leading: CircularProgressIndicator(),
          title: Text('Espere por favor...'),
        ),
      );
    },
  );
}
void lodingProcessDialog({BuildContext context,String text}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: ListTile(
          title: Text(text),
        ),
      );
    },
  );
}

void openLoadingDialogWithText(BuildContext context,String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: ListTile(
          leading: CircularProgressIndicator(),
          title: Text(message),
        ),
      );
    },
  );
}

/// Returns null on cancel or error.
Future<int> showDialogInputNumber({@required BuildContext context, @required String title, int initialValue, String confirmText = 'Aceptar', String cancelText = 'Cancelar'}) async{
  TextEditingController textEditingController = TextEditingController();
  if(initialValue != null){
    textEditingController.text = initialValue.toString();
  }
  await showDialog(
    context: context,
    child: AlertDialog(
      title: Text(title),
      content: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.number,
      ),
      actions: [
        OutlineButton(
          child: Text(cancelText),
          onPressed: (){
            textEditingController.text = '-';
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text(confirmText),
          onPressed: (){
            String numAsientosStr = textEditingController.text;
            int numAsientosint = int.tryParse(numAsientosStr); 
            if(numAsientosint == null){
              Dialogs.alert(
                context,
                title: 'Atención',
                message: 'Escriba un número'
              );
              return;
              
            }
            if(numAsientosint < 0 || numAsientosint > 60){
              Dialogs.alert(
                context,
                title: 'Atención',
                message: 'Escriba un número entre 0 y 60'
              );
              return;
            }
            Navigator.of(context).pop();
          },
        )
      ],
    )
  );
  try {
    return int.parse(textEditingController.text);
  } catch (e) {
    return null;
  }
}
