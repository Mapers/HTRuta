import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
class InputMapSelecction extends StatelessWidget {
  final double top;
  final Function onTap;
  final String labelText;
  final TextEditingController controller;
  final IconData suffixIcon;
  final String region;
  final String province;
  final String district;
  final String street;
  final bool isRequired;
  final String Function(String) validator;

  const InputMapSelecction({
    Key key,
    this.top,
    this.labelText,
    this.onTap,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.region,
    this.province,
    this.district,
    this.street,
    this.isRequired
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: 15,
      left: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1, 5),
                  blurRadius: 10,
                  spreadRadius: 3
                )
              ],
            ),
            child: InkWell(
              onTap: onTap,
              child: TextFormField(
                enabled: false,
                controller: controller,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: Icon(suffixIcon, color: primaryColor,),
                  labelText:labelText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, top: 5),
                ),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
            child: Row(
              children: [
                Text(province, style: TextStyle(color: Colors.grey), ),
                district == ''?Container() : Text( ' - '+ district, style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}