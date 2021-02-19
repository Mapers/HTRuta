import 'package:flutter/material.dart';


class PrincipalInput extends StatelessWidget {
  final IconData icon;
  final String hinText;
  const PrincipalInput({Key key, this.hinText, this.icon}) : super(key: key);

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
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(icon),
          // labelText: "Nombre",
          hintText: hinText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}