import 'dart:async';
import 'dart:math' as math;

import 'package:HTRuta/features/ClientTaxiApp/Provider/app_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/onboarding_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Loading/loading_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/app_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  final Session _session =  Session();
  final _prefs = UserPreferences();
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
    _controller = VideoPlayerController.asset('assets/splash_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
    animationController.forward();
    Timer( Duration(seconds: 3), () async{
      final data = await _session.get();
      // await _prefs.initPrefs();
      final providerOnBoarding = Provider.of<OnBoardingProvider>(context,listen: false);
      final appServicesProvider = Provider.of<AppServicesProvider>(context,listen: false);
      await appServicesProvider.loadAppServices();
      // final availabilityProvider = Provider.of<AvailabilityProvider>(context,listen: false);
      if(data != null){
        if(data.smsCode != null || data.smsCode != ''){
          // availabilityProvider.available = _prefs.drivingState;
          // _sendToPage();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
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

  /* void _sendToPage() async{
    ServiceDataRemote serviceDataRemote = getIt<ServiceDataRemote>();
    ServiceInCourseEntity serviceInCourse = await serviceDataRemote.getServiceInCourse();
    final data = await _session.get();
    if(serviceInCourse == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadingScreen()));
      // Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
      return;
    }

    if(serviceInCourse.entityType == TypeEntityEnum.driver){
      BlocProvider.of<DriverServiceBloc>(context).add(ChangeDriverServiceEvent(type: serviceInCourse.serviceType));
      Navigator.of(context).pushAndRemoveUntil(Routes.toHomeDriverPage(serviceInCourse: serviceInCourse), (_) => false);
    }else if(serviceInCourse.entityType == TypeEntityEnum.passenger){
      if(serviceInCourse.passengerDocumentId == null  ){
        BlocProvider.of<ClientServiceBloc>(context).add(ChangeClientServiceEvent(type: serviceInCourse.serviceType));
        Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(serviceInCourse: serviceInCourse), (_) => false);
      }else{
          InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
          DataNecessaryRetrieve dataNecessaryRetrieve = await interprovincialClientDataFirebase.getDataNecessaryRetrieve( documentId: serviceInCourse.serviceDocumentId,passengerDocumentId: serviceInCourse.passengerDocumentId);
          InterprovincialRouteInServiceEntity interprovincialRouteInServiceEntity = await serviceDataRemote.getInterprovincialRouteInServiceById( dataNecessaryRetrieve.serviceId );
          AvailableRouteEntity availableRouteEntity = AvailableRouteEntity(
            availableSeats:  int.parse(interprovincialRouteInServiceEntity.id),
            route: interprovincialRouteInServiceEntity,
            documentId: serviceInCourse.serviceDocumentId,
            fcm_token: null,
            id: null,
            routeStartDateTime: interprovincialRouteInServiceEntity.dateStart,
            status: interprovincialRouteInServiceEntity.status,
            vehicleSeatLayout: null
          );
        if( serviceInCourse.passengerDocumentId != null ){
          LocationEntity currentlocation =  await LocationUtil.currentLocation();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MapCoordenationDrivePage(
            serviceInCourse.serviceDocumentId,
            availablesRoutesEntity: availableRouteEntity,
            price: dataNecessaryRetrieve.negotiatedPrice,
            passengerDocumentId:serviceInCourse.passengerDocumentId,
            currentLocation: currentlocation,
            passengerPhone: data.cellphone,
          )), (_) => false);
        }else{
          Navigator.of(context).pushAndRemoveUntil(Routes.toTravelNegotationPage( availablesRoutesEntity: availableRouteEntity, ), (_) => false);
        }
      }
    }
  } */

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
                  Image.asset(
                    'assets/first_frame.jpg',
                  )
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child){
              return Transform.rotate(
                angle: rotacion.value,
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/logosplash.png')
                      )
                    )
                  ),
                )
              );
            }
          )
        ],
      )
    );
  }
}
