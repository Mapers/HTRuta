import 'package:cloud_firestore/cloud_firestore.dart';

class DriverFirestoreService{
  DriverFirestoreService._privateConstructor();
  static final DriverFirestoreService _instance = DriverFirestoreService._privateConstructor();
  factory DriverFirestoreService() => _instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //  Stream<QuerySnapshot> getUsers(String uid) => _db.collection("users").where("contactos", arrayContains: uid).snapshots(); 
  Future<String> updateDriverAvailability(String status, double latitud, double longitud, String fcm_token, String path) async {
    DocumentReference ref = _db.collection('taxis_in_service').doc(path);
    await ref.set({
      'current_location' : GeoPoint(latitud, longitud),
      'fcm_token': fcm_token,
      'status': status,
    }).catchError((onError) => print(onError));
    return ref.id;
  }
  Future<String> updateDriverPosition(double latitud, double longitud, String path) async {
    DocumentReference ref = _db.collection('taxis_in_service').doc(path);
    await ref.update({
      'current_location' : GeoPoint(latitud, longitud),
    }).catchError((onError) => print(onError));
    return ref.id;
  }
}