import 'dart:convert';
import 'dart:typed_data';

import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../app_router.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  SwiperController _controller;
  int currentIndex = 0;
  Map<Permission, PermissionStatus> permissions;
  Map<Permission, PermissionStatus> permissionRequestResult;
  PermissionStatus permission;
  bool isGrantedLocation = false;
  List<Map<String, dynamic>> listItem = List<Map<String,dynamic>>();
  final _prefs = PreferenciaUsuario();

  @override
  void initState() {
    super.initState();
  }

  Uint8List obtenerFile(String base64){
    Uint8List bytes;
    bytes = base64Decode(base64);
    return bytes;
  }

  // List<Map<String, dynamic>> listItem = [
  //   {"id": '0',"title" : 'Acepta un trabajo',"description" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry","image" : "assets/image/image_taxi_1.png"},
  //   {"id": '1',"title" : 'Tracking en tiempo real',"description" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry","image" : "assets/image/image_taxi_2.png"},
  //   {"id": '2',"title" : 'Gana dinero',"description" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry","image" : "assets/image/image_taxi_3.png"},
  // ];

  Future<void> requestPermission() async {
//    permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
    isGrantedLocation = await Permission.location.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final providerOnBoarding = Provider.of<OnBoardingProvider>(context);

    return Scaffold(
      body:  Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: screenSize.height*0.09,left: screenSize.width*0.1,right: screenSize.width*0.1),
                child: Column(
                  children: <Widget>[
                    Text(providerOnBoarding.listItem[currentIndex].vchTitulo??'SinData',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(top: 10),
                    //   alignment: Alignment.center,
                    //   child: Text("${listItem[currentIndex]['description']}",
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w500
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: screenSize.height*0.58,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20.0),
                  child: Swiper(
                    curve: Curves.easeInOut,
                    controller: _controller,
                    itemCount: providerOnBoarding.listItem.length,
                    itemHeight: 200.0,
                    viewportFraction: 0.6,
                    scale: 0.6,
                    loop: false,
                    outer: true,
                    index: currentIndex,
                    onIndexChanged: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      // return Container(
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: AssetImage(listItem[index]['image'],),
                      //       fit: BoxFit.cover
                      //     ),
                      //     borderRadius: BorderRadius.circular(10.0)
                      //   ),
                      // );

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.memory(obtenerFile(providerOnBoarding.listItem[index].image64),fit: BoxFit.cover)
                      );
                    },
                    pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotSwiperPaginationBuilder(
                            size: 5.0,
                            activeSize: 10.0,
                            space: 5.0,
                            color: greyColor2,
                            activeColor: blackColor
                        )
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: currentIndex == providerOnBoarding.listItem.length - 1 ?
                Container(
                  padding: EdgeInsets.only(bottom: screenSize.height*0.06,left: screenSize.width*0.1,right: screenSize.width*0.1),
                  child: ButtonTheme(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Text('Ir a la aplicacion',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 16
                        ),
                      ),
                      color: primaryColor,
                      onPressed: (){
                        requestPermission()?.then((_){
                          _prefs.primeraSesion = false;
                          Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.loginScreen, (Route<dynamic> route) => false);
                        });
                      },
                    ),
                  ),
                ):SizedBox.shrink()
              )
            ],
          )
    );
  }
}
