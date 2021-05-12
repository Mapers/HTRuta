import 'dart:async';
import 'dart:math' as math;

import 'package:HTRuta/app/navigation/routes.dart';
import 'package:HTRuta/data/remote/service_data_remote.dart';
import 'package:HTRuta/entities/service_in_course_entity.dart';
import 'package:HTRuta/enums/type_entity_enum.dart';
import 'package:HTRuta/features/feature_client/home/data/datasources/remote/interprovincial_client_data_firebase.dart';
import 'package:HTRuta/features/feature_client/home/presentation/bloc/client_service_bloc.dart';
import 'package:HTRuta/features/feature_client/home/screens/interprovincial_client/pages/map_coordenation_passenger.dart';
import 'package:HTRuta/features/features_driver/home/presentations/bloc/driver_service_bloc.dart';
import 'package:HTRuta/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/onboarding_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/Model/onboarding_model.dart';
import 'package:HTRuta/features/ClientTaxiApp/Provider/onboarding_provider.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/session.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      // final availabilityProvider = Provider.of<AvailabilityProvider>(context,listen: false);
      if(data != null){
        if(data.email != null || data.email != ''){
          // availabilityProvider.available = _prefs.drivingState;
          _sendToPage();
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

  // void _showDialogQualification() async{
  //   InterprovincialClientDataLocal interprovincialClientDataLocal = getIt<InterprovincialClientDataLocal>();
  //   String documentId = interprovincialClientDataLocal.getDocumentIdOnServiceInterprovincialToQualification;
  //   if(documentId == null){
  //     return;
  //   }
  //   InterprovincialClientDataFirebase interprovincialClientDataFirebase = getIt<InterprovincialClientDataFirebase>();
  //   bool onService = await interprovincialClientDataFirebase.checkIfInterprovincialLocationDriverEntityOnService(documentId: documentId);
  //   if(!onService){
  //     //! Considerar traer del backend los datos el driver
  //     showDialog(
  //       context: context,
  //       child: QualificationWidget(
  //         title: 'Califica el servicio',
  //         nameUserQuelify: '',
  //         routeTraveled: '',
  //         onAccepted: (stars, comments){
  //           //! Enviar calificacion al server
  //           interprovincialClientDataLocal.deleteDocumentIdOnServiceInterprovincialToQualification;
  //         },
  //         onSkip: (){
  //           interprovincialClientDataLocal.deleteDocumentIdOnServiceInterprovincialToQualification;
  //         },
  //       )
  //     );
  //   }
  // }
  void _sendToPage() async{
    ServiceDataRemote serviceDataRemote = getIt<ServiceDataRemote>(); 
    ServiceInCourseEntity serviceInCourse = await serviceDataRemote.getServiceInCourse();
    if(serviceInCourse == null){
      Navigator.of(context).pushAndRemoveUntil(Routes.toHomePassengerPage(), (_) => false);
      return;
    }
    print('###################');
    print(serviceInCourse.entityType );
    print(serviceInCourse.passengerDocumentId);
    print(serviceInCourse.requestDocumentId);
    print(serviceInCourse.serviceDocumentId);
    print(serviceInCourse.serviceType );
    print('###################');

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
        
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MapCoordenationDrivePage(
          serviceInCourse.serviceDocumentId,
          // availablesRoutesEntity: ,
          // interprovincialRequest: ,
          passengerDocumentId:serviceInCourse.passengerDocumentId,
        )), (_) => false);
      }
    }
    // _showDialogQualification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /* Transform.scale(
            scale: MediaQuery.of(context).size.aspectRatio /
              _controller.value.aspectRatio,
            child: Center(
              child: Container(
              child: _controller.value.initialized
                ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // aspectRatio: MediaQuery.of(context).size.aspectRatio,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayer(_controller)
                  ),
                )
                : AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // aspectRatio: MediaQuery.of(context).size.aspectRatio,
                  child: Container(
                    child: Image.asset(
                      'assets/first_frame.jpg',
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    )
                    ),
                  )
              ),
            ),
          ), */
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
