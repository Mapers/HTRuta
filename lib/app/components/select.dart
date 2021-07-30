import 'package:flutter/material.dart';

class Select<V> extends StatelessWidget {
  final List<DropdownMenuItem<V>> items;
  final V value;
  final Function(V) onChanged;
  final bool showPlaceholder;
  final String placeholder;
  final bool placeholderIsSelected;

  const Select({
    Key key,
    @required this.items,
    @required this.value,
    @required this.onChanged,
    this.placeholder = 'Seleccione',
    this.placeholderIsSelected = true,
    this.showPlaceholder = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(showPlaceholder){
      items.insert(0, DropdownMenuItem<V>(
        child: Text('- ' + placeholder +' -', style: TextStyle(fontSize: 14, color: Colors.black54)),
        value: null,
      ));
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton<V>(
        items: items,
        value: value,
        onChanged: (val){
          if(!placeholderIsSelected && val == null){
            return;
          }
          onChanged(val);
        },
        icon: Icon(Icons.arrow_drop_down),
      )
    );
  }
}