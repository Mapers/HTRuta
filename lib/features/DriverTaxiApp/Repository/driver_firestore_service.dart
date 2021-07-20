import 'package:cloud_firestore/cloud_firestore.dart';

class DriverFirestoreService{
  DriverFirestoreService._privateConstructor();
  static final DriverFirestoreService _instance = DriverFirestoreService._privateConstructor();
  factory DriverFirestoreService() => _instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> setDriverData(String fcm_token, String path, String status, double latitud, double longitud) async {
    DocumentReference ref = _db.collection('taxis_in_service').doc(path);
    await ref.set({
      'fcm_token': fcm_token,
      'available': true,
      'posicion': GeoPoint(latitud, longitud),
      'status': status,
    }).catchError((onError) => print(onError));
    return ref.id;
  }
  Future<String> updateDriverAvalability(bool avaliability, String path) async {
    DocumentReference ref = _db.collection('taxis_in_service').doc(path);
    await ref.update({
      'available': avaliability,
    }).catchError((onError) => {
      ref.set({
        'available': avaliability,
      })
    });
    return ref.id;
  }
  Future<String> updateDriverPosition(double latitud, double longitud, String path) async {
    DocumentReference ref = _db.collection('taxis_in_service').doc(path);
    try{
      await ref.update({
        'posicion': GeoPoint(latitud, longitud),
      });
    }catch(e){
      print(e);
    }
    return ref.id;
  }
  Future<List<String>> getDrivers() async {
    CollectionReference ref = _db.collection('taxis_in_service');
    QuerySnapshot snapshot  = await ref.get();
    List<String> tokens = [];
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    if(documents.isEmpty) return tokens;
    documents.forEach((QueryDocumentSnapshot element) {
      Map queryData = element.data();
      if(queryData['status'] == 'Aprobado'){
        tokens.add(queryData['fcm_token']);
      }
    });
    return tokens;
  }

  Stream<QuerySnapshot> getDriversStream() => _db.collection('taxis_in_service').where('available', isEqualTo: true).snapshots(); 
}