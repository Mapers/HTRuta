import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HTRuta/DriverTaxiApp/Components/ink_well_custom.dart';
import 'package:HTRuta/DriverTaxiApp/Components/inputDropdown.dart';
import 'package:HTRuta/DriverTaxiApp/theme/style.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

const double _kPickerSheetHeight = 216.0;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> listGender = [{"id": '0',"name" : 'Masculino',},{"id": '1',"name" : 'Femenino',}];
  String selectedGender;
  String lastSelectedValue;
  DateTime date = DateTime.now();
  var _image;

  Future getImageLibrary() async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 700);
    setState(() {
      _image = gallery;
    });
  }

  Future cameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 700);
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

  selectCamera () {
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

  submit(){
    final FormState form = formKey.currentState;
    form.save();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        title: Text(
          'My profile',
          style: TextStyle(color: blackColor),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: InkWellCustom(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                              child: new ClipRRect(
                                  borderRadius: new BorderRadius.circular(100.0),
                                  child:_image == null
                                      ?new GestureDetector(
                                      onTap: (){selectCamera();},
                                      child: new Container(
                                          height: 80.0,
                                          width: 80.0,
                                          color: primaryColor,
                                          child: new Image.asset('assets/image/icon/avatar.png',fit: BoxFit.cover, height: 80.0,width: 80.0,)
                                      )
                                  ): new GestureDetector(
                                      onTap: () {selectCamera();},
                                      child: new Container(
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
                                  TextField(
                                    style: textStyle,
                                    decoration: InputDecoration(
                                        fillColor: whiteColor,
                                        labelStyle: textStyle,
                                        hintStyle: TextStyle(color: Colors.white),
                                        counterStyle: textStyle,
                                        hintText: "First Name",
                                        border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white))),
                                    controller:
                                        new TextEditingController.fromValue(
                                      new TextEditingValue(
                                        text: "First Name",
                                        selection: new TextSelection.collapsed(
                                            offset: 11),
                                      ),
                                    ),
                                    onChanged: (String _firstName) {

                                    },
                                  ),
                                  TextField(
                                    style: textStyle,
                                    decoration: InputDecoration(
                                        fillColor: whiteColor,
                                        labelStyle: textStyle,
                                        hintStyle: TextStyle(color: Colors.white),
                                        counterStyle: textStyle,
                                        hintText: "Last Name",
                                        border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white))),
                                    controller:
                                        new TextEditingController.fromValue(
                                      new TextEditingValue(
                                        text: "Last Name",
                                        selection: new TextSelection.collapsed(
                                          offset: 11
                                        ),
                                      ),
                                    ),
                                    onChanged: (String _lastName) {

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
                                        "Phone Number",
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      style: textStyle,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                          fillColor: whiteColor,
                                          labelStyle: textStyle,
                                          hintStyle: TextStyle(color: Colors.white),
                                          counterStyle: textStyle,
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white))
                                      ),
                                      controller: new TextEditingController.fromValue(
                                        new TextEditingValue(
                                          text: "03584565656",
                                          selection: new TextSelection.collapsed(
                                              offset: 11),
                                        ),
                                      ),
                                      onChanged: (String _phone) {

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
                                        "Email",
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: textStyle,
                                      decoration: InputDecoration(
                                          fillColor: whiteColor,
                                          labelStyle: textStyle,
                                          hintStyle:
                                          TextStyle(color: Colors.white),
                                          counterStyle: textStyle,
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white))
                                      ),
                                      controller: new TextEditingController.fromValue(
                                        new TextEditingValue(
                                          text: "abc@example.com",
                                          selection: new TextSelection.collapsed(
                                              offset: 11),
                                        ),
                                      ),
                                      onChanged: (String _email) {

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
                                        "Gender",
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: new DropdownButtonHideUnderline(
                                        child: Container(
                                         // padding: EdgeInsets.only(bottom: 12.0),
                                          child: new InputDecorator(
                                            decoration: const InputDecoration(
                                            ),
                                            isEmpty: selectedGender == null,
                                            child: new DropdownButton<String>(
                                              hint: new Text("Gender",style: textStyle,),
                                              value: selectedGender,
                                              isDense: true,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  selectedGender = newValue;
                                                  print(selectedGender);
                                                });
                                              },
                                              items: listGender.map((value) {
                                                return new DropdownMenuItem<String>(
                                                  value: value['id'],
                                                  child: new Text(value['name'],style: textStyle,),
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
                                        "Birthday",
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
                                        child: new InputDropdown(
                                          valueText: DateFormat.yMMMMd().format(date),
                                          valueStyle: TextStyle(color: blackColor),
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: new ButtonTheme(
                                height: 45.0,
                                minWidth: MediaQuery.of(context).size.width-50,
                                child: RaisedButton.icon(
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                                  elevation: 0.0,
                                  color: primaryColor,
                                  icon: new Text(''),
                                  label: new Text('SAVE', style: headingBlack,),
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
          ),
        ),
      ),
    );
  }
}
