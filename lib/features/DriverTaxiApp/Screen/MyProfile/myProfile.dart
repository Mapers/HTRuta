import 'dart:convert';
import 'package:HTRuta/app/colors.dart';
import 'package:HTRuta/app/styles/style.dart';
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
import 'package:cached_network_image/cached_network_image.dart';

const double _kPickerSheetHeight = 216.0;

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
  final pickupApi = PickupApi();
  final _prefs = UserPreferences();
  var _image;
  String newNames;
  String newFName;
  String newMName;
  String newPhone;
  String newEmail;

  Future getImageLibrary() async {
    // ignore: deprecated_member_use
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 700);
    setState(() {
      _image = gallery;
    });
    List<int> imageBytes = gallery.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    bool success = await pickupApi.uploadPhoto(_prefs.idChoferReal, base64Image);
    print(success);
  }

  Future cameraImage() async {
    // ignore: deprecated_member_use
    var pickImage = ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 700);
    var image = await pickImage;
    setState(() {
      _image = image;
    });
  }


  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
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
    final FormState form = formKey.currentState;
    form.save();
    await session.setDriverData(
      newNames ?? widget.driverSession.mName,
      newFName ?? widget.driverSession.pName,
      newMName ?? widget.driverSession.mName,
      newPhone ?? widget.driverSession.phone,
      newEmail ?? widget.driverSession.email,
      widget.driverSession.dni,
      selectedGender,
      date.year.toString() + '-' + date.month.toString() + '-' + date.day.toString(),
      widget.driverSession.fechaRegistro
    );
    SaveProfileBody body = SaveProfileBody(
      iIdUsuario: _prefs.idChoferReal,
      nombres: newNames ?? widget.driverSession.mName,
      apellidoPaterno: newFName ?? widget.driverSession.pName,
      apellidoMaterno: newMName ?? widget.driverSession.mName,
      fechaNacimiento: date ?? DateTime.now(),
      sexo: selectedGender,
      telefono: newPhone ?? widget.driverSession.phone,
      celular: newPhone ?? widget.driverSession.phone
    );
    bool profileSavedSuccess = await pickupApi.saveProfile(body);
    print('resultado: ' + profileSavedSuccess.toString());
    if(!profileSavedSuccess){
      Dialogs.alert(context,title: 'Error', message: 'Ocurrió un error, volver a intentarlo');
    }else{
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    selectedGender = widget.driverSession.sexo;
    print(widget.driverSession.fechaNacimiento);
    date = DateTime(
      int.parse(widget.driverSession.fechaNacimiento.split('-')[0]),
      int.parse(widget.driverSession.fechaNacimiento.split('-')[1]),
      int.parse(widget.driverSession.fechaNacimiento.split('-')[2]),
    );
    print(widget.driverSession.fechaNacimiento);
    super.initState();
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
                        child: _image == null
                          ? GestureDetector(
                          onTap: (){selectCamera();},
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            color: primaryColor,
                            child: Hero(
                              tag: 'avatar_profile',
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                backgroundImage: CachedNetworkImageProvider(
                                  'https://source.unsplash.com/300x300/?portrait',
                                )
                              ),
                            ),
                          )
                        ): GestureDetector(
                          onTap: () {selectCamera();},
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            child: Image.file(_image,fit: BoxFit.cover, height: 800.0,width: 80.0,),
                          )
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
                              enabled: false,
                              readOnly: true,
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
                              /* onChanged: (String _email) {
                                newEmail = _email;
                              }, */
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
                              onTap: () {
                                showCupertinoModalPopup<void>(
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
                                );
                              },
                              child: InputDropdown(
                                valueText: date.toString().substring(0, 10),
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
}
