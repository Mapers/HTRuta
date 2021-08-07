import 'package:HTRuta/features/ClientTaxiApp/Screen/Carga/carga_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Directions/screens/cancellation_reasons_screen/cancellation_reasons_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Directions/screens/chat_screen/chat_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/History/driver_detail.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/History/history_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Home/home2.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Home/home_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Home/travel_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Login/login.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Login/phone_verification.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/MyProfile/profile.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Notification/notification.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Payment/driver_payments_method.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/PaymentMethod/payment_method.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/ReviewTrip/review_trip_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Settings/settings.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/Settings/terms_conditions_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SignUp/sign_up_step1.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/SplashScreen/splash_screen.dart';
import 'package:HTRuta/features/ClientTaxiApp/Screen/intro_screen/intro_screen.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/History/history.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/register_driver.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/send_documents.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Home/travelDriver_screen.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyProfile/profile.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyWallet/myWallet.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/MyWallet/payment.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Notification/notification.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Request/request_screen.dart';
import 'package:HTRuta/features/DriverTaxiApp/Screen/Settings/settings.dart';
import 'package:flutter/material.dart';

class PageViewTransition<T> extends MaterialPageRoute<T> {
  PageViewTransition({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse) return super.buildTransitions(context, animation, secondaryAnimation, child);
    return FadeTransition(opacity: animation, child: child);
  }
}

class AppRoute {
  static const String splashScreen = '/splashScreen';
  static const String loginScreen = '/login';
  static const String signUpScreen = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String introScreen = '/intro';
  static const String phoneVerificationScreen = '/PhoneVerification';
  static const String newsLetter = '/newsLetter';
  static const String homeScreen = '/home';
  static const String homeScreen2 = '/home2';
  static const String searchScreen = '/search';
  static const String notificationScreen = '/notification';
  static const String profileScreen = '/profile';
  static const String paymentMethodScreen = '/paymentMethod';
  static const String historyScreen = '/history';
  static const String driverDetailScreen = '/driverDetail';
  static const String settingsScreen = '/settings';
  static const String reviewTripScreen = '/reviewTrip';
  static const String cancellationReasonsScreen = '/cancellationReasons';
  static const String termsConditionsScreen = '/termsConditions';
  static const String chatScreen = '/chat';
  static const String cargaScreen = '/carga';
  static const String requestDriverScreen = '/request_driver';
  static const String walletDriverScreen = '/my_wallet_driver';
  // static const String walletDriverScreen = '/my_wallet_driver';
  static const String historyDriverScreen = '/history_driver';
  static const String notificationDriverScreen = '/notification_driver';
  static const String settingsDriverScreen = '/setting_driver';
  static const String logoutDriverScreen = '/logout_driver';
  static const String profileDriverScreen = '/profile_driver';
  static const String editProfileDriverScreen = 'edit_prifile_driver';
  static const String paymentMethodDriverScreen = 'payment_method_driver';
  static const String registerDriverScreen = '/register_driver';
  static const String sendDocumentScreen = '/send_document';
  static const String travelScreen = '/travelScreen';
  static const String travelDriverScreen = '/travelDriverScreen';
  static const String driverPaymentMethods = '/paymentMethods';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return PageViewTransition(builder: (_) => SplashScreen());
      case loginScreen:
        return PageViewTransition(builder: (_) => LoginScreen());
      case introScreen:
        return PageViewTransition(builder: (_) => IntroScreen());
      case phoneVerificationScreen:
        return PageViewTransition(builder: (_) => PhoneVerification());
      case homeScreen:
        return PageViewTransition(builder: (_) => HomeScreens());
      case homeScreen2:
        return PageViewTransition(builder: (_) => HomeScreen2());
      case signUpScreen:
        return PageViewTransition(builder: (_) => SignUpStep1());
      case notificationScreen:
        return PageViewTransition(builder: (_) => NotificationScreens());
      case profileScreen:
        return PageViewTransition(builder: (_) => ProfileScreen());
      case paymentMethodScreen:
        return PageViewTransition(builder: (_) => PaymentMethodScreen());
      case historyScreen:
        return PageViewTransition(builder: (_) => HistoryScreen());
      case settingsScreen:
        return PageViewTransition(builder: (_) => SettingsScreen());
      case reviewTripScreen:
        return PageViewTransition(builder: (_) => ReviewTripScreen());
      case cancellationReasonsScreen:
        return PageViewTransition(builder: (_) => CancellationReasonsScreen());
      case termsConditionsScreen:
        return PageViewTransition(builder: (_) => TermsConditionsScreen());
      case driverDetailScreen:
        return PageViewTransition(builder: (_) => DriverDetailScreen());
      case chatScreen:
        return PageViewTransition(builder: (_) => ChatScreen());
      case cargaScreen:
        return PageViewTransition(builder: (_) => CargaPage());
      case requestDriverScreen:
        return PageViewTransition(builder: (_) => RequestDriverScreen());
      case walletDriverScreen:
        return PageViewTransition(builder: (_) => MyWalletDriver());
      case historyDriverScreen:
        return PageViewTransition(builder: (_) => HistoryDriverScreen());
      case notificationDriverScreen:
        return PageViewTransition(builder: (_) => NotificationDriverScreens());
      case settingsDriverScreen:
        return PageViewTransition(builder: (_) => SettingsDriverScreen());
      case driverPaymentMethods:
        return PageViewTransition(builder: (_) => DriverPaymentsMethods());
      case paymentMethodDriverScreen:
        return PageViewTransition(builder: (_) => PaymentMethodDriver());
      case profileDriverScreen:
        return PageViewTransition(builder: (_) => ProfileDriver());
      case registerDriverScreen:
        return PageViewTransition(builder: (_) => RegisterDriverPage());
      case sendDocumentScreen:
        return PageViewTransition(builder: (_) => SendDocumentPage());
      case travelScreen:
        return PageViewTransition(builder: (_) => TravelScreen());
      case travelDriverScreen:
        return PageViewTransition(builder: (_) => TravelDriverScreen());
      default:
        return PageViewTransition(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}')),
          )
        );
    }
  }
}
