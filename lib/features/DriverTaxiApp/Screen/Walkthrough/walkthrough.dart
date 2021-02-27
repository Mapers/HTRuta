import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class WalkthroughScreen extends StatelessWidget {
  final ItemsListBuilder itemsListBuilder =ItemsListBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: itemsListBuilder.itemList.length,
          child:WalkthroughScreen2Build(
            itemList: itemsListBuilder.itemList,
          )
      ),
    );
  }
}

class WalkthroughScreen2Build extends StatelessWidget {
  final List<Items> itemList;
  BuildContext context;

  WalkthroughScreen2Build({this.itemList});
  void _onPressed() {
    Navigator.of(context).pushNamedAndRemoveUntil('/use_my_location', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    this.context = context;
    final TabController controller = DefaultTabController.of(context);
    return Container(
        color: whiteColor,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child:TabBarView(
                    children: itemList.map((Items item) {
                      return Column(
                        key:ObjectKey(item),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Image.asset(item.image,height: 180.0)
                          ),
                          Text(item.pageNo, style: heading35Black),
                          Container(
                            padding:EdgeInsets.only(left: 60.0, right: 60.0),
                            child:Text(
                              item.description,
                              style: textBoldBlack,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ButtonTheme(
                            minWidth: screenSize.width*0.43,
                            height: 45.0,
                            child: RaisedButton(
                              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0)),
                              elevation: 0.0,
                              color: primaryColor,
                              child:Text(item.btnDescription,style: headingWhite,
                              ),
                              onPressed: _onPressed,
                            ),
                          ),
                        ],
                      );
                    }).toList())),
          Container(
              margin:EdgeInsets.only(bottom: 32.0),
              child:TabPageSelector(
                controller: controller,
                selectedColor: primaryColor,
              ),
            )
          ],
        )
    );
  }
}