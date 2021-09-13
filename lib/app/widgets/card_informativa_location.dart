import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/material.dart';

class CardInformationLocation extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final LocationEntity location;
  const CardInformationLocation({Key key, this.location, this.icon, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationComplement(title: 'Región: ',subTitle: location.regionName,),
                  LocationComplement(title: 'Provincia: ',subTitle: location.provinceName,),
                  LocationComplement(title: 'Distrito: ',subTitle: location.districtName,),
                  LocationComplement(title: 'Calle: ',subTitle: location.streetName,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class LocationComplement extends StatelessWidget {
  final String title;
  final String subTitle;
  const LocationComplement({Key key, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
        Expanded(
          child: Container(
            width: 200,
            child: Text(subTitle, style: TextStyle(color: Colors.black87, fontSize: 14))
          ),
        ),
      ],
    );
  }
}