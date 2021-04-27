import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/core/error/exceptions.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/auth_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/responsive.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/features/DriverTaxiApp/Api/registro_conductor_api.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/color_carro_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/marca_carro_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/Model/modelo_carro_model.dart';
import 'package:HTRuta/features/DriverTaxiApp/providers/registro_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class RegisterDriverPage extends StatefulWidget {
  @override
  _RegisterDriverPageState createState() => _RegisterDriverPageState();
}

class _RegisterDriverPageState extends State<RegisterDriverPage> {
  PageController _pageController = PageController(initialPage: 0);

  void onAddButtonTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final providerRegistro = Provider.of<RegistroProvider>(context);


    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(responsive.hp(7)), // here the desired height
          child:  AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            title: Text(
              providerRegistro.index > 0
                  ? providerRegistro.titulo
                  : 'Marca de tu auto',
              style: TextStyle(color: Colors.black, fontSize: responsive.ip(2)),
            ),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Dialogs.confirm(context,message: '¿Está seguro de que quiere cerrar esta ventana?',onCancel: (){}, onConfirm: () => Navigator.of(context).pushAndRemoveUntil(Routes.toHomeDriverPage(), (_) => false));
                  },
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                        color: Colors.grey.withOpacity(0.7),
                        fontSize: responsive.ip(1.9)),
                  ))
            ],
            leading: providerRegistro.index > 0
                ? GestureDetector(
                    onTap: () {
                      providerRegistro.index = providerRegistro.index - 1;
                      onAddButtonTapped(providerRegistro.index);
                      switch (providerRegistro.index) {
                        case 1:
                          providerRegistro.titulo =
                              providerRegistro.dataMarca.vchMarca;
                          break;
                        case 2:
                          providerRegistro.titulo =
                              '${providerRegistro.dataMarca.vchMarca} ${providerRegistro.dataModelo.vchModelo}';
                          break;
                        case 3:
                          providerRegistro.titulo = 'Número de placa';
                          break;
                        case 4:
                          providerRegistro.titulo = 'Acerca de mi';
                          break;
                        case 5:
                          providerRegistro.titulo = 'Foto de auto';
                          break;
                        case 6:
                          providerRegistro.titulo = 'Documentos';
                          break;
                        default:
                          providerRegistro.titulo = 'Sin titulo';
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Atras',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: responsive.ip(1.9)),
                        )))
                : Container()),
        ),
        body: SizedBox(
          height: responsive.hp(93),
          child: PageView(
              pageSnapping: false,
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                PrimeraPagina(onAddButtonTapped),
                SegundaPagina(onAddButtonTapped),
                TerceraPagina(onAddButtonTapped),
                CuartaPagina(onAddButtonTapped),
                QuintaPagina(onAddButtonTapped),
                SextaPagina(onAddButtonTapped),
                SeptimaPagina(onAddButtonTapped),
                OctavaPagina(onAddButtonTapped)
              ]),
        ));
  }
}

class OctavaPagina extends StatefulWidget {
  final void Function(int) onAddButtonTapped;

  const OctavaPagina(this.onAddButtonTapped);

  @override
  _OctavaPaginaState createState() => _OctavaPaginaState();
}

class _OctavaPaginaState extends State<OctavaPagina> {

  final Session _session = Session();

  Uint8List obtenerFile(String base64){
    Uint8List bytes;
    bytes = base64Decode(base64);
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/image/1254100897.png'),
          Padding(
            padding: EdgeInsets.all(responsive.wp(10)),
            child: Text('La informacion sera enviada y entrara en un estado pendiente hasta que un administrador revise la informacion enviada, muchas gracias por su paciencia', style: TextStyle(fontSize: responsive.ip(2.2)),textAlign: TextAlign.justify,),
          ),
          Spacer(),
          Container(
                      color: Colors.white,
                      width: responsive.wp(100),
                      padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5), vertical: responsive.wp(2)),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
                        color: primaryColor,
                        onPressed: () async{
                          final provider = Provider.of<RegistroProvider>(context,listen: false);
                          try{
                            final registroConductor = RegistroConductorApi();
                            final authApi = AuthApi();
                            dynamic datosUsuario = await _session.get();
                            final _prefs = UserPreferences();
                            await _prefs.initPrefs();
                            Dialogs.openLoadingDialog(context);
                            final respuesta = await registroConductor.registrarChofer(datosUsuario['dni'], datosUsuario['nombres'], datosUsuario['apellidoPaterno'], datosUsuario['apellidoMaterno'], '19950804', '1', 'Av. Federico Villarreal 872', 'Por la guisada', datosUsuario['celular'],  datosUsuario['celular'], datosUsuario['correo'], datosUsuario['password'], '', '', '', '', _prefs.tokenPush, provider.placa, provider.dataModelo.iIdModelo.toString(),'4','2018', '1', provider.fotoSoat??'', provider.fotoPerfil??'', provider.fotoAuto??'', provider.fotoAtencedente??'', provider.fotoLicenciaFrente??'');
                            await authApi.loginUser(datosUsuario['correo'], datosUsuario['password']);
                            Navigator.pop(context);
                            if(respuesta){
                              Dialogs.confirm(context,title: 'Informacion', message: 'Se enviaron sus datos correctamente, revisara una notificacion con la respuesta en un plazo de 2 días, gracias', onConfirm: (){ Navigator.of(context).pushReplacement(Routes.toHomeDriverPage()); });
                            }else{
                              Dialogs.alert(context,title: 'Error', message: 'No se enviaron los datos, intentelo otra vez');
                            }

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
        ],
      ),
    );
  }
}

class SeptimaPagina extends StatefulWidget {

  final void Function(int) onAddButtonTapped;

  const SeptimaPagina(this.onAddButtonTapped);

  @override
  _SeptimaPaginaState createState() => _SeptimaPaginaState();
}

class _SeptimaPaginaState extends State<SeptimaPagina> {

  String licencia = '';
  List<File> imagenes = List(4);
  List<String> base64Data = List(4);
  File imageFile;

  List<String> cabecera = ['Número de licencia de conducir', 'Licencia de conducir (frente)', 'Licencia de conducir (parte trasera)', 'Cargue cualquiera de los siguientes:/- Tarjeta de taxista o antecendentes penales (Fotocheck)/- Foto de la cuenta de otra aplicación de taxi/- Carta de antecedentes no penales','SOAT'];

   Future<void> buscarImagen(int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Añadir una nueva foto"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Seleccionar foto"),
                    onTap: () async {
                      await _openGallery(index);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Tomar una foto"),
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
      this.setState(() {});
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
      this.setState(() {});
      Navigator.of(context).pop();
    } catch (e) {}
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
    final providerRegistro = Provider.of<RegistroProvider>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: responsive.wp(100),
          height: responsive.hp(90),
          padding: EdgeInsets.only(top: responsive.hp(3),bottom: responsive.hp(7)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Número de licencia de conducir', style: TextStyle(fontSize: responsive.ip(2)),),
                  SizedBox(height: responsive.hp(2),),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (value){
                      setState(() {
                        licencia = value;
                      });
                    },
                    decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    hintText: 'Ingrese licencia',
                    hintStyle: TextStyle(
                      color: Colors.grey, fontFamily: 'Quicksand'),
                    )
                  ),
                  SizedBox(height: responsive.hp(2),),
                  Column(
                    children: List<Widget>.generate(4, (index){
                      List<String> titulo = cabecera[index].split('/');
                      return Column(
                        children: <Widget>[
                          titulo.length > 1 ?
                          Column(
                            children: <Widget>[
                              Text(titulo[0], style: TextStyle(fontSize: responsive.ip(2)),),
                              Text(titulo[1], style: TextStyle(fontSize: responsive.ip(2)),textAlign: TextAlign.center,),                    
                              Text(titulo[2], style: TextStyle(fontSize: responsive.ip(2)),textAlign: TextAlign.center,),                    
                              Text(titulo[3], style: TextStyle(fontSize: responsive.ip(2)),textAlign: TextAlign.center,),                    
                            ],
                          ) : Text(cabecera[index], style: TextStyle(fontSize: responsive.ip(2)),),
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
                    }),
                  ),
                ],
              ),
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
                            bool noValido = false;
                            for(int i = 0;i< base64Data.length;i++){
                              if(base64Data[i] == null){
                                noValido = true;
                                return;
                              }
                            }

                            if(!noValido){
                              final provider = Provider.of<RegistroProvider>(context,listen: false);
                              provider.fotoLicenciaFrente = base64Data[0];
                              provider.fotoLicenciaTrasera = base64Data[1];
                              provider.fotoAtencedente = base64Data[2];
                              provider.fotoSoat = base64Data[3];
                              providerRegistro.index = 7;
                              providerRegistro.titulo = 'Confirmacion';
                              widget.onAddButtonTapped(providerRegistro.index);
                            }else if(licencia.isEmpty){
                              Dialogs.alert(context, title: 'Error', message: 'Debe ingresar numero de licencia');
                            }else{
                              Dialogs.alert(context, title: 'Error', message: 'Debe subir todas las fotos para proceder a enviar la información');
                            }
                          }catch(error){
                            Navigator.pop(context);
                            print('Error ${error.toString()}');
                            Dialogs.alert(context, title: 'Error', message: 'Ocurrio un error,vuelva a intentarlo');
                          }

                        },
                        child: Text(
                          'Siguiente',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.wp(10))),
                      ),
                    ),
                )
      //   SingleChildScrollView(
      //     child: Padding(
      //       padding: EdgeInsets.all(responsive.wp(3)),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: <Widget>[
      //           Text('Número de licencia de conducir', style: TextStyle(fontSize: responsive.ip(2)),),
      //           SizedBox(height: responsive.hp(2),),
      //           TextFormField(
      //                       keyboardType: TextInputType.text,
      //                       onChanged: (value){
      //                         setState(() {
      //                           licencia = value;
      //                         });
      //                       },
      //                       decoration: InputDecoration(
      //                         border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(10.0),
      //                         ),
      //                         contentPadding:
      //                             EdgeInsets.only(left: 15.0, top: 15.0),
      //                         hintText: 'Ingrese licencia',
      //                         hintStyle: TextStyle(
      //                             color: Colors.grey, fontFamily: 'Quicksand'),
      //                       )),
      //           SizedBox(height: responsive.hp(2),),
      //           Text('Licencia de conducir (frente)', style: TextStyle(fontSize: responsive.ip(2)),),
      //           SizedBox(height: responsive.hp(2),),
      //           Container(
      //                         width: responsive.wp(70),
      //                         height: responsive.hp(20),
      //                         decoration: BoxDecoration(
      //                           color: primaryColor,
      //                           borderRadius: BorderRadius.circular(10)
      //                         ),
      //                         child: licenciaFrente != null  ? ClipRRect(child: Image.file(licenciaFrente, fit: BoxFit.contain)) : Icon(FontAwesomeIcons.userCheck, size: responsive.ip(7),color: Colors.white,),
      //                       ),
      //           SizedBox(height: responsive.hp(1),),
      //           OutlineButton(
      //                         onPressed: ()async{
      //                           buscarImagen();
      //                           licenciaFrente = imageFile;
      //                         },
      //                         borderSide: BorderSide(color: primaryColor),
      //                         child: Text('Añadir', style: TextStyle(color: primaryColor),),
      //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.wp(5))),
      //                         padding: EdgeInsets.symmetric(horizontal: responsive.hp(10)),
      //                       ),
      //           SizedBox(height: responsive.hp(2),),
      //           Text('Licencia de conducir (parte trasera)', style: TextStyle(fontSize: responsive.ip(2)),),
      //           SizedBox(height: responsive.hp(2),),
      //           Container(
      //                         width: responsive.wp(70),
      //                         height: responsive.hp(20),
      //                         decoration: BoxDecoration(
      //                           color: primaryColor,
      //                           borderRadius: BorderRadius.circular(10)
      //                         ),
      //                         child: licenciaTrasera != null  ? ClipRRect(child: Image.file(licenciaTrasera, fit: BoxFit.contain)) : Icon(FontAwesomeIcons.userCheck, size: responsive.ip(7),color: Colors.white,),
      //                       ),
      //           SizedBox(height: responsive.hp(1),),
      //           OutlineButton(
      //                         onPressed: (){
      //                           buscarImagen();
      //                           licenciaTrasera = imageFile;
      //                         },
      //                         borderSide: BorderSide(color: primaryColor),
      //                         child: Text('Añadir', style: TextStyle(color: primaryColor),),
      //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.wp(5))),
      //                         padding: EdgeInsets.symmetric(horizontal: responsive.hp(10)),
      //                       ),
      //           SizedBox(height: responsive.hp(2),),
      //           Text('Cargue cualquiera de los siguientes:', style: TextStyle(fontSize: responsive.ip(2)),),
      //           Text('- Tarjeta de taxista o antecendentes penales (Fotocheck)', style: TextStyle(fontSize: responsive.ip(2)),textAlign: TextAlign.center,),
      //           Text('- Foto de la cuenta de otra aplicación de taxi', style: TextStyle(fontSize: responsive.ip(2)),textAlign: TextAlign.center),
      //           Text('- Carta de antecedentes no penales', style: TextStyle(fontSize: responsive.ip(2)),textAlign: TextAlign.center),
      //           SizedBox(height: responsive.hp(2),),
      //           Container(
      //                         width: responsive.wp(70),
      //                         height: responsive.hp(20),
      //                         decoration: BoxDecoration(
      //                           color: primaryColor,
      //                           borderRadius: BorderRadius.circular(10)
      //                         ),
      //                         child: antecedentes != null  ? ClipRRect(child: Image.file(antecedentes, fit: BoxFit.contain)) : Icon(FontAwesomeIcons.userCheck, size: responsive.ip(7),color: Colors.white,),
      //                       ),
      //           SizedBox(height: responsive.hp(1),),
      //           OutlineButton(
      //                         onPressed: (){
      //                           buscarImagen();
      //                           antecedentes = imageFile;
      //                         },
      //                         borderSide: BorderSide(color: primaryColor),
      //                         child: Text('Añadir', style: TextStyle(color: primaryColor),),
      //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.wp(5))),
      //                         padding: EdgeInsets.symmetric(horizontal: responsive.hp(10)),
      //                       ),
      //           SizedBox(height: responsive.hp(2),),
      //           Text('SOAT', style: TextStyle(fontSize: responsive.ip(2)),),
      //           SizedBox(height: responsive.hp(2),),
      //           Container(
      //                         width: responsive.wp(70),
      //                         height: responsive.hp(20),
      //                         decoration: BoxDecoration(
      //                           color: primaryColor,
      //                           borderRadius: BorderRadius.circular(10)
      //                         ),
      //                         child: soat != null  ? ClipRRect(child: Image.file(soat, fit: BoxFit.contain)) : Icon(FontAwesomeIcons.userCheck, size: responsive.ip(7),color: Colors.white,),
      //                       ),
      //           SizedBox(height: responsive.hp(1),),
      //           OutlineButton(
      //                         onPressed: (){
      //                           buscarImagen();
      //                           soat = imageFile;
      //                         },
      //                         borderSide: BorderSide(color: primaryColor),
      //                         child: Text('Añadir', style: TextStyle(color: primaryColor),),
      //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.wp(5))),
      //                         padding: EdgeInsets.symmetric(horizontal: responsive.hp(10)),
      //                       ),
      //           SizedBox(height: responsive.hp(9),)
      //         ],
      //       ),
      //     ),
      //   ),
      //   Positioned(
      //             bottom: 0,
      //             child: Container(
      //                 color: Colors.white,
      //                 width: responsive.wp(100),
      //                 padding: EdgeInsets.symmetric(
      //                     horizontal: responsive.wp(5), vertical: responsive.wp(2)),
      //                 child: FlatButton(
      //                   padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      //                   color: primaryColor,
      //                   onPressed: () async{
      //                     final provider = Provider.of<RegistroProvider>(context,listen: false);
      //                     try{
      //                       if (licenciaFrente != null && licenciaTrasera != null && antecedentes != null && soat != null && licencia.isNotEmpty) {

      //                         provider.fotoLicenciaFrente = await obtenerBase64(licenciaFrente);
      //                         provider.fotoLicenciaTrasera = await obtenerBase64(licenciaTrasera);
      //                         provider.fotoAtencedente = await obtenerBase64(antecedentes);
      //                         provider.fotoSoat = await obtenerBase64(soat);
      //                         providerRegistro.index = 7;
      //                         providerRegistro.titulo = 'Confirmacion';
      //                         widget.onAddButtonTapped(providerRegistro.index);
      //                       }else if(licencia.isEmpty){
      //                         Dialogs.alert(context, title: 'Error', message: 'Debe ingresar numero de licencia');
      //                       }
      //                       else{
      //                         Dialogs.alert(context, title: 'Error', message: 'Debe seleccionar fotos');
      //                       }
      //                     }catch(error){
      //                       print('Error ${error.toString()}');
      //                       Dialogs.alert(context, title: 'Error', message: 'Ocurrio un error,vuelva a intentarlo');
      //                     }

      //                   },
      //                   child: Text(
      //                     'Siguiente',
      //                     style: TextStyle(color: Colors.white),
      //                   ),
      //                   shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(responsive.wp(10))),
      //                 ),
      //               ),
      //           )
      ],
    );
  }
}

class SextaPagina extends StatefulWidget {

  final void Function(int) onAddButtonTapped;

  const SextaPagina(this.onAddButtonTapped);

  @override
  _SextaPaginaState createState() => _SextaPaginaState();
}

class _SextaPaginaState extends State<SextaPagina> {

  File imageFile;

  Future<void> buscarImagen() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Añadir una nueva foto"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Seleccionar foto"),
                    onTap: () {
                      _openGallery();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Tomar una foto"),
                    onTap: () {
                      cameraImage();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future cameraImage() async {
    try{
      var image = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 664, maxWidth: 1268);
      imageFile = File(image.path);
      await _cropImage();
      this.setState(() {});
      Navigator.of(context).pop();
    }catch(error){
      print(error.toString());
    }
  }

  void _openGallery() async {
    try {
      var picture = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 664, maxWidth: 1268);
      imageFile = File(picture.path);
      await _cropImage();
      this.setState(() {});
      Navigator.of(context).pop();
    } catch (e) {}
  }

  bool recortado = false;

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [ CropAspectRatioPreset.square ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Recortar',
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true
      ),
      iosUiSettings: IOSUiSettings(title: 'Cropper')
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        recortado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final providerRegistro = Provider.of<RegistroProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: responsive.wp(100),
            height: responsive.hp(30),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.all(responsive.wp(2)),
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${providerRegistro.dataMarca.vchMarca} ${providerRegistro.dataModelo.vchModelo}', style: TextStyle(fontSize: responsive.ip(2.4), fontWeight: FontWeight.bold),),
                  SizedBox(height: responsive.hp(2),),
                  Text('${providerRegistro.color}',style: TextStyle(fontSize: responsive.ip(2.2), fontWeight: FontWeight.w600)),
                  SizedBox(height: responsive.hp(2)),
                  Text('${providerRegistro.placa}',style: TextStyle(fontSize: responsive.ip(2.2), fontWeight: FontWeight.w600))
                ],
              ),
            ),
          ),
          Container(
            width: responsive.wp(100),
            height: responsive.hp(40),
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.all(responsive.wp(2)),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(responsive.wp(3)),
                    child: Column(
                      children: <Widget>[
                        Text('Tome una foto de su automóvil para que se muestre el número de placa', style: TextStyle(fontSize: responsive.ip(1.9),fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                        SizedBox(height: responsive.wp(2),),
                        Container(
                          width: responsive.wp(70),
                          height: responsive.hp(20),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: imageFile != null  ? ClipRRect(child: Image.file(imageFile, fit: BoxFit.contain)) : Icon(FontAwesomeIcons.car, size: responsive.ip(7),color: Colors.white,),
                        ),
                        SizedBox(height: responsive.wp(1),),
                        OutlineButton(
                          onPressed: (){
                            buscarImagen();
                          },
                          borderSide: BorderSide(color: primaryColor),
                          child: Text('Añadir', style: TextStyle(color: primaryColor),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.wp(5))),
                          padding: EdgeInsets.symmetric(horizontal: responsive.hp(10)),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: responsive.wp(100),
            padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(5), vertical: responsive.wp(2)),
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
              color: primaryColor,
              onPressed: () async{
                final provider = Provider.of<RegistroProvider>(context,listen: false);
                try{
                  if (imageFile != null) {
                    String base64Image;
                    List<int> imageBytes = await imageFile.readAsBytes();
                    base64Image = base64Encode(imageBytes);
                    provider.fotoAuto = base64Image;
                    providerRegistro.index = 6;
                    providerRegistro.titulo = 'Documentos';
                    widget.onAddButtonTapped(providerRegistro.index);
                  }else{
                    Dialogs.alert(context, title: 'Error', message: 'Debe seleccionar una foto de perfil');
                  }
                }catch(error){
                  print('Error ${error.toString()}');
                  Dialogs.alert(context, title: 'Error', message: 'Ocurrio un error,vuelva a intentarlo');
                }

              },
              child: Text(
                'Siguiente',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.wp(10))),
            ),
          ),
        ],
      ),
    );
  }
}

class QuintaPagina extends StatefulWidget {
  final void Function(int) onAddButtonTapped;

  const QuintaPagina(this.onAddButtonTapped);

  @override
  _QuintaPaginaState createState() => _QuintaPaginaState();
}

class _QuintaPaginaState extends State<QuintaPagina> {

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  //Validations validations = new Validations();
  final Session _session = Session();
  File imageFile;
  Future<dynamic> datosUsuario;
  //Cmabia de estado asi que declarar en state
  int sexo = 1;

  @override
  void initState() { 
    super.initState();
    //Solucionar bug de recargar el futurebuilder
    datosUsuario = _session.get();
  }

  Future<void> buscarImagen() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Añadir una nueva foto"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Seleccionar foto"),
                    onTap: () async {
                      await _openGallery();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Tomar una foto"),
                    onTap: () async{
                      await cameraImage();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future cameraImage() async {
    try{
      var image = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 664, maxWidth: 1268);
      imageFile = File(image.path);
      await _cropImage();
      this.setState(() {});
    }catch(error){
      print(error.toString());
    }
  }

  Future _openGallery() async {
    try {
      var picture = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 664, maxWidth: 1268);
      imageFile = File(picture.path);
      await _cropImage();
      this.setState(() {});
      Navigator.of(context).pop();
    } catch (e) {}
  }

  bool recortado = false;

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [ CropAspectRatioPreset.square ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Recortar',
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true
      ),
      iosUiSettings: IOSUiSettings(title: 'Cropper')
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        recortado = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final providerRegistro = Provider.of<RegistroProvider>(context);

    return Stack(
                  children: <Widget>[
                    FutureBuilder<dynamic>(
                      future: datosUsuario,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          if(snapshot.hasData){
                            final data = snapshot.data;
                            return SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: responsive.hp(2),),
                                  CircleAvatar(
                                    radius: responsive.wp(10),
                                    backgroundColor: imageFile!= null ? Colors.transparent : primaryColor,
                                    child: imageFile!= null ? ClipRRect(child: Image.file(imageFile, fit: BoxFit.contain)) : Icon(FontAwesomeIcons.userAlt, size: responsive.ip(5.5),color: Colors.white,),
                                  ),
                                  SizedBox(height: responsive.hp(2),),
                                  OutlineButton(
                                    onPressed: (){
                                      buscarImagen();
                                    },
                                    borderSide: BorderSide(color: primaryColor),
                                    child: Text('Añadir', style: TextStyle(color: primaryColor),),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(responsive.wp(5))),
                                    padding: EdgeInsets.symmetric(horizontal: responsive.hp(10)),
                                  ),
                                  SizedBox(height: responsive.hp(2),),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Nombre', style: TextStyle(fontSize: responsive.ip(2)),),
                                        SizedBox(height: responsive.hp(1),),
                                        TextFormField(
                                          initialValue: data['nombres']??'',
                                          keyboardType: TextInputType.text,
                                          //validator: validations.validateName,
                                          decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                        )
                                      ),
                                      SizedBox(height: responsive.hp(2),),
                                      Text('Apellido Paterno', style: TextStyle(fontSize: responsive.ip(2)),),
                                        SizedBox(height: responsive.hp(1),),
                                        TextFormField(
                                          initialValue: data['apellidoPaterno']??'',
                                          keyboardType: TextInputType.text,
                                          //validator: validations.validateName,
                                          decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                        )
                                      ),
                                      SizedBox(height: responsive.hp(2),),
                                      Text('Apellido Materno', style: TextStyle(fontSize: responsive.ip(2)),),
                                        SizedBox(height: responsive.hp(1),),
                                        TextFormField(
                                          initialValue: data['apellidoMaterno']??'',
                                          keyboardType: TextInputType.text,
                                          //validator: validations.validateMobile,
                                          decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                        )
                                      ),
                                      SizedBox(height: responsive.hp(2),),
                                      Text('Documento de indentidad', style: TextStyle(fontSize: responsive.ip(2)),),
                                        SizedBox(height: responsive.hp(1),),
                                        TextFormField(
                                          initialValue: data['dni']??'',
                                          keyboardType: TextInputType.phone,
                                          //validator: validations.validateName,
                                          decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                        )
                                      ),
                                      SizedBox(height: responsive.hp(2),),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: FlatButton(
                                              onPressed: (){       
                                                setState(() {
                                                  sexo = 1;
                                                });
                                              }, 
                                              child: Text('Masculino', style: TextStyle(color: sexo == 1 ? Colors.white : primaryColor, fontSize: responsive.ip(2),)),
                                              shape: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(responsive.wp(2)), bottomLeft: Radius.circular(responsive.wp(2))),
                                                borderSide: BorderSide(
                                                  color: primaryColor
                                                )
                                              ),
                                              color: sexo == 1 ? primaryColor : Colors.white,
                                              padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
                                            ),
                                          ),
                                          SizedBox(width: responsive.wp(1),),
                                          Expanded(
                                            child: FlatButton(
                                              onPressed: (){
                                                setState(() {
                                                  sexo = 2;
                                                });
                                              }, 
                                              child: Text('Femenino',style: TextStyle(color: sexo == 2 ? Colors.white : primaryColor, fontSize: responsive.ip(2)),),
                                              shape: OutlineInputBorder(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(responsive.wp(2)), bottomRight: Radius.circular(responsive.wp(2))),
                                                borderSide: BorderSide(color: primaryColor)
                                              ),
                                              color:  sexo == 2 ? primaryColor : Colors.white,
                                              padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),

                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: responsive.hp(2),),
                                      Text('Fecha de Nacimiento', style: TextStyle(fontSize: responsive.ip(2)),),
                                        SizedBox(height: responsive.hp(1),),
                                        OutlineButton(
                                          onPressed: (){},
                                          child: Text('04/08/1995', textAlign: TextAlign.left,style: TextStyle(color: Colors.black54),),
                                          padding: EdgeInsets.symmetric(vertical: responsive.hp(2.5), horizontal: responsive.wp(35)),
                                      ),
                                      SizedBox(height: responsive.hp(2),),
                                      Text('Email', style: TextStyle(fontSize: responsive.ip(2)),),
                                        SizedBox(height: responsive.hp(1),),
                                        TextFormField(
                                          initialValue: data['correo']??'',
                                          keyboardType: TextInputType.emailAddress,
                                          //validator: validations.validateEmail,
                                          decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                          hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                        )
                                      ),
                                      SizedBox(height: responsive.hp(10),),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            );
                          }else{
                            return Center(child: Text('No se pudo obtener la informacion'));
                          }
                        }else{
                          return Center(child: CircularProgressIndicator(),);
                        }

                      }
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
                          final provider = Provider.of<RegistroProvider>(context,listen: false);
                          try{
                            if (imageFile != null) {
                              String base64Image;
                              List<int> imageBytes = await imageFile.readAsBytes();
                              base64Image = base64Encode(imageBytes);
                              provider.fotoPerfil = base64Image;
                              providerRegistro.index = 5;
                              providerRegistro.titulo = 'Foto de su auto';
                              widget.onAddButtonTapped(providerRegistro.index);
                            }else{
                              Dialogs.alert(context, title: 'Error', message: 'Debe seleccionar una foto de perfil');
                            }
                          }catch(error){
                            print('Error ${error.toString()}');
                            Dialogs.alert(context, title: 'Error', message: 'Ocurrio un error,vuelva a intentarlo');
                          }

                        },
                        child: Text(
                          'Siguiente',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(responsive.wp(10))),
                      ),
                    ),
                )
              ],
            );
  }
}

class CuartaPagina extends StatefulWidget {
  final void Function(int) onAddButtonTapped;

  const CuartaPagina(this.onAddButtonTapped);

  @override
  _CuartaPaginaState createState() => _CuartaPaginaState();
}

class _CuartaPaginaState extends State<CuartaPagina> {
  String placa = '';
  bool procede = false;

  @override
  Widget build(BuildContext context) {
    final resposive = Responsive(context);
    final providerRegistro = Provider.of<RegistroProvider>(context);

    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: resposive.hp(2),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: resposive.wp(3)),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(resposive.wp(2))),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: resposive.wp(4), vertical: resposive.hp(2)),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${providerRegistro.dataMarca.vchMarca} ${providerRegistro.dataModelo.vchModelo}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: resposive.ip(2.1)),
                    ),
                    SizedBox(
                      height: resposive.hp(1),
                    ),
                    Text(
                      '${providerRegistro.color}',
                      style: TextStyle(fontSize: resposive.ip(2.1)),
                    ),
                    SizedBox(
                      height: resposive.hp(2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: resposive.wp(5)),
                      child: Text(
                        'Ingrese el número de la placa de su automóvil',
                        style: TextStyle(fontSize: resposive.ip(2.1)),
                      ),
                    ),
                    SizedBox(
                      height: resposive.hp(2),
                    ),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value){
                          setState(() {
                            placa = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                          hintText: 'A123BC',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontFamily: 'Quicksand'),
                        )),
                    SizedBox(height: resposive.hp(1),),
                    Text('Tu número de placa solo es necesario para que el pasajero identifique tu vehículo', style: TextStyle(fontStyle: FontStyle.italic,fontSize: resposive.ip(1.4)),)
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            color: Colors.white,
            width: resposive.wp(100),
            padding: EdgeInsets.symmetric(
                horizontal: resposive.wp(5), vertical: resposive.wp(2)),
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: resposive.hp(2)),
              color: primaryColor,
              onPressed: () {
                final provider = Provider.of<RegistroProvider>(context,listen: false);
                if(placa.isEmpty){
                  Dialogs.alert(context,title: 'Error', message: 'Este campo no puede estar vacio');
                }else if(placa.length != 6){
                  Dialogs.alert(context,title: 'Error', message: 'Número de placa no es válido');
                }else{
                  provider.placa = placa;
                  providerRegistro.titulo = 'Acerca de mi';
                  providerRegistro.index = 4;
                  widget.onAddButtonTapped(providerRegistro.index);
                }
              },
              child: Text(
                'Siguiente',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(resposive.wp(10))),
            ),
          )
        ],
      ),
    );
  }
}

class TerceraPagina extends StatelessWidget {
  final void Function(int) onAddButtonTapped;

  const TerceraPagina(this.onAddButtonTapped);

  @override
  Widget build(BuildContext context) {
    final resposive = Responsive(context);
    final List<ColorCarro> fakeData = [
      ColorCarro(nombre: 'Gris', color: Colors.grey),
      ColorCarro(nombre: 'Plata', color: Color(0xFFe3e4e5)),
      ColorCarro(nombre: 'Blanco', color: Colors.white),
      ColorCarro(nombre: 'Negro', color: Colors.black),
      ColorCarro(nombre: 'Azul', color: Colors.blue),
      ColorCarro(nombre: 'Azul claro', color: Colors.lightBlue),
      ColorCarro(nombre: 'Verde', color: Colors.green),
      ColorCarro(nombre: 'Rojo', color: Colors.red),
      ColorCarro(nombre: 'Borgoña', color: Color(0xFF6e3732)),
      ColorCarro(nombre: 'Naranja', color: Colors.orange),
      ColorCarro(nombre: 'Rosado', color: Colors.pink),
      ColorCarro(nombre: 'Beige', color: Color(0xFFf5f5dc)),
      ColorCarro(nombre: 'Amarillo', color: Colors.yellow),
      ColorCarro(nombre: 'Oro', color: Color(0xFFffbf00)),
      ColorCarro(nombre: 'Marrón', color: Colors.brown)
    ];

    return SafeArea(
        child: Container(
            color: Colors.grey.withOpacity(0.2),
            child: Container(
                margin: EdgeInsets.only(
                    left: resposive.wp(2),
                    right: resposive.wp(2),
                    top: resposive.wp(2)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(resposive.wp(2)),
                        topRight: Radius.circular(resposive.wp(2)))),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: resposive.wp(16),
                          vertical: resposive.hp(2)),
                      child: Text(
                        'Seleccione un color de auto',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: resposive.hp(2),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: fakeData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: resposive.wp(2),
                                  vertical: resposive.hp(0.5)),
                              child: GestureDetector(
                                onTap: () {
                                  final providerRegistro =
                                      Provider.of<RegistroProvider>(context,
                                          listen: false);
                                  providerRegistro.color =
                                      fakeData[index].nombre;
                                  providerRegistro.titulo = 'Número de placa';
                                  providerRegistro.index = 3;
                                  onAddButtonTapped(providerRegistro.index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: resposive.wp(5),
                                      vertical: resposive.wp(3)),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(
                                          resposive.wp(5))),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: resposive.wp(3.5),
                                        backgroundColor: fakeData[index].color,
                                      ),
                                      SizedBox(
                                        width: resposive.wp(2),
                                      ),
                                      Text(
                                        fakeData[index].nombre ?? 'Sin color',
                                        style: TextStyle(
                                            fontSize: resposive.ip(1.8)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ))));
  }
}

class SegundaPagina extends StatelessWidget {
  final void Function(int) onAddButtonTapped;

  const SegundaPagina(this.onAddButtonTapped);

  @override
  Widget build(BuildContext context) {
    final resposive = Responsive(context);
    final providerRegistro = Provider.of<RegistroProvider>(context);
    final registroConductorApi = RegistroConductorApi();

    return SafeArea(
        child: Container(
            color: Colors.grey.withOpacity(0.2),
            child: Container(
                margin: EdgeInsets.only(
                    left: resposive.wp(2),
                    right: resposive.wp(2),
                    top: resposive.wp(2)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(resposive.wp(2)),
                        topRight: Radius.circular(resposive.wp(2)))),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: resposive.wp(16),
                          vertical: resposive.hp(2)),
                      child: Text(
                        'Seleccione un modelo de automóvil',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: resposive.wp(3)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: resposive.ip(2.6),
                            ),
                            hintText: 'Búsqueda de modelo',
                            hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.7),
                                fontSize: resposive.ip(1.8))),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: resposive.hp(2),
                    ),
                    FutureBuilder<List<DataModelo>>(
                        future: registroConductorApi.obtenerModelo(
                            providerRegistro.dataMarca.iIdMarca.toString()),
                        builder: (context, snapshot) {
                          try {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: resposive.wp(2),
                                              vertical: resposive.hp(0.5)),
                                          child: GestureDetector(
                                            onTap: () {
                                              final providerRegistro =
                                                  Provider.of<RegistroProvider>(
                                                      context,
                                                      listen: false);
                                              providerRegistro.dataModelo =
                                                  snapshot.data[index];
                                              providerRegistro.titulo =
                                                  '${providerRegistro.dataMarca.vchMarca} ${snapshot.data[index].vchModelo}';
                                              providerRegistro.index = 2;
                                              onAddButtonTapped(
                                                  providerRegistro.index);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: resposive.wp(5),
                                                  vertical: resposive.wp(3)),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          resposive.wp(5))),
                                              child: Text(
                                                snapshot.data[index].vchModelo,
                                                style: TextStyle(
                                                    fontSize:
                                                        resposive.ip(1.8)),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return Expanded(
                                    child: Center(
                                  child: Text('No hay marcas disponibles'),
                                ));
                              }
                            } else {
                              return Expanded(
                                  child: Center(
                                child: CircularProgressIndicator(),
                              ));
                            }
                          } on ServerException catch (error) {
                            Dialogs.alert(context,
                                title: 'Error', message: '${error.message}');
                          } catch (error) {
                            Dialogs.alert(context,
                                title: 'Error', message: '$error');
                          }
                        })
                  ],
                ))));
  }
}

class PrimeraPagina extends StatelessWidget {
  final void Function(int) onAddButtonTapped;

  const PrimeraPagina(this.onAddButtonTapped);

  @override
  Widget build(BuildContext context) {
    final resposive = Responsive(context);
    final registroConductorApi = RegistroConductorApi();

    return SafeArea(
        child: Container(
            color: Colors.grey.withOpacity(0.2),
            child: Container(
                margin: EdgeInsets.only(
                    left: resposive.wp(2),
                    right: resposive.wp(2),
                    top: resposive.wp(2)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(resposive.wp(2)),
                        topRight: Radius.circular(resposive.wp(2)))),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: resposive.wp(16),
                          vertical: resposive.hp(2)),
                      child: Text(
                        'Seleccione una marca de automóvil en la que trabajará',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: resposive.wp(3)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: resposive.ip(2.6),
                            ),
                            hintText: 'Búsqueda de marca',
                            hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.7),
                                fontSize: resposive.ip(1.8))),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: resposive.hp(2),
                    ),
                    FutureBuilder<List<DataMarca>>(
                        future: registroConductorApi.obtenerMarca(),
                        builder: (context, snapshot) {
                          try {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: resposive.wp(2),
                                              vertical: resposive.hp(0.5)),
                                          child: GestureDetector(
                                            onTap: () {
                                              final providerRegistro =
                                                  Provider.of<RegistroProvider>(
                                                      context,
                                                      listen: false);
                                              providerRegistro.dataMarca =
                                                  snapshot.data[index];
                                              providerRegistro.titulo =
                                                  snapshot.data[index].vchMarca;
                                              providerRegistro.index = 1;
                                              onAddButtonTapped(
                                                  providerRegistro.index);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: resposive.wp(5),
                                                  vertical: resposive.wp(3)),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          resposive.wp(5))),
                                              child: Text(
                                                snapshot.data[index].vchMarca,
                                                style: TextStyle(
                                                    fontSize:
                                                        resposive.ip(1.8)),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return Expanded(
                                    child: Center(
                                  child: Text('No hay marcas disponibles'),
                                ));
                              }
                            } else {
                              return Expanded(
                                  child: Center(
                                child: CircularProgressIndicator(),
                              ));
                            }
                          } on ServerException catch (error) {
                            Dialogs.alert(context,
                                title: 'Error', message: '${error.message}');
                          } catch (error) {
                            Dialogs.alert(context,
                                title: 'Error', message: '$error');
                          }
                        })
                  ],
                ))));
  }
}