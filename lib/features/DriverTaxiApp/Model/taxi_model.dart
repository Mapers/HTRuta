import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

class TaxiModel {
  final String id;
  final String userId;
  final String email;
  final DateTime registeredAt;
  final String dni;
  final String names;
  final String phone;
  final double price;
  final String typeTravel;
  final double initialLat;
  final double finalLat;
  final double initialLong;
  final double finalLong;
  final String startName;
  final String finalname;
  final String rejecteds;
  final String accepteds;
  final String queryId;
  final String comentario;
  final String token;
  final String userPhoto;

  TaxiModel({
    @required this.id,
    @required this.userId,
    @required this.email,
    @required this.registeredAt,
    @required this.dni,
    @required this.names,
    @required this.phone,
    @required this.price,
    @required this.typeTravel,
    @required this.initialLat,
    @required this.finalLat,
    @required this.initialLong,
    @required this.finalLong,
    @required this.startName,
    @required this.finalname,
    @required this.rejecteds,
    @required this.accepteds,
    @required this.queryId,
    @required this.comentario,
    @required this.token,
    @required this.userPhoto,
  });

  factory TaxiModel.empty(){
    return TaxiModel(
      token: null,
      id: '1',
      userId: '2',
      email: 'emailtest@email.test',
      registeredAt: DateTime.now().add(Duration(days: -360)),
      dni: '73828337',
      names: 'Jose Carlos',
      phone: '97826481',
      price: 50.5,
      typeTravel: 'Viaje Especial',
      initialLat: 123123,
      initialLong: 14124124,
      finalLong: -123123,
      finalLat: -123123123,
      startName: 'nombre inicial',
      finalname: 'nombre final',
      queryId: '3',
      rejecteds: 'Rechazados :c',
      accepteds: 'Aceptados',
      comentario: '',
      userPhoto: ''
    );
  }

  Future<double> get calculateDistance async{
    return await Geolocator.distanceBetween(initialLat, initialLong, finalLat, finalLong)/1000;
  }
}