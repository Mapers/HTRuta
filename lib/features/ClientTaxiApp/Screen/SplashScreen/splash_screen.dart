import 'dart:async';
import 'dart:math' as math;

import 'package:HTRuta/features/ClientTaxiApp/Provider/app_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/onboarding_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Loading/loading_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/app_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  final Session _session =  Session();
  final OnBoardingApi onboardingApi = OnBoardingApi();
  Onboarding dataOnBoarding;
  VideoPlayerController _controller;
  Animation<double> rotacion;

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    rotacion = Tween(
      begin: 0.0,
      end: 2 * math.pi
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubic
      )
    );
    _controller = VideoPlayerController.asset('assets/intro-miruta.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
    animationController.forward();
    Timer( Duration(seconds: 3), () async{
      final _prefsInstance = await SharedPreferences.getInstance();
      if (_prefsInstance.getBool('first_run') ?? true) {
        FlutterSecureStorage storage = FlutterSecureStorage();
        await storage.deleteAll();
        _prefsInstance.setBool('first_run', false);
      }
      final data = await _session.get();
      final appServicesProvider = Provider.of<AppServicesProvider>(context,listen: false);
      await appServicesProvider.loadAppServices();
      if(data != null){
        if(data.smsCode != null || data.smsCode != ''){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
        }else{
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.loginScreen, (Route<dynamic> route) => false);
        }
      }else{
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.loginScreen, (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: _controller.value.initialized ? 
                  VideoPlayer(_controller):
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Color(0xFFFFD428)
                  )
              ),
            ),
          ),
        ],
      )
    );
  }
}
