import 'package:flutter/material.dart';
class InputMap extends StatelessWidget {
  final double top;
  final FocusNode focus;
  final bool inputSelecter;
  final String labelText;
  final TextEditingController controller;
  const InputMap({Key key, this.top, this.inputSelecter, this.labelText, this.controller, this.focus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      right: 15,
      left: 15,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 5),
              blurRadius: 10,
              spreadRadius: 3)
          ],
        ),
        child: TextField(
          focusNode: focus,
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon:  inputSelecter ?Icon(Icons.radio_button_checked):null,
            labelText:labelText ,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15,),
          ),
        ),
      ),
    );
  }
}