import 'package:flutter/material.dart';


class PrincipalInput extends StatelessWidget {
  final IconData icon;
  final String hinText;
  final void Function(String) onSaved;
  final void Function(String) onChanged;
  final String Function(String) validator;
  final void Function(String) onFieldSubmitted;
  final String initialValue;
  final bool isRequired;
  final int maxLines;
  const PrincipalInput({Key key, this.hinText, this.icon, this.onSaved, this.onChanged, this.validator, this.onFieldSubmitted, this.initialValue, this.isRequired, this.maxLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5 ),
      width: size.width,
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(icon),
          // labelText: "Nombre",
          hintText: hinText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        maxLines: this.maxLines,
        onSaved: this.onSaved,
        onChanged: this.onChanged,
        onFieldSubmitted: this.onFieldSubmitted,
        initialValue: this.initialValue,
        validator: (String _text){
          if(this.isRequired && _text.isEmpty){
            return "Requerido.";
          }
          if(this.validator != null){
            return this.validator(_text);
          }
          return null;
        }
      ),
    );
  }
}