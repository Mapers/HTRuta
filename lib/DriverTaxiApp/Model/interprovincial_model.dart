import 'package:meta/meta.dart';

class InterprovincialModel {
  final String id;
  final String userId;
  final String userUrlPhoto;
  final String userNames;
  final double price;
  final double latitude;
  final double longitude;
  final String currentAddress;
  final String destination;
  final DateTime registeredAt;

  InterprovincialModel({
    @required this.id,
    @required this.userId,
    @required this.userUrlPhoto,
    @required this.userNames,
    @required this.price,
    @required this.registeredAt,
    @required this.latitude,
    @required this.longitude,
    @required this.currentAddress,
    @required this.destination,
  });

  factory InterprovincialModel.empty(){
    return InterprovincialModel(
      id: '1',
      userId: '2',
      userUrlPhoto: 'https://source.unsplash.com/1600x900/?portrait',
      registeredAt: DateTime.now().add(Duration(hours: -4)),
      price: 50.5,
      currentAddress: 'Calle los Cipreses - Huacho',
      destination: 'Trujillo',
      latitude: 123123,
      longitude: 4124124,
      userNames: 'Moisés Alcántara'
    );
  }

}