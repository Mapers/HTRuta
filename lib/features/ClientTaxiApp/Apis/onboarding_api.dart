import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:http/http.dart' as http;

class OnBoardingApi{

  Future<Onboarding> getOnBoardingData()async{
    final url = '${Config.nuevaRutaApi}/obtener-pantallas';
    try{
      final response = await http.get(url);
      final responseData = onboardingFromJson(response.body);
      if(!responseData.success){
        return responseData;
      }else{
        return null;
      }
    }catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
}