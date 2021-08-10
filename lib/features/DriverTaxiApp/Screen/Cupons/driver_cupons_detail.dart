import 'package:flutter/material.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/driver_cupons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DriverCuponsDetail extends StatelessWidget {
  final DriverCuponsModel cupon;
  DriverCuponsDetail(this.cupon);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        width: mqWidth(context, 100),
        height: mqHeigth(context, 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: mqWidth(context, 50),
              height: mqWidth(context, 50),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/turuta-757ba.appspot.com/o/logosplash.png?alt=media&token=e8968b22-352b-4471-8529-7ee61e7fed68')
                )
              )
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: mqHeigth(context, 5),
                left: mqWidth(context, 10),
                right: mqWidth(context, 10),
              ),
              child: Text(
                'Descuento de 10% en todas tus recargas con VISA', 
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center
              )
            ),
            Container(
              height: mqHeigth(context, 10),
              padding: EdgeInsets.symmetric(horizontal: mqWidth(context, 10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: mqWidth(context, 40),
                    height: mqHeigth(context, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cupon.description, style: TextStyle(color: Colors.white, fontSize: 14)),
                        Text(cupon.availableTime, style: TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    )
                  ),
                  Container(
                    width: mqWidth(context, 35),
                    height: mqHeigth(context, 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                    child: Center(
                      child: Text('APLICAR', style: TextStyle(color: Colors.white))
                    )
                  ),
                ],
              ) 
            ),
            Center(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.white)
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 36)
                ),
              )
            )
            /* Container(
              padding: EdgeInsets.symmetric(horizontal: mqWidth(context, 10)),
              child: Center(
                child: Text('Descuento de 10% en recargas de saldo', style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.center)
              )
            ) */
          ],
        )
      ),
    );
  }
}