import 'package:HTRuta/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:HTRuta/ClientTaxiApp/utils/exceptions.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';

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