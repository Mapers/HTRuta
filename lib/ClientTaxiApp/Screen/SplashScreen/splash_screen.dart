import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Apis/onboarding_api.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:flutter_map_booking/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:flutter_map_booking/ClientTaxiApp/theme/style.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/session.dart';
import 'package:flutter_map_booking/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  Animation animation, delayedAnimation, muchDelayAnimation, transfor,fadeAnimation;
  AnimationController animationController;
  final Session _session = new Session();
  final _prefs = PreferenciaUsuario();
  final OnBoardingApi onboardingApi = OnBoardingApi();
  Onboarding dataOnBoarding;


  @override
  void initState(){
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn
    ));
    
    transfor = BorderRadiusTween(
      begin: BorderRadius.circular(125.0),
      end: BorderRadius.circular(0.0)).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease)
    );
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
    new Timer(new Duration(seconds: 3), () async{
      final data = await _session.get();
      await _prefs.initPrefs();
      final providerOnBoarding = Provider.of<OnBoardingProvider>(context,listen: false);
      if(data != null){
        if(data['correo'] != null || data['correo'] != ''){
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeScreen, (route) => false);
        }else{
          if(_prefs.primeraSesion){
            dataOnBoarding = await onboardingApi.getOnBoardingData();
            providerOnBoarding.listItem = dataOnBoarding.data;
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.introScreen, (Route<dynamic> route) => false);
          }else{
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.loginScreen, (Route<dynamic> route) => false);
          }
        }
      }else{
        if(_prefs.primeraSesion){
          dataOnBoarding = await onboardingApi.getOnBoardingData();
          providerOnBoarding.listItem = dataOnBoarding.data;
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.introScreen, (Route<dynamic> route) => false);
        }else{
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.loginScreen, (Route<dynamic> route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: new Container(
              decoration: new BoxDecoration(color: Color(0XFFF3E700)),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                      flex: 1,
                      child: new Center(
                          child: FadeTransition(
                              opacity: fadeAnimation,
                              child:
                              Image.asset("assets/image/logosplash.png",height: 200.0,)
                          ),
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
