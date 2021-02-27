import 'dart:convert';
import 'dart:io';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/registro_conductor_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/response/enviar_documentacion_response.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/documento_rechazado_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_router.dart';


class SendDocumentPage extends StatefulWidget {

  @override
  _SendDocumentPageState createState() => _SendDocumentPageState();
}

class _SendDocumentPageState extends State<SendDocumentPage> {
  final registroConductorApi = RegistroConductorApi();


  List<File> imagenes = List(10);
  List<String> base64Data = List(10);
  Future<List<Documento>> documentos;

  @override
  void initState() { 
    documentos = registroConductorApi.obtenerDocumentosRechazados();
    super.initState();
  }

  Future<void> buscarImagen(int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Añadir una nueva foto'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Seleccionar foto'),
                    onTap: () async {
                      await _openGallery(index);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text('Tomar una foto'),
                    onTap: () async{
                      await cameraImage(index);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future cameraImage(int index) async {
    try{
      var image = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 664, maxWidth: 1268);
      imagenes[index] = File(image.path);
      await _cropImage(index);
      setState(() {});
      Navigator.of(context).pop();
    }catch(error){
      print(error.toString());
    }
  }

  Future _openGallery(int index) async {
    try {
      var picture = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 664, maxWidth: 1268);
      imagenes[index] = File(picture.path);
      print('${imagenes[index]}');
      await _cropImage(index);
      base64Data[index] = await obtenerBase64(imagenes[index]);
      setState(() {});
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  bool recortado = false;

  Future<Null> _cropImage(int index) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imagenes[index].path,
      aspectRatioPresets: [ CropAspectRatioPreset.square ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Recortar',
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true
      ),
      iosUiSettings: IOSUiSettings(title: 'Cropper')
    );
    if (croppedFile != null) {
      imagenes[index] = croppedFile;
      print('${imagenes[index]}');
      setState(() {
        recortado = true;
      });
    }
  }

  Future<String> obtenerBase64(File fileImage)async{
    String base64Image;
    List<int> imageBytes = await fileImage.readAsBytes();
    base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar documentos'),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,), onPressed: (){
          Dialogs.confirm(context,title: 'Advertencia', message: '¿Desea salir de esta pantalla?, se perderá todo lo realizado',onConfirm: (){Navigator.pop(context); Navigator.of(context).pop();}, onCancel: (){Navigator.pop(context);}, textoConfirmar: 'Si', textoCancelar: 'No');
        }),
      ),
      body: FutureBuilder<List<Documento>>(
        future: documentos,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              final documentosRechazados = snapshot.data;
              return Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: responsive.hp(3),bottom: responsive.hp(7)),
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Text(documentosRechazados[index].nombreDocumento, style: TextStyle(fontSize: responsive.ip(2)),),
                            SizedBox(height: responsive.hp(2),),
                            Container(
                              width: responsive.wp(70),
                              height: responsive.hp(20),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: imagenes[index] != null  ? ClipRRect(child: Image.file(imagenes[index], fit: BoxFit.contain)) : Icon(FontAwesomeIcons.userCheck, size: responsive.ip(7),color: Colors.white,),
                            ),
                            SizedBox(height: responsive.hp(1),),
                            OutlineButton(
                              onPressed: ()async{
                                buscarImagen(index);
                              },
                              borderSide: BorderSide(color: primaryColor),
                              child: Text(imagenes[index] != null ? 'Editar' : 'Añadir', style: TextStyle(color: primaryColor),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.wp(5))),
                              padding: EdgeInsets.symmetric(horizontal: responsive.hp(10)),
                            ),
                            SizedBox(height: responsive.hp(2),),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                  bottom: 0,
                  child: Container(
                      color: Colors.white,
                      width: responsive.wp(100),
                      padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5), vertical: responsive.wp(2)),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
                        color: primaryColor,
                        onPressed: () async{
                          try{
                            List<DocumentoResponse> fotosData = [] ;
                            for(int i = 0;i< documentosRechazados.length;i++){
                              if(imagenes[i] != null){
                                fotosData.add(DocumentoResponse(base: base64Data[i],iIdDocumento: documentosRechazados[i].iIdDocumento,iTipoDocumento: documentosRechazados[i].iTipoDocumento));
                              }else{
                                return;
                              }
                            }
                            if(fotosData != null){
                              Dialogs.openLoadingDialog(context);
                              bool respuesta = await registroConductorApi.actualizarDocumentosRechazados(fotosData);
                              Navigator.pop(context);
                              if(respuesta){
                                Dialogs.confirm(context, title: 'Informacion', message: 'Se envio la informacion exitosamente',onConfirm: (){Navigator.pushReplacementNamed(context, AppRoute.homeDriverScreen); });
                              }else{
                                Dialogs.alert(context, title: 'Error', message: 'No se pudo enviar la informacion, volver a intentarlo');
                              }
                            }else{
                              Dialogs.alert(context, title: 'Error', message: 'Debe subir todas las fotos para proceder a enviar la información');
                            }
                            // if () {
                              
                            //   provider.fotoLicenciaFrente = await obtenerBase64(licenciaFrente);
                            //   provider.fotoLicenciaTrasera = await obtenerBase64(licenciaTrasera);
                            //   provider.fotoAtencedente = await obtenerBase64(antecedentes);
                            //   // provider.fotoSoat = await obtenerBase64(soat);
                            //   providerRegistro.index = 7;
                            //   providerRegistro.titulo = 'Confirmacion';
                            //   widget.onAddButtonTapped(providerRegistro.index);
                            // }else if(licencia.isEmpty){
                            //   Dialogs.alert(context, title: 'Error', message: 'Debe ingresar numero de licencia');
                            // }
                            // else{
                            //   Dialogs.alert(context, title: 'Error', message: 'Debe seleccionar fotos');
                            // }
                          }catch(error){
                            Navigator.pop(context);
                            print('Error ${error.toString()}');
                            Dialogs.alert(context, title: 'Error', message: 'Ocurrio un error,vuelva a intentarlo');
                          }
                          
                        },
                        child: Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.wp(10))),
                      ),
                    ),
                )
                ],
              );
            }else{
              return Center(child: Text('No se pudo traer la informacion'));
            }
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
     ),
   );
  }
}