import 'package:HTRuta/app/colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../app/styles/style.dart';

class UseMyLocation extends StatefulWidget {
  @override
  _UseMyLocationState createState() => _UseMyLocationState();
}

class _UseMyLocationState extends State<UseMyLocation> with SingleTickerProviderStateMixin{
  Animation fadeAnimation;
  AnimationController animationController;

  Map<Permission, PermissionStatus> permissions;
  Map<Permission, PermissionStatus> permissionRequestResult;
  bool isGrantedLocation = false;

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> requestPermission() async {
    isGrantedLocation = await Permission.location.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: new Container(
              decoration: new BoxDecoration(color: whiteColor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          child: FadeTransition(
                              opacity: fadeAnimation,
                              child:
                              Image.asset("assets/image/6409.jpg",height: 200.0,)
                          ),
                        ),
                        SizedBox(height: 30),
                        Text('Habilita tu ubicación', style: heading35Black,
                        ),
                        Container(
                          padding: new EdgeInsets.only(left: 60.0, right: 60.0),
                          child: new Text('Elija su ubicación para comenzar a encontrar la solicitud a su alrededor',
                            style: textStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height:30),
                        ButtonTheme(
                          minWidth: screenSize.width*0.43,
                          height: 45.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                            elevation: 0.0,
                            color: primaryColor,
                            child: new Text('Usa mi localizacion'.toUpperCase(),style: headingWhite,
                            ),
                            onPressed: (){
                              requestPermission()?.then((_){
                                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                              });
                            },
                          ),
                        ),
                        SizedBox(height:20),
                        InkWell(
                          onTap: (){
                            requestPermission()?.then((_){
                              Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                            });
                          },
                          child: Text('Saltar por ahora',style: textGrey,),
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
