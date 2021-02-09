import 'package:flutter/material.dart';
import 'package:flutter_map_booking/DriverTaxiApp/theme/style.dart';
import 'data.dart';

class WalkthroughScreen extends StatelessWidget {
  final ItemsListBuilder itemsListBuilder = new ItemsListBuilder();

  @override
  Widget build(BuildContext context) {
    return (new Scaffold(
      body: new DefaultTabController(
          length: itemsListBuilder.itemList.length,
          child: new WalkthroughScreen2Build(
            itemList: itemsListBuilder.itemList,
          )
      ),
    ));
  }
}

class WalkthroughScreen2Build extends StatelessWidget {
  final List<Items> itemList;
  BuildContext context;

  WalkthroughScreen2Build({this.itemList});
  _onPressed() {
    Navigator.of(context).pushNamedAndRemoveUntil('/use_my_location', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    this.context = context;
    final TabController controller = DefaultTabController.of(context);
    return new Container(
        color: whiteColor,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
                child: new TabBarView(
                    children: itemList.map((Items item) {
                      return new Column(
                        key: new ObjectKey(item),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Image.asset(item.image,height: 180.0,)),
                              new Text(item.pageNo, style: heading35Black,
                          ),
                          new Container(
                            padding: new EdgeInsets.only(left: 60.0, right: 60.0),
                            child: new Text(
                              item.description,
                              style: textBoldBlack,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ButtonTheme(
                            minWidth: screenSize.width*0.43,
                            height: 45.0,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                              elevation: 0.0,
                              color: primaryColor,
                              child: new Text(item.btnDescription,style: headingWhite,
                              ),
                              onPressed: _onPressed,
                            ),
                          ),
                        ],
                      );
                    }).toList())),
            new Container(
              margin: new EdgeInsets.only(bottom: 32.0),
              child: new TabPageSelector(
                controller: controller,
                selectedColor: primaryColor,
              ),
            )
          ],
        )
    );
  }
}