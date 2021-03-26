import 'package:HTRuta/core/push_message/push_message.dart';
import 'package:HTRuta/features/features_driver/home/entities/interprovincial_request_entity.dart';
import 'package:meta/meta.dart';

class InterprovincialFcmDataRemote{
  final PushMessage pushMessage;
  InterprovincialFcmDataRemote({@required this.pushMessage});

  Future<void> sendNotificationCounterOfferInRequest(InterprovincialRequestEntity request) async{
    bool status = await pushMessage.sendPushMessage(
      token: request.passengerFcmToken,
      title: 'Ha recibido una contraoferta',
      description: 'Revisa la propuesta del Driver.',
      data: {}
    );
    print('status');
    print(status);
  }
}