import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:HTRuta/features/ClientTaxiApp/Apis/pickup_api.dart';
import 'package:HTRuta/features/ClientTaxiApp/utils/user_preferences.dart';
import 'package:HTRuta/app/components/dialogs.dart';


class IzipayWebView extends StatelessWidget {
  // final Completer<WebViewController> _controller = Completer<WebViewController>();
  final pickupApi = PickupApi();
  final prefs = UserPreferences();
  final PageController pageController;
  final Function(bool) onPaymentComplete;
  final String ammount; 
  IzipayWebView({this.pageController, this.onPaymentComplete, this.ammount});
  /* @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  } */
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: WebView(
        initialUrl: 'https://biensalud.pe/api/payment/form?userid=${8}&amount=${ammount}',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          // _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest request) async {
          print(request.url);
          if (request.url.startsWith('https://biensalud.pe/api/payment/success')) {
            Dialogs.openLoadingDialog(context);
            bool success = await pickupApi.chargeWallet(prefs.idChoferReal, double.parse(ammount.substring(0, 2)));
            Navigator.pop(context);
            if(!success){
              Dialogs.alert(context, title: 'Error', message: 'No se pudo completar el pago');
            }else{
              pageController.jumpToPage(0);
            }
            return onPaymentComplete(true);
          }else{
            Dialogs.alert(context, title: 'Error', message: 'No se pudo completar el pago');
            return onPaymentComplete(false);
          }
        },
        onPageStarted: (String url) {
        },
        /* onPageFinished: (String url) {
          setState(() {
            isLoading = false;
          });
        }, */
        gestureNavigationEnabled: true,
      ),
    );
  }
}