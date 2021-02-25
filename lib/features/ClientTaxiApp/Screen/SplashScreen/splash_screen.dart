import 'dart:async';

import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/onboarding_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/shared_preferences.dart';
import 'package:HTRuta/app_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  Animation animation, delayedAnimation, muchDelayAnimation, transfor,fadeAnimation;
  AnimationController animationController;
  final Session _session =  Session();
  final _prefs = PreferenciaUsuario();
  final OnBoardingApi onboardingApi = OnBoardingApi();
  Onboarding dataOnBoarding;


  @override
  void initState(){
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this
    );

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
      Timer( Duration(seconds: 3), () async{
        final data = await _session.get();
        await _prefs.initPrefs();
        final providerOnBoarding = Provider.of<OnBoardingProvider>(context,listen: false);
        if(data != null){
          if(data['correo'] != null || data['correo'] != ''){
            Navigator.pushNamedAndRemoveUntil(context, AppRoute.homeClientScreen, (route) => false);
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
          body:  Container(
            decoration:  BoxDecoration(color: Color(0XFFF3E700)),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child:  Center(
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
