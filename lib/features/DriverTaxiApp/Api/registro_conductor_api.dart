import 'dart:convert';

import 'package:HTRuta/config.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/response/enviar_documentacion_response.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/documento_rechazado_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/estado_chofer_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/marca_carro_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/modelo_carro_model.dart';
import 'package:http/http.dart' as http;

class RegistroConductorApi{

  Future<List<DataMarca>> obtenerMarca() async{
    final url = '${Config.apiHost}/api_getMarcas.php';
    final response = await http.post(url);
    final responseUsuario = marcaCarroFromJson(response.body);
    if(responseUsuario.success){
      return responseUsuario.data;
    }
    throw ServerException(message: 'Ocurrió un error con el servidor');
  }

  Future<List<DataModelo>> obtenerModelo(String id) async{
    final url = '${Config.apiHost}/api_getModelos.php?id=$id';
    final response = await http.post(url,body: {'id' : id});
    final responseUsuario = modeloCarroFromJson(response.body);
    if(responseUsuario.success){
      return responseUsuario.data;
    }
    throw ServerException(message: 'Ocurrió un error con el servidor');
  }

  Future<DataEstadoChofer> obtenerEstadoChofer(String idChofer) async{
    try{
      final url = '${Config.apiHost}/api_getestadochofer.php';
      final response = await http.post(url,body: {'iIdChofer': idChofer});
      final responseUsuario = estadoChoferFromJson(response.body);
      if(responseUsuario.success){
        return responseUsuario.data[0];
      }else{
        return null;
      }
    }catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<List<Documento>> obtenerDocumentosRechazados() async{
    try{
      final _prefs = UserPreferences();
      await _prefs.initPrefs();
      final url = '${Config.apiHost}/api_getDocumentosRechazados.php';
      final response = await http.post(url,body: {'id' : _prefs.idUsuario});
      final responseUsuario = documentoRechazadoFromJson(response.body);
      if(responseUsuario.success){
        final _prefs = UserPreferences();
        await _prefs.initPrefs();
        _prefs.idChofer = responseUsuario.data[0].iIdUsuario.toString();
        return responseUsuario.data;
      }else{
        return null;
      }
    }catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor');
    }
  }

  Future<bool> actualizarDocumentosRechazados(List<DocumentoResponse> documentos) async{
    try{
      

      Uri url = Uri.parse('${Config.nuevaRutaApi}/actualizar-archivos');
      final imageUpload = http.MultipartRequest('POST', url);
      final _prefs = UserPreferences();
      await _prefs.initPrefs();
      final DocumentoRechazadoResponse data = DocumentoRechazadoResponse(documentos: documentos);
      imageUpload.fields['idusuario'] = _prefs.idChofer;
      imageUpload.fields['documentos'] = json.encode(data.documentos);

      final streamedResponse = await imageUpload.send();
      final response = await http.Response.fromStream(streamedResponse);
      

      final responseUsuario = estadoChoferFromJson(response.body);

      if(responseUsuario.success){
        return true;
      }else{
        return false;
      }
    }catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor ${error.toString()}');
    }
  }

  Future<bool> registrarChofer(String dni, String nombre, String apellidoP, String apellidoM, String fecNac, String sexo, String direccion, String referencia, String telefono, String celular, String correo, String password, String tipoDispositivo, String marca,String vchNombreD, String imei, String tokenD, String placa, String modelo, String pasajeros, String anio, String nuevo, String docDni,String docFotoRostro, String docFotoAuto, String docAntecedentes, String docLicencia) async{
    try{
      // final url = '${Config.nuevaRutaApi}/registro-chofer';
      // final response = await http.post(url,body: {'Dni' : dni,'Nombre' : nombre,'ApellidoP' : apellidoP,'ApellidoM' : apellidoM,'FecNac' : fecNac,'Sexo' : sexo,'Dirección' : direccion,'Referencia' : referencia,'Telefono' : telefono,'Celular' : celular,'Correo' : correo,'Password' : password,'iTipoDispositivo' : tipoDispositivo,'iMarca' : marca,'vchNombreD' : vchNombreD,'Imei' : imei,'TokenD' : tokenD,'placa' : placa,'modelo' : modelo,'pasajeros' : pasajeros,'año' : anio,'nuevo' : nuevo,'docDNI' : docDni,'docFotoRostro' : docFotoRostro,'docFotoAuto' : docFotoAuto,'docAntecedentes' : docAntecedentes,'docLicencia' : docLicencia}); 
      // final responseUsuario = estadoChoferFromJson(response.body);

      Uri url = Uri.parse('${Config.nuevaRutaApi}/registro-chofer');
      final imageUpload = http.MultipartRequest('POST', url);

      // final fileDNI =  http.MultipartFile.fromBytes('docDNI', docDni,filename: 'docDni');
      // imageUpload.files.add(fileDNI);
      // final fileRostro = http.MultipartFile.fromBytes('docFotoRostro', docFotoRostro,filename: 'docFotoRostro');
      // imageUpload.files.add(fileRostro);
      // final fileAuto =  http.MultipartFile.fromBytes('docFotoAuto', docFotoAuto, filename: 'docFotoAuto');
      // imageUpload.files.add(fileAuto);
      // final fileAntecedentes =  http.MultipartFile.fromBytes('docAntecedentes', docAntecedentes, filename: 'docAntecedentes');
      // imageUpload.files.add(fileAntecedentes);
      // final fileLicencia =  http.MultipartFile.fromBytes('docLicencia', docLicencia,filename: 'docLicencia');
      // imageUpload.files.add(fileLicencia);
      //imageUpload.fields.addAll({'Dni' : dni,'Nombre' : nombre,'ApellidoP' : apellidoP,'ApellidoM' : apellidoM,'FecNac' : fecNac,'Sexo' : sexo,'Dirección' : direccion,'Referencia' : referencia,'Telefono' : telefono,'Celular' : celular,'Correo' : correo,'Password' : password,'iTipoDispositivo' : tipoDispositivo,'iMarca' : marca,'vchNombreD' : vchNombreD,'Imei' : imei,'TokenD' : tokenD,'placa' : placa,'modelo' : modelo,'pasajeros' : pasajeros,'año' : anio,'nuevo' : nuevo,'docDNI' : '','docFotoRostro' : '','docFotoAuto' : '','docAntecedentes' : '','docLicencia' : ''});
      imageUpload.fields['Dni'] = dni;
      imageUpload.fields['Nombre'] = nombre;
      imageUpload.fields['ApellidoP'] = apellidoP;
      imageUpload.fields['ApellidoM'] = apellidoM;
      imageUpload.fields['FecNac'] = fecNac;
      imageUpload.fields['Sexo'] = sexo;
      imageUpload.fields['Dirección'] = direccion;
      imageUpload.fields['Referencia'] = referencia;
      imageUpload.fields['Telefono'] = celular;
      imageUpload.fields['Celular'] = celular;
      imageUpload.fields['Correo'] = correo;
      imageUpload.fields['Password'] = password;
      imageUpload.fields['iTipoDispositivo'] = tipoDispositivo;
      imageUpload.fields['iMarca'] = marca;
      imageUpload.fields['vchNombreD'] = vchNombreD;
      imageUpload.fields['Imei'] = imei;
      imageUpload.fields['TokenD'] = tokenD;
      imageUpload.fields['placa'] = placa;
      imageUpload.fields['modelo'] = modelo;
      imageUpload.fields['pasajeros'] = pasajeros;
      imageUpload.fields['año'] = anio;
      imageUpload.fields['nuevo'] = nuevo;
      imageUpload.fields['docDNI'] = docDni;
      imageUpload.fields['docFotoRostro'] = docFotoRostro;
      imageUpload.fields['docFotoAuto'] = docFotoAuto;
      imageUpload.fields['docAntecedentes'] = docAntecedentes;
      imageUpload.fields['docLicencia'] = docLicencia;


      final streamedResponse = await imageUpload.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseUsuario = estadoChoferFromJson(response.body);

      if(responseUsuario.success){
        return true;
      }else{
        return false;
      }
    }catch(error){
      throw ServerException(message: 'Ocurrió un error con el servidor ${error.toString()}');
    }
  }
}