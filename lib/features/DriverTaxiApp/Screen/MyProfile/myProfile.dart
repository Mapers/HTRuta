import 'dart:io';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Camera/take_picture_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/DriverTaxiApp/Components/inputDropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/save_profile_body.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/select_address.dart';
import 'package:permission_handler/permission_handler.dart';

class MyProfile extends StatefulWidget {
  final DriverSession driverSession;
  MyProfile(this.driverSession);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> formKey =GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey =GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> listGender = [{'id': '1','name' : 'Masculino',},{'id': '0','name' : 'Femenino',}];
  String selectedGender;
  String lastSelectedValue;
  DateTime date = DateTime.now();
  final session = Session();
  DriverSession driverSession;
  DateTime birthdaySelected;
  final pickupApi = PickupApi();
  final _prefs = UserPreferences();
  var _image;
  String newNames;
  String newFName;
  String newMName;
  String newPhone;
  String newEmail;
  String photoUrl;
  String newAddress;

  Future getImageLibrary() async {
    try{
      // ignore: deprecated_member_use
      var gallery = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 700);
      setState(() {
        _image = gallery;
      });
    }catch(e){
      print(e);
      Dialogs.alert(context,title: 'Error', message: 'No se pudo obtener la imagen, inténtelo nuevamente');
    }
    /* if(gallery == null) return;
    List<int> imageBytes = gallery.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    photoUrl = await pickupApi.uploadPhoto(_prefs.idUsuario, base64Image);
    if(photoUrl == null){
      Dialogs.alert(context,title: 'Error', message: 'No se pudo subir la foto');
      return;
    } */
    // print('La foto se subió correctamente');
  }

  Future cameraImage() async {
    // ignore: deprecated_member_use
    try{
      final List<CameraDescription> cameras = await availableCameras();
      if(cameras.isEmpty){
        throw Exception();
      }
      String imagePath = await Navigator.push(context, MaterialPageRoute(builder: (context) => TakePicturePage(camera: cameras.first)));
      if(imagePath == null) return;
      _image = File(imagePath);
      setState(() {});
    }catch(e){
      print(e);
      Dialogs.alert(context,title: 'Error', message: 'No se pudo obtener la imagen, inténtelo nuevamente');
    }
    /* var pickImage = ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 700);
    var image = await pickImage;
    setState(() {
      _image = image;
    }); */
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() { lastSelectedValue = value; });
      }
    });
  }

  void selectCamera() {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: const Text('Seleccionar Camara'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text('Camara'),
            onPressed: () {
              Navigator.pop(context, 'Camera');
              cameraImage();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Libreria de fotos'),
            onPressed: () {
              Navigator.pop(context, 'Photo Library');
              getImageLibrary();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancelar'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        )
      ),
    );
  }

  void submit() async {
    Dialogs.openLoadingDialog(context);
    if(_image != null){
      final url = await pickupApi.uploadImage(_image, _prefs.idUsuario);
      if(url == null){
        Navigator.pop(context);
        Dialogs.alert(context,title: 'Error', message: 'No se pudo subir la foto');
        return;
      }
      photoUrl = url;
    }
    final FormState form = formKey.currentState;
    form.save();
    SaveProfileBody body = SaveProfileBody(
      iIdUsuario: _prefs.idUsuario,
      nombres: newNames ?? widget.driverSession.mName,
      apellidoPaterno: newFName ?? widget.driverSession.pName,
      apellidoMaterno: newMName ?? widget.driverSession.mName,
      fechaNacimiento: date ?? DateTime.now(),
      sexo: selectedGender,
      telefono: newPhone ?? widget.driverSession.phone,
      celular: newPhone ?? widget.driverSession.phone,
      userAddress: newAddress
    );
    bool profileSavedSuccess = await pickupApi.saveProfile(body);
    if(!profileSavedSuccess){
      Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
      return;
    }
    final userData = await session.get();
    await session.set(
      userData.id,
      userData.dni,
      newNames ?? userData.names,
      newFName ?? userData.lastNameFather,
      newMName ?? userData.lastNameMother,
      newPhone ?? userData.cellphone,
      newEmail ?? userData.email,
      userData.password,
      photoUrl ?? userData.imageUrl,
      selectedGender,
      userData.smsCode,
      DateTimeExtension.parseDateEnglishV2(birthdaySelected),
      userData.fechaRegistro,
      newAddress,
      userData.referencia,
    );
    await session.setDriverData(
      newNames ?? widget.driverSession.mName,
      newFName ?? widget.driverSession.pName,
      newMName ?? widget.driverSession.mName,
      newPhone ?? widget.driverSession.phone,
      newEmail ?? widget.driverSession.email,
      widget.driverSession.dni,
      selectedGender,
      DateTimeExtension.parseDateEnglishV2(birthdaySelected),
      widget.driverSession.fechaRegistro,
      photoUrl ?? widget.driverSession.imageUrl,
      widget.driverSession.smsCode,
      newAddress,
      widget.driverSession.referencia,
      widget.driverSession.metodosPago,
      widget.driverSession.saldo
    );
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    selectedGender = widget.driverSession.sexo;
    newEmail = widget.driverSession.email;
    newAddress = widget.driverSession.direccion;
    date = DateTime(
      int.parse(widget.driverSession.fechaNacimiento.split('-')[0]),
      int.parse(widget.driverSession.fechaNacimiento.split('-')[1]),
      int.parse(widget.driverSession.fechaNacimiento.split('-')[2].substring(0,2)),
    );
    birthdaySelected = DateTimeExtension.dateFromString(widget.driverSession.fechaNacimiento);
    Permission.camera.request();
    Permission.photos.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        centerTitle: true,
        title: Text(
          'Mi perfil',
          style: TextStyle(color: blackColor),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: createContent() 
        ),
      ),
    );
  }
  Widget createContent(){
    return InkWellCustom(
      onTap: () => FocusScope.of(context).requestFocus( FocusNode()),
      child: Form(
        key: formKey,
        child: Container(
          color: Color(0xffeeeeee),
          child: Column(
            children: <Widget>[
              Container(
                color: whiteColor,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(bottom: 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(50.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: GestureDetector(
                          child: createUserPhoto(),
                          onTap: (){selectCamera();},
                        )
                      ),
                    ),
                    Expanded(
                      child: Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            initialValue: widget.driverSession.name,
                            style: textStyle,
                            enabled: false,
                            decoration: InputDecoration(
                              fillColor: whiteColor,
                              labelStyle: textStyle,
                              hintStyle: TextStyle(color: Colors.white),
                              counterStyle: textStyle,
                              hintText: 'Nombres',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                              )
                            ),
                            onChanged: (String _firstName) {
                              newNames = _firstName;
                            },
                          ),
                          TextFormField(
                            style: textStyle,
                            enabled: false,
                            initialValue: widget.driverSession.pName,
                            decoration: InputDecoration(
                              fillColor: whiteColor,
                              labelStyle: textStyle,
                              hintStyle: TextStyle(color: Colors.white),
                              counterStyle: textStyle,
                              hintText: 'Apellido paterno',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                              )
                            ),
                            onChanged: (String _lastName) {
                              newFName = _lastName;
                            },
                          ),
                          TextFormField(
                            style: textStyle,
                            enabled: false,
                            initialValue: widget.driverSession.mName,
                            decoration: InputDecoration(
                              fillColor: whiteColor,
                              labelStyle: textStyle,
                              hintStyle: TextStyle(color: Colors.white),
                              counterStyle: textStyle,
                              hintText: 'Apellido materno',
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                              )
                            ),
                            onChanged: (String _lastName) {
                              newMName = _lastName;
                            },
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                color: whiteColor,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                'Número de celular',
                                style: textStyle,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              initialValue: widget.driverSession.phone,
                              style: textStyle,
                              enabled: false,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                fillColor: whiteColor,
                                labelStyle: textStyle,
                                hintStyle: TextStyle(color: Colors.white),
                                counterStyle: textStyle,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white
                                  )
                                )
                              ),
                              onChanged: (String _phone) {
                                newPhone = _phone;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                'Correo electrónico',
                                style: textStyle,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              initialValue: widget.driverSession.email,
                              keyboardType: TextInputType.emailAddress,
                              style: textStyle,
                              decoration: InputDecoration(
                                fillColor: whiteColor,
                                labelStyle: textStyle,
                                hintStyle: TextStyle(color: Colors.white),
                                counterStyle: textStyle,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white
                                  )
                                )
                              ),
                              onChanged: (String _email) {
                                newEmail = _email;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    /* Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                'Género',
                                style: textStyle,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child:DropdownButtonHideUnderline(
                              child: Container(
                                // padding: EdgeInsets.only(bottom: 12.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(),
                                  isEmpty: selectedGender == null,
                                  child:DropdownButton<String>(
                                    hint:Text('Género',style: textStyle,),
                                    value: selectedGender,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedGender = newValue;
                                      });
                                    },
                                    items: listGender.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value['id'],
                                        child:Text(value['name'],style: textStyle,),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                    ), */
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                'Fecha de nacimiento',
                                style: textStyle,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child:  GestureDetector(
                              onTap: () async {
                                /* showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _buildBottomPicker(
                                      CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.date,
                                        initialDateTime: date,
                                        onDateTimeChanged: (DateTime newDateTime) {
                                          setState(() {
                                            date = newDateTime;
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ); */
                                final selectedDate = await selectDate(context);
                                if(selectedDate != null){
                                  if(selectedDate.isAfter(DateTime.now())){
                                    Dialogs.alert(context,title: 'Error', message: 'Seleccione una fecha anterior a la actual');
                                  }else{
                                    birthdaySelected = selectedDate;
                                    setState(() {});
                                  }
                                }
                              },
                              child: InputDropdown(
                                valueText: DateTimeExtension.parseDateSpanishV2(birthdaySelected),
                                valueStyle: TextStyle(color: blackColor),
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                'Dirección',
                                style: textStyle,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child:  GestureDetector(
                              onTap: () async {
                                final Place placeSelected = await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectAddress()));
                                if(placeSelected == null) return;
                                newAddress = placeSelected.name;
                                setState(() {});
                              },
                              child: InputDropdown(
                                valueText: reduceAddressLength(newAddress),
                                valueStyle: TextStyle(color: blackColor),
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child:ButtonTheme(
                        height: 45.0,
                        minWidth: MediaQuery.of(context).size.width-50,
                        child: RaisedButton.icon(
                          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
                          elevation: 0.0,
                          color: primaryColor,
                          icon:Text(''),
                          label:Text('Guardar', style: headingBlack,),
                          onPressed: (){
                            submit();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  String reduceAddressLength(String address){
    if(address == null) return '';
    if(address.length < 30) return address;
    return address.substring(0, 30) + '...';
  }
  Future<DateTime> selectDate(BuildContext context) async {  
    DateTime pickedDateTime = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(1900), 
      lastDate: DateTime(2100),
      locale: Locale('es','ES'),
    );
    return pickedDateTime;
  }
  Widget createUserPhoto(){
    if(widget.driverSession.imageUrl.isEmpty || widget.driverSession.imageUrl == null){
      if(_image == null){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/image/empty_user_photo.png')
        );
      }else{
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: FileImage(_image),
        );
      }
    }else{
      if(_image == null){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(
             widget.driverSession.imageUrl,
          )
        );
      }else{
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: FileImage(_image),
        );
      }
    }
  }
}
