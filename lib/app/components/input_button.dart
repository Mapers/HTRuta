import 'package:flutter/material.dart';


class InputButton extends StatelessWidget {
  final Function onTap;
  final bool enabled;
  final TextEditingController controller;
  final IconData icon;
  final String hinText;
  final void Function(String) onSaved;
  final void Function(String) onChanged;
  final String Function(String) validator;
  final void Function(String) onFieldSubmitted;
  final String initialValue;
  final bool isRequired;
  final int maxLines;
  const InputButton({
    Key key,
    this.hinText,
    this.icon,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.initialValue,
    this.isRequired,
    this.maxLines,
    this.controller,
    this.enabled = true,
    this.onTap
  }) : super(key: key);

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
      child: InkWell(
        onTap: onTap,
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.keyboard_arrow_right),
            icon: Icon(icon),
            // labelText: 'Nombre',
            hintText: hinText,
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          maxLines: maxLines,
          onSaved: onSaved,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          initialValue: initialValue,
          validator: (String _text){
            if(isRequired && _text.isEmpty){
              return 'Requerido.';
            }
            if(validator != null){
              return validator(_text);
            }
            return null;
          }
        ),
      ),
    );
  }
}