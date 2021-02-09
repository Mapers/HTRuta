import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map_booking/DriverTaxiApp/theme/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentMethodDriver extends StatefulWidget {
  @override
  _PaymentMethodDriverState createState() => _PaymentMethodDriverState();
}

class _PaymentMethodDriverState extends State<PaymentMethodDriver> {
  final String screenName = "MY WALLET";

  List<Map<String, dynamic>> listService = [
    {"id": '0',"name" : 'VISA',"numberCard" : "**** **** **** 1234","image" : "assets/image/icon/visa-pay-logo.png",},
    {"id": '1',"name" : 'Paypal',"numberCard" : "1234 5678 9123 4569", "image": "assets/image/icon/paypal.png"},
    {"id": '2',"name" : 'Master Card',"numberCard" : "1234 5678 9123 4569","image": "assets/image/icon/master-card.png"},
  ];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Metodo de pago',style: TextStyle(color: blackColor),),
        backgroundColor: whiteColor,
        elevation: 1.0,
        iconTheme: IconThemeData(color: blackColor),

      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        color: greyColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0,right: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x88999999),
                        offset: Offset(0, 5),
                        blurRadius: 5.0,
                      ),
                    ]),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(FontAwesomeIcons.wallet,color: blackColor,),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text("Agregar nueva tarjeta",style: textBoldBlack,)
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_forward_ios,color: blackColor,),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30.0,bottom: 10.0),
              child: Text('Tarjetas de crédito',style: textStyle,),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: listService.length,
                  itemBuilder: (BuildContext context, index){
                    return creditCard(listService[index]['image'],listService[index]['numberCard'],listService[index]['name']);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget creditCard(String image, String numberCard, String nameCard){
    return Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0,right: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
//          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color(0x88999999),
              offset: Offset(0, 5),
              blurRadius: 5.0,
            ),
          ]),
      child: Row(
        children: <Widget>[
          Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                color: greyColor2,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                image: DecorationImage(
                  image: AssetImage(image),
                )
              ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(numberCard,style: textBoldBlack,),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                Text(nameCard,style: textGrey,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
