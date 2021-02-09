import 'package:flutter/material.dart';
import 'package:HTRuta/DriverTaxiApp/data/Model/mapTypeModel.dart';

class MapTypeItem extends StatelessWidget {
  final MapTypeModel _item;
  MapTypeItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 70.0,
            width: 70.0,
            decoration: new BoxDecoration(
              border: new Border.all(
                  width: 3.0,
                  color: _item.isSelected
                      ? Colors.blueAccent
                      : Colors.white),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
              image: DecorationImage(
                image: AssetImage(
                    _item.image
                ),
                fit: BoxFit.cover
              )
            ),
          ),
          Container(
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

