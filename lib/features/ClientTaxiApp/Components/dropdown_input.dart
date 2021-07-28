import 'package:flutter/material.dart';


// ignore: must_be_immutable
class DropdownInput extends StatelessWidget {
  String value;
  List<String> items;
  String hintText;
  Function(String) onSelection;
  DropdownInput({this.value, this.items, this.hintText, this.onSelection});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey)
      ),
      child: Center(
        child: DropdownButtonFormField(
          value: value,
          items: getDropDownList(),
          icon: Icon(Icons.keyboard_arrow_down),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            enabledBorder: InputBorder.none,
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(vertical: 5),
          ),
          onChanged: (item) => onSelection(item),
        ),
      )
    );
  }
  List getDropDownList(){
    List<DropdownMenuItem<String>> list = [];
    items.forEach((orientation) {
      DropdownMenuItem<String> item = DropdownMenuItem(
        value: orientation,
        child: Text('$orientation',
        ),
      );
      list.add(item);
    });
    return list;
  }
}