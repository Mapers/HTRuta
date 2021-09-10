import 'package:HTRuta/entities/location_entity.dart';
import 'package:flutter/material.dart';

class MettingDriveAndPassenger extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final LocationEntity location;
  final bool isSelecter;
  final Function onTap;
  const MettingDriveAndPassenger({Key key, this.location, this.icon, this.iconColor, this.isSelecter, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelecter? Colors.amber : Colors.grey
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, color: isSelecter? Colors.amber : Colors.grey,),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationComplement(title: 'Región: ',subTitle: location.regionName,),
                  LocationComplement(title: 'Provincia: ',subTitle: location.provinceName,),
                  LocationComplement(title: 'Distrito: ',subTitle: location.districtName,),
                  LocationComplement(title: 'Calle: ',subTitle: location.streetName,),
                ],
              )
            ],
          ),
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
        Container(
          width: 200,
          child: Text(subTitle, style: TextStyle(color: Colors.black87, fontSize: 14))
        ),
      ],
    );
  }
}