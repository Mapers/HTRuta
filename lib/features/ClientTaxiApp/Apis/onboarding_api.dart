import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:http/http.dart' as http;

import '../../../config.dart';

class OnBoardingApi{

  Future<Onboarding> getOnBoardingData()async{
    final url = '${Config.nuevaRutaApi}/obtener-pantallas';
    try{
      final response = await http.get(url);
      print('response.body');
      print(response.body);
      final responseData = onboardingFromJson(response.body);
      if(!responseData.success){
        return responseData;
      }else{
        return null;
      }
    }catch(error){
      print('error.toString()');
      print(error.toString());
      print('------------');
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }
}