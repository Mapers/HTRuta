import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterprovincialClientDataLocal {
  final SharedPreferences sharedPreferences;
  InterprovincialClientDataLocal({@required this.sharedPreferences});

  Future<bool> saveDocumentIdOnServiceInterprovincial(String documentId) async{
    try {
      return await sharedPreferences.setString('CLIENTE_ON_INTERPROVINCIAL_DOCUMENT_ID', documentId);
    } catch (e) {
      return false;
    }
  }

  String get getDocumentIdOnServiceInterprovincialToQualification => sharedPreferences.getString('CLIENTE_ON_INTERPROVINCIAL_DOCUMENT_ID');
  Future<bool> get deleteDocumentIdOnServiceInterprovincialToQualification async => await sharedPreferences.remove('CLIENTE_ON_INTERPROVINCIAL_DOCUMENT_ID');

}