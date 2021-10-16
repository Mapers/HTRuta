import 'dart:io';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Camera/take_picture_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/features/ClientTaxiApp/Components/inputDropdown.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/place_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/save_profile_body.dart';
import 'package:HTRuta/app/components/dialogs.dart';
import 'package:HTRuta/core/utils/extensions/datetime_extension.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/select_address.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  final UserSession userData;
  EditProfile(this.userData);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> listGender = [{'id': '1','name' : 'Masculino',},{'id': '2','name' : 'Femenino'}];
  String selectedGender;
  String lastSelectedValue;
  String photoUrl;
  DateTime birthdaySelected;
  final pickupApi = PickupApi();
  File _image;
  String newNames;
  String newFName;
  String newMName;
  String newPhone;
  String newEmail;
  String newAddress;
  final session = Session();

  Future getImageLibrary() async {
    // ignore: deprecated_member_use
    /* File gallery = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 700);
    setState(() {
      _image = gallery;
    }); */
    try{
      // FileWrapper gallery = await getImage();
      // ignore: deprecated_member_use
      File gallery = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700);
      if(gallery == null) return;
      _image = gallery;
      setState(() {});
    }catch(e){
      print(e);
      Dialogs.alert(context,title: 'Error', message: 'No se pudo obtener la imagen, inténtelo nuevamente');
    }
  }
  

  Future cameraImage() async {
    /* final List<Media> images = await ImagesPicker.openCamera(
      pickType: PickType.video,
      maxTime: 15, // record video max time
    ); */
    // final image = images.first.path;
    // ignore: deprecated_member_use
    /* var image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 700);
    setState(() {
      _image = image;
    }); */
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
        title: const Text('Selecciona Camara'),
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
      final url = await pickupApi.uploadImage(_image, widget.userData.id);
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
      iIdUsuario: widget.userData.id,
      nombres: newNames ?? widget.userData.names,
      apellidoPaterno: newFName ?? widget.userData.lastNameFather,
      apellidoMaterno: newMName ?? widget.userData.lastNameMother,
      fechaNacimiento: birthdaySelected,
      sexo: selectedGender,
      telefono: newPhone ?? widget.userData.cellphone,
      celular: newPhone ?? widget.userData.cellphone,
      userAddress: newAddress,
      correo: newEmail ?? widget.userData.email
    );
    bool profileSavedSuccess = await pickupApi.saveProfile(body);
    print('resultado: ' + profileSavedSuccess.toString());
    if(!profileSavedSuccess){
      Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
      return;
    }
    await session.set(
      widget.userData.id,
      widget.userData.dni,
      newNames ?? widget.userData.names,
      newFName ?? widget.userData.lastNameFather,
      newMName ?? widget.userData.lastNameMother,
      newPhone ?? widget.userData.cellphone,
      newEmail,
      widget.userData.password,
      photoUrl ?? widget.userData.imageUrl,
      selectedGender,
      widget.userData.smsCode,
      DateTimeExtension.parseDateEnglishV2(birthdaySelected),
      widget.userData.fechaRegistro,
      newAddress,
      widget.userData.referencia,
    );
    final driverData = await session.getDriverData();
    if(driverData != null){
      await session.setDriverData(
        newNames ?? widget.userData.names,
        newFName ?? widget.userData.lastNameFather,
        newMName ?? widget.userData.lastNameMother,
        newPhone ?? widget.userData.cellphone,
        newEmail,
        widget.userData.dni,
        selectedGender,
        DateTimeExtension.parseDateEnglishV2(birthdaySelected),
        widget.userData.fechaRegistro,
        photoUrl ?? widget.userData.imageUrl,
        widget.userData.smsCode,
        newAddress,
        widget.userData.referencia,
        driverData.metodosPago,
        driverData.saldo
      );
    }else{
      await session.setDriverData(
        newNames ?? widget.userData.names,
        newFName ?? widget.userData.lastNameFather,
        newMName ?? widget.userData.lastNameMother,
        newPhone ?? widget.userData.cellphone,
        newEmail,
        widget.userData.dni,
        selectedGender,
        DateTimeExtension.parseDateEnglishV2(birthdaySelected),
        widget.userData.fechaRegistro,
        photoUrl ?? widget.userData.imageUrl,
        widget.userData.smsCode,
        newAddress,
        widget.userData.referencia,
        '',
        0
      );
    }
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    newAddress = widget.userData.direccion;
    selectedGender = widget.userData.sexo;
    birthdaySelected = DateTimeExtension.dateFromString(widget.userData.fechaNacimiento);
    newEmail = widget.userData.email;
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
        title: Text(
          'Editar perfil',
          style: TextStyle(color: blackColor),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 20.0),
        child: ButtonTheme(
          height: 50.0,
          minWidth: MediaQuery.of(context).size.width-50,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            elevation: 0.0,
            color: primaryColor,
            icon: Text(''),
            label: Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 22)),
            onPressed: (){
              submit();
            },
          ),
        ),
      ),
      body: Scrollbar(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: InkWellCustom(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                                        initialValue: widget.userData.names,
                                        style: textStyle,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          fillColor: whiteColor,
                                          labelStyle: textStyle,
                                          hintStyle: TextStyle(color: Colors.white),
                                          counterStyle: textStyle,
                                          hintText: 'Nombres',
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white
                                            )
                                          )
                                        ),
                                        onChanged: (String _firstName) {
                                          newNames = _firstName;
                                        },
                                      ),
                                      TextFormField(
                                        initialValue: widget.userData.lastNameFather,
                                        style: textStyle,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          fillColor: whiteColor,
                                          labelStyle: textStyle,
                                          hintStyle: TextStyle(color: Colors.white),
                                          counterStyle: textStyle,
                                          hintText: 'Apellido paterno',
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white
                                            )
                                          )
                                        ),
                                        onChanged: (String _lastName) {
                                          newFName = _lastName;
                                        },
                                      ),
                                      TextFormField(
                                        initialValue: widget.userData.lastNameMother,
                                        style: textStyle,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          fillColor: whiteColor,
                                          labelStyle: textStyle,
                                          hintStyle: TextStyle(color: Colors.white),
                                          counterStyle: textStyle,
                                          hintText: 'Apellido materno',
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white
                                            )
                                          )
                                        ),
                                        onChanged: (String _lastName) {
                                          newMName = _lastName;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              )
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
                                        enabled: false,
                                        initialValue: widget.userData.cellphone,
                                        style: textStyle,
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
                                          'Email',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: TextFormField(
                                        initialValue: widget.userData.email,
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
                              Container(
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
                                      child: DropdownButtonHideUnderline(
                                        child: Container(
                                          // padding: EdgeInsets.only(bottom: 12.0),
                                          child: InputDecorator(
                                            decoration: const InputDecoration(
                                            ),
                                            isEmpty: selectedGender == null,
                                            child: DropdownButton<String>(
                                              hint: Text('Género', style: textStyle),
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
                                                  child: Text(value['name'],style: textStyle,),
                                                );
                                              }).toList(),
                                            ),
                                          ),
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
                                          'Fecha de nacimiento',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child:  GestureDetector(
                                        onTap: () async {
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ),
        )
      ),
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
    if(widget.userData.imageUrl.isEmpty || widget.userData.imageUrl == null){
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
             widget.userData.imageUrl,
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
//hhh
