import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';

class ItemRequest extends StatelessWidget {
  @required final String avatar;
  @required final String userName;
  @required final String date;
  @required final String price;
  @required final String distance;
  @required final String addFrom;
  @required final String addTo;
  @required final VoidCallback onAccept;
  @required final VoidCallback onRefuse;
  final Function(String) onPriceUpdate;
  final LatLng locationForm;
  final LatLng locationTo;

  const ItemRequest({
    Key key,
    this.avatar,
    this.userName,
    this.date,
    this.price,
    this.distance,
    this.addFrom,
    this.addTo,
    this.onAccept,
    this.onRefuse,
    this.onPriceUpdate,
    this.locationForm,
    this.locationTo

}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: (avatar == null || avatar.isEmpty) ? 
                      Image.asset(
                        'assets/image/empty_user_photo.png',
                        width: 50.0,
                        height: 50.0,
                      ):
                      CachedNetworkImage(
                        imageUrl: avatar,
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(userName ?? '',
                          style: textBoldBlack,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(date ?? '',
                          style: textGrey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('${double.parse(price).toStringAsFixed(2)} PEN',style: textBoldBlack,),
                        Text(distance ?? '',style: textGrey,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Recoger'.toUpperCase(),style: textGreyBold,),
                          Text(addFrom ?? '',
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Destino'.toUpperCase(),style: textGreyBold,),
                          Text(addTo ?? '',
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          ),

                        ],
                      ),
                    ),
                  ],
                )
            ),
            /* Padding(
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
              child: ButtonTheme(
                minWidth: screenSize.width ,
                height: 45.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0)),
                  elevation: 0.0,
                  color: primaryColor,
                  child: Text('Aceptar',style: headingWhite,
                  ),
                  onPressed: onTap,
                ),
              ),
            ), */
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    shape:RoundedRectangleBorder(
                      borderRadius:
                        BorderRadius.circular(10.0),
                    ),
                    onPressed: (){
                      double newPrice = double.parse(price);
                      newPrice-=0.5;
                      return onPriceUpdate(newPrice.toStringAsFixed(2));
                    },
                    child: Text('-0.5', style: TextStyle(color:Colors.grey)),
                  ),
                  Text('S/${double.parse(price).toStringAsFixed(2)} PEN',style: TextStyle(fontSize: responsive.ip(2.2), fontWeight: FontWeight.w600),),
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: (){
                      double newPrice = double.parse(price);
                      newPrice+=0.5;
                      return onPriceUpdate(newPrice.toStringAsFixed(2));
                    },
                    child: Text('+0.5',style: TextStyle(color: primaryColor),),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width - 50.0,
                height: MediaQuery.of(context).size.width * 0.1,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  elevation: 0.0,
                  color: Colors.blue.withOpacity(0.8),
                  child: Text('Modificar precio',style: headingWhite,
                  ),
                  onPressed: onAccept
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ButtonTheme(
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 0,
                        color: Colors.redAccent,
                        child: Text('Rechazar',style: headingWhite,
                        ),
                        onPressed: onRefuse
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ButtonTheme(
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 0,
                        color: primaryColor,
                        child: Text('Aceptar',style: headingWhite,
                        ),
                        onPressed: onAccept
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
